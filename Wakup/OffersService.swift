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
    let categories: [OfferCategory]?
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
    
    func redemptionCodeImageUrl(offerId: Int, format: String, width: Int, height: Int) -> String? {
        guard let userToken = UserService.sharedInstance.userToken else { return .None }
        return "\(offerHostUrl)offers/\(offerId)/code/\(format)/\(width)/\(height)?userToken=\(userToken)"
    }
    
    func findOffers(usingLocation location: CLLocationCoordinate2D, sensor: Bool, filterOptions: FilterOptions? = nil, pagination: PaginationInfo? = nil, completion: ([Coupon]?, ErrorType?) -> Void) {
        
        let url = "\(offerHostUrl)offers/find"
        let locationParameters: [String: AnyObject] = ["latitude": location.latitude, "longitude": location.longitude, "sensor": "\(sensor)"]
        var parameters = getPaginationParams(pagination: pagination, combinedWith: locationParameters)
        parameters = getFilterParams(filter: filterOptions, combinedWith: parameters)
        getOffersFromURL(url: url, parameters: parameters, completion: completion)
    }
    
    func findRelatedOffer(toOffer offer: Coupon, pagination: PaginationInfo? = nil, completion: ([Coupon]?, ErrorType?) -> Void) {
        
        let url = "\(offerHostUrl)offers/related"
        let offerParameters = ["storeId": offer.store?.id ?? -1, "offerId": offer.id]
        let parameters = getPaginationParams(pagination: pagination, combinedWith: offerParameters)
        getOffersFromURL(url: url, parameters: parameters, completion: completion)
    }
    
    func findStoreOffers(nearLocation location: CLLocationCoordinate2D, radius: CLLocationDistance, sensor: Bool, filterOptions: FilterOptions? = nil, completion: ([Coupon]?, ErrorType?) -> Void) {
        let url = "\(offerHostUrl)offers/find"
        var parameters: [String: AnyObject] = ["latitude": location.latitude, "longitude": location.longitude, "sensor": "\(sensor)", "radiusInKm": radius / 1000, "includeOnline": false,  "perPage": 50]
        parameters = getFilterParams(filter: filterOptions, combinedWith: parameters)
        getOffersFromURL(url: url, parameters: parameters, completion: completion)
    }
    
    func getOfferDetails(ids: [Int], location: CLLocationCoordinate2D, sensor: Bool, completion: ([Coupon]?, ErrorType?) -> Void) {
        let url = "\(offerHostUrl)offers/get"
        let idsStr = ids.map(String.init).joinWithSeparator(",")
        let parameters: [String: AnyObject] = ["ids": idsStr, "latitude": location.latitude, "longitude": location.longitude, "sensor": "\(sensor)", "includeOnline": false]
        getOffersFromURL(url: url, parameters: parameters, completion: completion)
    }
    
    func getRedemptionCode(forOffer offer: Coupon, completion: (RedemptionCode?, ErrorType?) -> Void) {
        let url = "\(offerHostUrl)offers/\(offer.id)/code"
        createRequest(.GET, url) { (json, error) in
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
    
    private func getOffersFromURL(url url: String, parameters: [String: AnyObject]? = nil, completion: ([Coupon]?, ErrorType?) -> Void) {
        createRequest(.GET, url, parameters: parameters) { (json, error) in
            let coupons = json.map { $0.arrayValue.map { json in self.parseCoupon(json: json) } }
            completion(coupons, error)
        }
    }
    
    private func createRequest(method: Alamofire.Method, _ url: URLStringConvertible, parameters: [String: AnyObject]? = nil, completion: (JSON?, ErrorType?) -> Void) {
        UserService.sharedInstance.fetchUserToken { (userToken, error) in
            guard let userToken = userToken else {
                completion(nil, error!)
                return
            }
            
            NetworkActivityIndicatorManager.sharedInstance.startActivity()
            let r = request(method, url, parameters: parameters, headers: self.userHeaders(userToken)).validate().responseSwiftyJSON({ (req, res, result, error) -> Void in
                NetworkActivityIndicatorManager.sharedInstance.endActivity()
                if let error = error {
                    print("Error in request with URL \(req.URLString): \(error)")
                    completion(nil, error)
                }
                else  {
                    NSLog("Success %@: %@)", req.URLString, result.rawString()!)
                    completion(result, nil)
                }
            })
            NSLog("Creating request with URL: %@", r.request!.URLString)
        }
    }
    
    private func getPaginationParams(pagination pagination: PaginationInfo?, combinedWith parameters: [String: AnyObject]? = nil) -> [String: AnyObject] {
        var result = parameters ?? [String: AnyObject]()
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
    
    private func getFilterParams(filter filter: FilterOptions?, combinedWith parameters: [String: AnyObject]? = nil) -> [String: AnyObject] {
        var result = parameters ?? [String: AnyObject]()
        if let filter = filter {
            if let query = filter.searchTerm {
                result["query"] = query
            }
            if let categories = filter.categories where categories.count > 0 {
                result["categories"] = categories.map{ $0.rawValue }.joinWithSeparator(",")
            }
            if let companyId = filter.companyId {
                result["companyId"] = companyId
            }
        }
        return result
    }
    
    private func parseImage(json json: JSON) -> CouponImage? {
        if (json.isEmpty) { return nil }
        let sourceUrl = NSURL(string: json["url"].stringValue)
        let width = json["width"].float ?? 100
        let height = json["height"].float ?? 100
        let color = UIColor(fromHexString: json["rgbColor"].stringValue)
        if let sourceUrl = sourceUrl {
            return CouponImage(sourceUrl: sourceUrl, width: width, height: height, color: color)
        }
        else {
            return .None
        }
    }
    
    private func parseCompany(json json: JSON) -> Company {
        let id = json["id"].intValue
        let name = json["name"].stringValue
        let logo = parseImage(json: json["logo"])
        return Company(id: id, name: name, logo: logo)
    }
    
    private func parseDate(string string: String) -> NSDate? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.dateFromString(string)
    }
    
    private func parseStore(json json: JSON) -> Store? {
        if (json.type == .Null) { return .None }
        let id = json["id"].intValue
        let name = json["name"].string
        let address = json["address"].string
        let latitude = json["latitude"].float
        let longitude = json["longitude"].float
        return Store(id: id, name: name, address: address, latitude: latitude, longitude: longitude)
    }
    
    private func parseRedemptionCodeInfo(json json: JSON) -> RedemptionCodeInfo? {
        if (json.type == .Null) { return .None }
        let totalCodes = json["totalCodes"].int
        let availableCodes = json["availableCodes"].int
        let limited = json["limited"].boolValue
        let alreadyAssigned = json["alreadyAssigned"].boolValue
        return RedemptionCodeInfo(limited: limited, totalCodes: totalCodes, availableCodes: availableCodes, alreadyAssigned: alreadyAssigned)
    }
    
    private func parseCoupon(json json: JSON) -> Coupon {
        let id = json["id"].intValue
        let shortText = json["shortOffer"].stringValue
        let shortDescription = json["shortDescription"].stringValue
        let description = json["description"].stringValue
        let tags = json["tags"].arrayValue.map { $0.stringValue }
        let online = json["isOnline"].boolValue
        let link = json["link"].URL
        let expirationDate: NSDate? = json["expirationDate"].string.map { self.parseDate(string: $0) } ?? .None
        let thumbnail = parseImage(json: json["thumbnail"])
        let image = parseImage(json: json["image"])
        let store = parseStore(json: json["store"])
        let company = parseCompany(json: json["company"])
        let redemptionCodeInfo = parseRedemptionCodeInfo(json: json["redemptionCode"])
        
        return Coupon(id: id, shortText: shortText, shortDescription: shortDescription, description: description, tags: tags, online: online, link: link, expirationDate: expirationDate, thumbnail: thumbnail, image: image, store: store, company: company, redemptionCode: redemptionCodeInfo)
    }
    
    private func parseRedemptionCode(json json: JSON) -> RedemptionCode? {
        if (json.type == .Null) { return .None }
        let code = json["code"].stringValue
        let displayCode = json["displayCode"].stringValue
        let formats = json["formats"].array?.map { $0.stringValue } ?? []
        return RedemptionCode(code: code, displayCode: displayCode, formats: formats)
    }

}