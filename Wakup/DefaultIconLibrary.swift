//
//  DefaultIconLibrary.swift
//  TSales
//
//  Created by Guillermo Gutiérrez on 8/10/15.
//  Copyright © 2015 TwinCoders. All rights reserved.
//

import Foundation

public class DefaultIconLibrary: IconLibrary {
    
    var searchListColor = UIColor(fromHexString: "#906191")
    var emptyViewColor = UIColor(fromHexString: "#908E90")
    
    public func drawMethodForIcon(iconIdentifier iconIdentifier: String) -> (drawMethod: IconDrawMethod, aspectRatio: CGFloat) {
        switch iconIdentifier {
        case "location": return (StyleKit.drawLocationIcon, 59/78)
        case "clock": return (StyleKit.drawClockIcon, 1)
        case "back": return (StyleKit.drawBackIcon, 33/55)
        case "disclosure": return (StyleKit.drawDisclosure, 33/55)
        case "share": return (StyleKit.drawShareIcon, 1)
        case "save": return (StyleKit.drawSaveIcon, 49/63)
        case "navbar-logo": return (StyleKit.drawNavbarLogo, 445/245)
        case "search": return (StyleKit.drawSearchIcon, 1)
        case "restaurant": return (StyleKit.drawRestaurantIcon, 1)
        case "shopping": return (StyleKit.drawShoppingIcon, 58/66)
        case "popcorn": return (StyleKit.drawPopcornIcon, 54/84)
        case "gears": return (StyleKit.drawServicesIcon, 65/62)
        case "map-pin": return (StyleKit.drawMapPin, 60/80)
        case "services": return (StyleKit.drawServicesIcon, 56/64)
        case "leisure": return (StyleKit.drawLeisureIcon, 52/46)
        case "map-restaurant-pin": return (StyleKit.drawRestaurantPin, 60/80)
        case "map-leisure-pin": return (StyleKit.drawLeisurePin, 60/80)
        case "map-shopping-pin": return (StyleKit.drawShoppingPin, 60/80)
        case "map-services-pin": return (StyleKit.drawServicesPin, 60/80)
        case "star": return (StyleKit.drawStarIcon, 56/54)
        case "profile": return (StyleKit.drawProfileIcon, 1)
        case "show-map": return (StyleKit.drawMapIcon, 52/64)
        case "remove": fallthrough
        case "cross": return (StyleKit.drawCrossIcon, 1)
        case "check": return (StyleKit.drawCheckIcon, 48/36)
        case "alert": return (StyleKit.drawAlertIcon, 1)
        case "cloud-alert": return (StyleKit.drawCloudWarningIcon, 71/52)
        case "brand": return (StyleKit.drawBrandIcon, 1)
        default: return ({ f, c in }, 1)
        }
    }
    
    public func getDefaultColor(iconIdentifier iconIdentifier: String) -> UIColor {
        switch iconIdentifier {
        case "map-pin": fallthrough
        case "location": fallthrough
        case "brand": fallthrough
        case "star":
            return searchListColor
        case "cloud-alert": fallthrough
        case "save":
            return emptyViewColor
        default:
            return UIColor.grayColor()
        }
    }
}