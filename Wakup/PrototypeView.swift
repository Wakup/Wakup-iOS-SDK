//
//  PrototypeView.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 26/12/14.
//  Copyright (c) 2014 Yellow Pineapple. All rights reserved.
//

import Foundation
import UIKit

class PrototypeView<T: UIView> {
    var view: T
    
    init(fromNibName nibName: String) {
        view = PrototypeView<T>.loadPrototype(fromNibName: nibName)
    }
    
    class func loadPrototype(fromNibName nibName: String) -> T {
        return NSBundle.mainBundle().loadNibNamed(nibName, owner: nil, options: nil)[0] as! T
    }
    
    func getFittingSize() -> CGSize {
        view.layoutIfNeeded()
        return view.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
    }
}