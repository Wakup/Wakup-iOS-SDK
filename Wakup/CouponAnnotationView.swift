//
//  CouponAnnotationView.swift
//  Wakup
//
//  Created by Guillermo Gutiérrez on 7/1/16.
//  Copyright © 2016 Yellow Pineapple. All rights reserved.
//

import Foundation
import MapKit

@objc
open class ColorForTags: NSObject {
    open let tags: Set<String>
    open let color: UIColor
    open let mapIcon: String
    
    public init(tags: Set<String>, mapIcon: String, color: UIColor) {
        self.tags = tags
        self.color = color
        self.mapIcon = mapIcon
    }
}

open class CouponAnnotationView: MKAnnotationView {
    
    @objc open dynamic var mapPinSize = CGSize(width: 46, height: 60)
    
    @objc open dynamic var iconAndColorForTags: [ColorForTags] = [
        ColorForTags(tags: ["restaurants"], mapIcon: "map-restaurant-pin", color: StyleKit.restaurantCategoryColor),
        ColorForTags(tags: ["leisure"], mapIcon: "map-leisure-pin", color: StyleKit.leisureCategoryColor),
        ColorForTags(tags: ["services"], mapIcon: "map-services-pin", color: StyleKit.servicesCategoryColor),
        ColorForTags(tags: ["shopping"], mapIcon: "map-shopping-pin", color: StyleKit.shoppingCategoryColor),
        ColorForTags(tags: [], mapIcon: "map-pin", color: StyleKit.corporateDarkColor) // Empty tag list for default pin and color
    ]
    
    func mapIconId(forOffer offer: Coupon) -> (String, UIColor) {
        let offerTags = Set(offer.tags)
        for element in iconAndColorForTags {
            if !offerTags.intersection(element.tags).isEmpty || element.tags.isEmpty {
                return (element.mapIcon, element.color)
            }
        }
        return ("map-pin", StyleKit.corporateDarkColor)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let couponAnnotation = annotation as? CouponAnnotation else { return }
        
        let iconFrame = CGRect(x: 0, y: 0, width: mapPinSize.width, height: mapPinSize.height)
        let (mapPinId, pinColor) = mapIconId(forOffer: couponAnnotation.coupon)
        let iconImage = CodeIcon(iconIdentifier: mapPinId).getImage(iconFrame, color: pinColor)
        image = iconImage
        centerOffset = CGPoint(x: 0, y: (-mapPinSize.height / 2) + 1)
    }
}
