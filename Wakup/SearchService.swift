//
//  SearchService.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 8/5/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation
import SwiftyJSON
import AwesomeCache
import Alamofire

class SearchService: BaseService {
    static let sharedInstance = SearchService()
    
    fileprivate lazy var historyCache: Cache<NSString> = { try! Cache<NSString>(name: "searchHistory") }()
    fileprivate let historyKey = "history"
    fileprivate let maxHistory = 10
    
    func genericSearch(_ query: String, completion: @escaping (SearchResult?, Error?) -> Void) {
        let url = "\(offerHostUrl)search"
        let parameters = ["q": query]
        
        UserService.sharedInstance.fetchUserToken { (userToken, error) in
            guard let userToken = userToken else {
                completion(nil, error!)
                return
            }
            
            NetworkActivityIndicatorManager.sharedInstance.startActivity()
            let r = request(.GET, url, parameters: parameters, headers: self.userHeaders(userToken)).validate().responseSwiftyJSON({ (req, res, result, error) in
                NetworkActivityIndicatorManager.sharedInstance.endActivity()
                if let error = error {
                    NSLog("Error in request with URL \(req.URLString): \(error)")
                    completion(nil, error)
                }
                else  {
                    NSLog("Success %@: %@)", req.URLString, result.rawString()!)
                    let searchResult = self.parseSearchResult(json: result)
                    completion(searchResult, nil)
                }
            })
            NSLog("Performing search with URL: %@", r.request!.URLString)
        }
    }
    
    fileprivate func parseCompany(json: JSON) -> Company {
        let id = json["id"].intValue
        let name = json["name"].stringValue
        return Company(id: id, name: name, logo: .none)
    }
    
    fileprivate func parseSearchResult(json: JSON) -> SearchResult {
        let companies = json["companies"].arrayValue.map { companyJson in self.parseCompany(json: companyJson) }
        let tags = json["tags"].arrayValue.map { $0.stringValue }
        return SearchResult(companies: companies, tags: tags)
    }
    
    func addToHistory(_ element: SearchHistory) -> [SearchHistory] {
        let currentHistory = getSavedHistory() ?? [SearchHistory]()
        var newHistory = currentHistory.filter { e in e != element }
        newHistory.insert(element, at: 0)
        if newHistory.count > 10 {
            newHistory.removeLast()
        }
        saveHistory(newHistory)
        return newHistory
    }
    
    func saveHistory(_ searchHistory: [SearchHistory]) {
        let jsonArray = searchHistory.map { $0.toJson() }
        let json = JSON(jsonArray)
        let jsonString = json.rawString(String.Encoding.utf8)
        historyCache.setObject(jsonString as NSString!, forKey: historyKey, expires: .Never)
    }
    
    func getSavedHistory() -> [SearchHistory]? {
        if let jsonString = historyCache[historyKey],
            let data = jsonString.dataUsingEncoding(String.Encoding.utf8, allowLossyConversion: false),
            let array = JSON(data: data).array
        {
            return mapSome(array) { SearchHistory.fromJson($0) }
        }
        
        return .none
    }
}
