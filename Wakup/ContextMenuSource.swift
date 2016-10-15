//
//  ContextMenuSource.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 18/02/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation
import iOSContextualMenu

typealias OnContextMenuItemSelected = (_ selectedItem: ContextMenuItem?, _ atIndex: Int) -> Void

class ContextMenuSource: NSObject, BAMContextualMenuDataSource, BAMContextualMenuDelegate {
    
    var menuItems: [ContextMenuItem]?
    var onSelection: OnContextMenuItemSelected?
    
    func contextualMenu(_ contextualMenu: BAMContextualMenu!, didSelectItemAt index: UInt) {
        onSelection?(menuItems?[Int(index)], Int(index))
    }
    
    func contextualMenu(_ contextualMenu: BAMContextualMenu!, titleForMenuItemAt index: UInt) -> String! {
        return menuItems?[Int(index)].titleText ?? .none
    }
    
    func contextualMenu(_ contextualMenu: BAMContextualMenu!, viewForMenuItemAt index: UInt) -> UIView! {
        return menuItems?[Int(index)].itemView
    }
    
    func contextualMenu(_ contextualMenu: BAMContextualMenu!, viewForHighlightedMenuItemAt index: UInt) -> UIView! {
        return menuItems?[Int(index)].highlightedItemView ?? .none
    }
    
    func numberOfContextualMenuItems() -> UInt {
        return UInt(menuItems?.count ?? 0)
    }
}
