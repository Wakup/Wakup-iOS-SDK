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
    
    convenience init(fromNibName nibName: String, bundle: Bundle? = nil) {
        let nib = UINib(nibName: nibName, bundle: bundle ?? Bundle(for: T.self))
        self.init(fromNib: nib)
    }
    
    init(fromNib nib: UINib) {
        view = nib.instantiate(withOwner: nil, options: nil)[0] as! T
    }
    
    class func loadPrototype(fromNibName nibName: String) -> T {
        return Bundle(for: T.self).loadNibNamed(nibName, owner: nil, options: nil)![0] as! T
    }
    
    func getFittingSize() -> CGSize {
        view.setNeedsLayout()
        view.layoutIfNeeded()
        return view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}
