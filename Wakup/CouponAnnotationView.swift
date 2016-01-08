//
//  CouponAnnotationView.swift
//  Wakup
//
//  Created by Guillermo Gutiérrez on 7/1/16.
//  Copyright © 2016 Yellow Pineapple. All rights reserved.
//

import Foundation
import MapKit

public class CouponAnnotationView: MKAnnotationView {
    
    public dynamic var mapPinSize = CGSize(width: 46, height: 60)
    
    public dynamic var restaurantCategoryColor: UIColor? { didSet { setNeedsLayout() } }
    public dynamic var leisureCategoryColor: UIColor? { didSet { setNeedsLayout() } }
    public dynamic var servicesCategoryColor: UIColor? { didSet { setNeedsLayout() } }
    public dynamic var shoppingCategoryColor: UIColor? { didSet { setNeedsLayout() } }
    public dynamic var otherCategoryColor: UIColor? { didSet { setNeedsLayout() } }
    
    func mapIconId(forCategory category: Category) -> (String, UIColor) {
        switch category {
        case .Restaurant: return ("map-restaurant-pin", restaurantCategoryColor ?? StyleKit.restaurantCategoryColor)
        case .Leisure: return ("map-leisure-pin", leisureCategoryColor ?? StyleKit.leisureCategoryColor)
        case .Services: return ("map-services-pin", servicesCategoryColor ?? StyleKit.servicesCategoryColor)
        case .Shopping: return ("map-shopping-pin", shoppingCategoryColor ?? StyleKit.shoppingCategoryColor)
        default: return ("map-pin", otherCategoryColor ?? StyleKit.corporateDarkColor)
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let couponAnnotation = annotation as? CouponAnnotation else { return }
        
        let iconFrame = CGRect(x: 0, y: 0, width: mapPinSize.width, height: mapPinSize.height)
        let (mapPinId, pinColor) = mapIconId(forCategory: couponAnnotation.coupon.category)
        let iconImage = CodeIcon(iconIdentifier: mapPinId).getImage(iconFrame, color: pinColor)
        image = iconImage
        centerOffset = CGPoint(x: 0, y: (-mapPinSize.height / 2) + 1)
    }
}