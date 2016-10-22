//
//  SearchService.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 8/5/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class SearchService: BaseService {
    static let sharedInstance = SearchService()
    
    fileprivate let maxHistory = 10
    
    func searchHistoryFile() -> URL {
        let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return cacheDir.appendingPathComponent("searchHistory.plist")
    }
    
    func genericSearch(_ query: String, completion: @escaping (SearchResult?, Error?) -> Void) {
        let url = "\(offerHostUrl)search"
        let parameters = ["q": query]
        
        UserService.sharedInstance.fetchUserToken { (userToken, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            NetworkActivityIndicatorManager.sharedInstance.startActivity()
            let r = request(url, parameters: parameters, headers: self.authHeaders).validate().responseSwiftyJSON { result in
                NetworkActivityIndicatorManager.sharedInstance.endActivity()
                switch result.result {
                case .failure(let error):
                    print("Error in request with URL \(result.request?.url): \(error)")
                    completion(nil, error)
                case .success(let json):
                    NSLog("Success \(result.request?.url): \(result.data.map { String(data: $0, encoding: .utf8) })")
                    let searchResult = self.parseSearchResult(json: json)
                    completion(searchResult, nil)
                }
            }
            NSLog("Performing search with URL: \(r.request?.url)")
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
        try? saveHistory(newHistory)
        return newHistory
    }
    
    func saveHistory(_ searchHistory: [SearchHistory]) throws {
        let jsonArray = searchHistory.map { $0.toJson() }
        let json = JSON(jsonArray)
        let jsonString = json.rawString(String.Encoding.utf8)!
        
        try jsonString.write(to: searchHistoryFile(), atomically: true, encoding: String.Encoding.utf8)
    }
    
    func getSavedHistory() -> [SearchHistory]? {
        if let jsonString = try? String(contentsOf: searchHistoryFile(), encoding: String.Encoding.utf8),
            let data = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: false),
            let array = JSON(data: data).array
        {
            return mapSome(array) { SearchHistory.fromJson($0) }
        }
        
        return .none
    }
}
