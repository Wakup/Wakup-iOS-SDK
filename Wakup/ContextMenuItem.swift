//
//  ContextualMenuItem.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 18/02/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation
import UIKit

class ContextMenuItem {
    var identifier: String?
    var itemView: UIView
    var highlightedItemView: UIView?
    var titleText: String?
    
    init(itemView: UIView, highlightedItemView: UIView? = .none, titleText: String? = .none) {
        self.itemView = itemView
        self.highlightedItemView = highlightedItemView
        self.titleText = titleText
    }
}
