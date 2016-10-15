//
//  PrototypeDataView.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 26/12/14.
//  Copyright (c) 2014 Yellow Pineapple. All rights reserved.
//

import Foundation
import UIKit

class PrototypeDataView<T: UIView, U> : PrototypeView<T> {
    let updateMethod: (T, U) -> Void
    convenience init(fromNibName nibName: String, bundle: Bundle? = nil, updateMethod: @escaping (T, U) -> Void) {
        let nib = UINib(nibName: nibName, bundle: bundle ?? Bundle(for: T.self))
        self.init(fromNib: nib, updateMethod: updateMethod)
    }
    
    init(fromNib nib: UINib, updateMethod: @escaping (T, U) -> Void) {
        self.updateMethod = updateMethod
        super.init(fromNib: nib)
    }
    
    func update(data: U) {
        updateMethod(self.view, data)
    }
    
    func getUpdatedSize(data: U) -> CGSize {
        update(data: data)
        return getFittingSize()
    }
}
