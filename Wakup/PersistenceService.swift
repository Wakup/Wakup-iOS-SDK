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
    
    private var savedOfferIds: [Int]?
    private let savedOffersKey = "savedOffers";
    private lazy var userDefaults = NSUserDefaults.standardUserDefaults()
    
    func getSavedOfferIds(forceRefresh: Bool = false) -> [Int] {
        if forceRefresh || savedOfferIds == nil {
            savedOfferIds = fetchSavedOfferIds()
        }
        return savedOfferIds!
    }
    
    func saveOfferId(id: Int) {
        var offers = getSavedOfferIds()
        offers.append(id)
        savedOfferIds = offers
        persistOfferIds()
    }
    
    func removeOfferId(id: Int) {
        if let index = getSavedOfferIds().indexOf(id) {
            savedOfferIds?.removeAtIndex(index)
            persistOfferIds()
        }
    }
    
    func isSaved(id: Int) -> Bool {
        return getSavedOfferIds().indexOf(id) != .None
    }
    
    func toggle(id: Int) -> Bool {
        let saved = isSaved(id)
        if saved {
            removeOfferId(id)
        }
        else {
            saveOfferId(id)
        }
        return !saved
    }
    
    private func fetchSavedOfferIds() -> [Int] {
        return userDefaults.objectForKey(savedOffersKey) as? [Int] ?? [Int]()
    }
    
    private func persistOfferIds() {
        userDefaults.setObject(getSavedOfferIds() as NSArray, forKey: savedOffersKey)
        userDefaults.synchronize()
    }
}