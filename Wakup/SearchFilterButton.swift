//
//  SearchFilterButton.swift
//  Wakup
//
//  Created by Guillermo Gutiérrez on 7/1/16.
//  Copyright © 2016 Yellow Pineapple. All rights reserved.
//

import Foundation

@IBDesignable
public class SearchFilterButton: CenteredCodeIconButton {
    var category: OfferCategory? { didSet { reloadUI() } }
    
    func reloadUI() {
        guard let category = category else { return }
        iconIdentifier = category.icon
        setTitle(category.title, forState: .Normal)
    }
}