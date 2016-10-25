//
//  OffersService.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 15/01/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire
import SwiftyJSON

struct FilterOptions {
    let searchTerm: String?
    let tags: [String]?
    let companyId: Int?
}

struct PaginationInfo {
    let page: Int?
    let perPage: Int?
}

class OffersService: BaseService {
    static let sharedInstance = OffersService()
    
    var highlightedOfferUrl: String {
        let url = "\(offerHostUrl)offers/highlighted"
        if let apiKey = apiKey {
            return url + "/" + apiKey
        }
        return url
    }
    
    func redemptionCodeImageUrl(_ offerId: Int, format: String, width: Int, height: Int) -> String? {
        guard let userToken = UserService.sharedInstance.userToken else { return .none }
        return "\(offerHostUrl)offers/\(offerId)/code/\(format)/\(width)/\(height)?userToken=\(userToken)"
    }
    
    func findOffers(usingLocation location: CLLocationCoordinate2D, sensor: Bool, filterOptions: FilterOptions? = nil, pagination: PaginationInfo? = nil, completion: @escaping ([Coupon]?, Error?) -> Void) {
        
        let url = "\(offerHostUrl)offers/find"
        let locationParameters: [String: Any] = ["latitude": location.latitude, "longitude": location.longitude, "sensor": "\(sensor)"]
        var parameters = getPaginationParams(pagination: pagination, combinedWith: locationParameters)
        parameters = getFilterParams(filter: filterOptions, combinedWith: parameters)
        getOffersFromURL(url: url, parameters: parameters, completion: completion)
    }
    
    func findRelatedOffer(toOffer offer: Coupon, pagination: PaginationInfo? = nil, completion: @escaping ([Coupon]?, Error?) -> Void) {
        
        let url = "\(offerHostUrl)offers/related"
        let offerParameters = ["storeId": offer.store?.id ?? -1, "offerId": offer.id]
        let parameters = getPaginationParams(pagination: pagination, combinedWith: offerParameters as [String : Any]?)
        getOffersFromURL(url: url, parameters: parameters, completion: completion)
    }
    
    func findStoreOffers(nearLocation location: CLLocationCoordinate2D, radius: CLLocationDistance, sensor: Bool, filterOptions: FilterOptions? = nil, completion: @escaping ([Coupon]?, Error?) -> Void) {
        let url = "\(offerHostUrl)offers/find"
        var parameters: [String: Any] = ["latitude": location.latitude , "longitude": location.longitude , "sensor": "\(sensor)" , "radiusInKm": radius / 1000, "includeOnline": false,  "perPage": 50]
        parameters = getFilterParams(filter: filterOptions, combinedWith: parameters)
        getOffersFromURL(url: url, parameters: parameters, completion: completion)
    }
    
    func getOfferDetails(_ ids: [Int], location: CLLocationCoordinate2D, sensor: Bool, completion: @escaping ([Coupon]?, Error?) -> Void) {
        let url = "\(offerHostUrl)offers/get"
        let idsStr = ids.map(String.init).joined(separator: ",")
        let parameters: [String: Any] = ["ids": idsStr , "latitude": location.latitude , "longitude": location.longitude , "sensor": "\(sensor)" , "includeOnline": false ]
        getOffersFromURL(url: url, parameters: parameters, completion: completion)
    }
    
    func getRedemptionCode(forOffer offer: Coupon, completion: @escaping (RedemptionCode?, Error?) -> Void) {
        let url = "\(offerHostUrl)offers/\(offer.id)/code"
        createRequest(.get, url) { (json, error) in
            // TODO: Process error codes
            let redemptionCode = json.flatMap { self.parseRedemptionCode(json: $0) }
            completion(redemptionCode, error)
        }
    }
    
    func reportErrorUrl(forOffer offer: Coupon) -> String {
        let url = "\(offerHostUrl)offers/\(offer.id)/report"
        if let store = offer.store {
            return "\(url)?storeId=\(store.id)"
        }
        return url
    }
    
    fileprivate func getOffersFromURL(url: String, parameters: [String: Any]? = nil, completion: @escaping ([Coupon]?, Error?) -> Void) {
        createRequest(.get, url, parameters: parameters) { (json, error) in
            let coupons = json.map { $0.arrayValue.map { json in self.parseCoupon(json: json) } }
            completion(coupons, error)
        }
    }
    
    fileprivate func createRequest(_ method: HTTPMethod, _ url: URLConvertible, parameters: [String: Any]? = nil, completion: @escaping (JSON?, Error?) -> Void) {
        UserService.sharedInstance.fetchUserToken { (userToken, error) in
            guard let userToken = userToken else {
                completion(nil, error!)
                return
            }
            
            NetworkActivityIndicatorManager.sharedInstance.startActivity()
            let r = request(url, method: method, parameters: parameters, headers: self.userHeaders(userToken)).validate().responseSwiftyJSON { result in
                NetworkActivityIndicatorManager.sharedInstance.endActivity()
                switch result.result {
                case .failure(let error):
                    print("Error in request with URL", result.request!.url!, error)
                    completion(nil, error)
                case .success(let json):
                    print("Success", result.request!.url!, result.data.flatMap { String(data: $0, encoding: .utf8) } ?? "")
                    completion(json, nil)
                }
            }
            print("Creating request with URL", r.request!.url!)
        }
    }
    
    fileprivate func getPaginationParams(pagination: PaginationInfo?, combinedWith parameters: [String: Any]? = nil) -> [String: Any] {
        var result = parameters ?? [String: Any]()
        if let pagination = pagination {
            if let page = pagination.page {
                result["page"] = page
            }
            if let perPage = pagination.perPage {
                result["perPage"] = perPage
            }
        }
        return result
    }
    
    fileprivate func getFilterParams(filter: FilterOptions?, combinedWith parameters: [String: Any]? = nil) -> [String: Any] {
        var result = parameters ?? [String: Any]()
        if let filter = filter {
            if let query = filter.searchTerm {
                result["query"] = query
            }
            if let tags = filter.tags , tags.count > 0 {
                result["tags"] = tags.joined(separator: ",")
            }
            if let companyId = filter.companyId {
                result["companyId"] = companyId
            }
        }
        return result
    }
    
    fileprivate func parseImage(json: JSON) -> CouponImage? {
        if (json.isEmpty) { return nil }
        let sourceUrl = URL(string: json["url"].stringValue)
        let width = json["width"].float ?? 100
        let height = json["height"].float ?? 100
        let color = UIColor(fromHexString: json["rgbColor"].stringValue)
        if let sourceUrl = sourceUrl {
            return CouponImage(sourceUrl: sourceUrl, width: width, height: height, color: color)
        }
        else {
            return .none
        }
    }
    
    fileprivate func parseCompany(json: JSON) -> Company {
        let id = json["id"].intValue
        let name = json["name"].stringValue
        let logo = parseImage(json: json["logo"])
        return Company(id: id, name: name, logo: logo)
    }
    
    fileprivate func parseDate(string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: string)
    }
    
    fileprivate func parseStore(json: JSON) -> Store? {
        if (json.isEmpty) { return nil }
        let id = json["id"].intValue
        let name = json["name"].string
        let address = json["address"].string
        let latitude = json["latitude"].float
        let longitude = json["longitude"].float
        return Store(id: id, name: name, address: address, latitude: latitude, longitude: longitude)
    }
    
    fileprivate func parseRedemptionCodeInfo(json: JSON) -> RedemptionCodeInfo? {
        if (json.isEmpty) { return nil }
        let totalCodes = json["totalCodes"].int
        let availableCodes = json["availableCodes"].int
        let limited = json["limited"].boolValue
        let alreadyAssigned = json["alreadyAssigned"].boolValue
        return RedemptionCodeInfo(limited: limited, totalCodes: totalCodes, availableCodes: availableCodes, alreadyAssigned: alreadyAssigned)
    }
    
    fileprivate func parseCoupon(json: JSON) -> Coupon {
        let id = json["id"].intValue
        let shortText = json["shortOffer"].stringValue
        let shortDescription = json["shortDescription"].stringValue
        let description = json["description"].stringValue
        let tags = json["tags"].arrayValue.map { $0.stringValue }
        let online = json["isOnline"].boolValue
        let link = json["link"].URL
        let expirationDate: Date? = json["expirationDate"].string.map { self.parseDate(string: $0) } ?? .none
        let thumbnail = parseImage(json: json["thumbnail"])
        let image = parseImage(json: json["image"])
        let store = parseStore(json: json["store"])
        let company = parseCompany(json: json["company"])
        let redemptionCodeInfo = parseRedemptionCodeInfo(json: json["redemptionCode"])
        
        return Coupon(id: id, shortText: shortText, shortDescription: shortDescription, description: description, tags: tags, online: online, link: link, expirationDate: expirationDate, thumbnail: thumbnail, image: image, store: store, company: company, redemptionCode: redemptionCodeInfo)
    }
    
    fileprivate func parseRedemptionCode(json: JSON) -> RedemptionCode? {
        if (json.isEmpty) { return nil }
        let code = json["code"].stringValue
        let displayCode = json["displayCode"].stringValue
        let formats = json["formats"].array?.map { $0.stringValue } ?? []
        return RedemptionCode(code: code, displayCode: displayCode, formats: formats)
    }

}
