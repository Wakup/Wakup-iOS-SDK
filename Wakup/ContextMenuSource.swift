//
//  ContextMenuSource.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 18/02/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation
import iOSContextualMenu

typealias OnContextMenuItemSelected = (selectedItem: ContextMenuItem?, atIndex: Int) -> Void

class ContextMenuSource: NSObject, BAMContextualMenuDataSource, BAMContextualMenuDelegate {
    
    var menuItems: [ContextMenuItem]?
    var onSelection: OnContextMenuItemSelected?
    
    func contextualMenu(contextualMenu: BAMContextualMenu!, didSelectItemAtIndex index: UInt) {
        onSelection?(selectedItem: menuItems?[Int(index)], atIndex: Int(index))
    }
    
    func contextualMenu(contextualMenu: BAMContextualMenu!, titleForMenuItemAtIndex index: UInt) -> String! {
        return menuItems?[Int(index)].titleText ?? .None
    }
    
    func contextualMenu(contextualMenu: BAMContextualMenu!, viewForMenuItemAtIndex index: UInt) -> UIView! {
        return menuItems?[Int(index)].itemView
    }
    
    func contextualMenu(contextualMenu: BAMContextualMenu!, viewForHighlightedMenuItemAtIndex index: UInt) -> UIView! {
        return menuItems?[Int(index)].highlightedItemView ?? .None
    }
    
    func numberOfContextualMenuItems() -> UInt {
        return UInt(menuItems?.count ?? 0)
    }
}