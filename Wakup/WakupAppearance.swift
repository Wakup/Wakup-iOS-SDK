//
//  WakupAppearance.swift
//  Wakup
//
//  Created by Guillermo Gutiérrez Doral on 14/12/17.
//  Copyright © 2017 Yellow Pineapple. All rights reserved.
//

import Foundation
import UIKit

public class WakupAppearance {
    public func setTint(mainColor: UIColor, secondaryColor: UIColor? = nil, contrastColor: UIColor? = nil) {
        let isLight = mainColor.isLight()
        let contrastColor = contrastColor ?? (isLight ? mainColor.darker(by: 80) : mainColor.lighter(by: 80))
        let secondaryColor = secondaryColor ?? (isLight ? mainColor.darker(by: 30) : mainColor.lighter(by: 30))
        let secondaryContrastColor = secondaryColor.isLight() ? secondaryColor.darker(by: 80) : secondaryColor.lighter(by: 80)
        
        setNavigationBarTint(navBarColor: mainColor, tintColor: contrastColor)
        setTopBarTint(contrastColor, buttonColor: mainColor, backgroundColor: secondaryColor)
        setDiscountTagTint(secondaryColor, labelColor: secondaryContrastColor)
        setQuickActionsTint(mainColor)
        setOfferActionButtonsTint(secondaryColor)
        setTagListTint(mainColor)
        setSearchTint(mainColor)
    }
    
    public func setNavigationBarTint(navBarColor: UIColor, tintColor: UIColor) {
        UINavigationBar.appearance().barTintColor = navBarColor
        UINavigationBar.appearance().tintColor = tintColor
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedStringKey.foregroundColor: tintColor
        ]
        NavBarIconView.appearance().iconColor = tintColor
    }
    
    public func setTopBarTint(_ tintColor: UIColor, buttonColor: UIColor, backgroundColor: UIColor? = nil) {
        let highlightedButtonColor = buttonColor.lighter()
        let highlightedTintColor = tintColor.lighter()
        
        TopMenuButton.appearance().setTitleColor(tintColor, for: [])
        TopMenuButton.appearance().setTitleColor(highlightedTintColor, for: .highlighted)
        TopMenuButton.appearance().iconColor = tintColor
        TopMenuButton.appearance().highlightedIconColor = highlightedTintColor
        TopMenuButton.appearance().backgroundColor = buttonColor
        TopMenuButton.appearance().highlightedBackgroundColor = highlightedButtonColor
        TopMenuView.appearance().backgroundColor = backgroundColor ?? buttonColor.lighter(by: 20)
        
    }
    
    public func setOfferViewsTint(titleColor: UIColor = .black, descriptionColor: UIColor = UIColor(white: 0.33, alpha: 1), detailsColor: UIColor = UIColor(white:0.56, alpha:1)) {
        CouponCollectionViewCell.appearance().storeNameTextColor = titleColor
        CouponCollectionViewCell.appearance().descriptionTextColor = descriptionColor
        CouponCollectionViewCell.appearance().distanceTextColor = detailsColor
        CouponCollectionViewCell.appearance().distanceIconColor = detailsColor
        CouponCollectionViewCell.appearance().expirationTextColor = detailsColor
        CouponCollectionViewCell.appearance().expirationIconColor = detailsColor
    }
    
    public func setDiscountTagTint(_ tintColor: UIColor, labelColor: UIColor = .white) {
        DiscountTagView.appearance().backgroundColor = tintColor
        DiscountTagView.appearance().labelColor = labelColor
    }
    
    public func setQuickActionsTint(_ mainColor: UIColor, secondaryColor: UIColor = .white) {
        ContextItemView.appearance().backgroundColor = mainColor
        ContextItemView.appearance().highlightedBackgroundColor = mainColor.lighter(by: 20)
        ContextItemView.appearance().iconColor = secondaryColor
        ContextItemView.appearance().highlightedIconColor = secondaryColor
        ContextItemView.appearance().borderColor = secondaryColor
    }
    
    public func setOfferDetailsTint(titleColor: UIColor = .black, descriptionColor: UIColor = UIColor(white: 0.33, alpha: 1), detailsColor: UIColor = UIColor(white:0.56, alpha:1)) {
        CouponDetailHeaderView.appearance().companyNameTextColor = titleColor
        CouponDetailHeaderView.appearance().storeAddressTextColor = detailsColor
        CouponDetailHeaderView.appearance().storeDistanceTextColor = detailsColor
        CouponDetailHeaderView.appearance().storeDistanceIconColor = detailsColor
        CouponDetailHeaderView.appearance().couponNameTextColor = descriptionColor
        CouponDetailHeaderView.appearance().couponDescriptionTextColor = detailsColor
        CouponDetailHeaderView.appearance().expirationTextColor = detailsColor
        CouponDetailHeaderView.appearance().expirationIconColor = detailsColor
        CouponDetailHeaderView.appearance().companyDisclosureColor = detailsColor
        CouponDetailHeaderView.appearance().couponDescriptionDisclosureColor = detailsColor
        CouponDetailHeaderView.appearance().companyNameTextColor = detailsColor
    }
    
    public func setOfferActionButtonsTint(_ actionColor: UIColor) {
        CouponActionButton.appearance().iconColor = actionColor
        CouponActionButton.appearance().highlightedBackgroundColor = actionColor
        CouponActionButton.appearance().setTitleColor(actionColor, for: [])
        CouponActionButton.appearance().normalBorderColor = actionColor
    }
    
    public func setTagListTint(_ tintColor: UIColor) {
        WakupTagListView.appearance().tagBackgroundColor = tintColor
        WakupTagListView.appearance().tagHighlightedBackgroundColor = tintColor.darker()
        WakupTagListView.appearance().wakupBorderColor = tintColor.darker()
    }
    
    public func setSearchTint(_ tintColor: UIColor) {
        SearchFilterButton.appearance().iconColor = tintColor
        SearchFilterButton.appearance().highlightedBackgroundColor = tintColor
        SearchFilterButton.appearance().setTitleColor(tintColor, for: [])
        SearchFilterButton.appearance().normalBorderColor = tintColor
        
        SearchResultCell.appearance().iconColor = tintColor
    }
}
