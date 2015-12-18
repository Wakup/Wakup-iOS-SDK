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
    let view: T
    
    convenience init(fromNibName nibName: String, bundle: NSBundle? = nil) {
        let nib = UINib(nibName: nibName, bundle: bundle ?? NSBundle(forClass: T.self))
        self.init(fromNib: nib)
    }
    
    init(fromNib nib: UINib) {
        view = nib.instantiateWithOwner(nil, options: nil)[0] as! T
    }
    
    class func loadPrototype(fromNibName nibName: String) -> T {
        return NSBundle(forClass: T.self).loadNibNamed(nibName, owner: nil, options: nil)[0] as! T
    }
    
    func getFittingSize() -> CGSize {
        view.layoutIfNeeded()
        return view.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
    }
}