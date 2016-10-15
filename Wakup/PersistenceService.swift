//
//  PersistenceService.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 17/02/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation

class PersistenceService {
    class var sharedInstance : PersistenceService {
        struct Static {
            static let instance : PersistenceService = PersistenceService()
        }
        return Static.instance
    }
    
    fileprivate var savedOfferIds: [Int]?
    fileprivate let savedOffersKey = "savedOffers";
    fileprivate lazy var userDefaults = UserDefaults.standard
    
    func getSavedOfferIds(_ forceRefresh: Bool = false) -> [Int] {
        if forceRefresh || savedOfferIds == nil {
            savedOfferIds = fetchSavedOfferIds()
        }
        return savedOfferIds!
    }
    
    func saveOfferId(_ id: Int) {
        var offers = getSavedOfferIds()
        offers.append(id)
        savedOfferIds = offers
        persistOfferIds()
    }
    
    func removeOfferId(_ id: Int) {
        if let index = getSavedOfferIds().index(of: id) {
            savedOfferIds?.remove(at: index)
            persistOfferIds()
        }
    }
    
    func isSaved(_ id: Int) -> Bool {
        return getSavedOfferIds().index(of: id) != .none
    }
    
    func toggle(_ id: Int) -> Bool {
        let saved = isSaved(id)
        if saved {
            removeOfferId(id)
        }
        else {
            saveOfferId(id)
        }
        return !saved
    }
    
    fileprivate func fetchSavedOfferIds() -> [Int] {
        return userDefaults.object(forKey: savedOffersKey) as? [Int] ?? [Int]()
    }
    
    fileprivate func persistOfferIds() {
        userDefaults.set(getSavedOfferIds() as NSArray, forKey: savedOffersKey)
        userDefaults.synchronize()
    }
}
