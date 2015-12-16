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

class SearchService {
    class var sharedInstance : SearchService {
        struct Static {
            static let instance : SearchService = SearchService()
        }
        return Static.instance
    }
    
    private lazy var historyCache: Cache<NSString> = { try! Cache<NSString>(name: "searchHistory") }()
    private let historyKey = "history"
    private let maxHistory = 10
    
    func genericSearch(query: String, completion: (SearchResult?, ErrorType?) -> Void) {
        let url = "\(offerHostUrl)search"
        let parameters = ["q": query]
        NetworkActivityIndicatorManager.sharedInstance.startActivity()
        let r = request(.GET, url, parameters: parameters).responseSwiftyJSON({ (req, res, result, error) in
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
    
    private func parseCompany(json json: JSON) -> Company {
        let id = json["id"].intValue
        let name = json["name"].stringValue
        return Company(id: id, name: name, logo: .None)
    }
    
    private func parseSearchResult(json json: JSON) -> SearchResult {
        let companies = json["companies"].arrayValue.map { companyJson in self.parseCompany(json: companyJson) }
        return SearchResult(companies: companies)
    }
    
    func addToHistory(element: SearchHistory) -> [SearchHistory] {
        let currentHistory = getSavedHistory() ?? [SearchHistory]()
        var newHistory = currentHistory.filter { e in e != element }
        newHistory.insert(element, atIndex: 0)
        if newHistory.count > 10 {
            newHistory.removeLast()
        }
        saveHistory(newHistory)
        return newHistory
    }
    
    func saveHistory(searchHistory: [SearchHistory]) {
        let jsonArray = searchHistory.map { $0.toJson() }
        let json = JSON(jsonArray)
        let jsonString = json.rawString(NSUTF8StringEncoding)
        historyCache.setObject(jsonString as NSString!, forKey: historyKey, expires: .Never)
    }
    
    func getSavedHistory() -> [SearchHistory]? {
        if let jsonString = historyCache[historyKey],
            let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false),
            let array = JSON(data: data).array
        {
            return mapSome(array) { SearchHistory.fromJson($0) }
        }
        
        return .None
    }
}