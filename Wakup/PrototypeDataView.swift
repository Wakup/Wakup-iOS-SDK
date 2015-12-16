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
    var updateMethod: (T, U) -> Void
    init(fromNibName nibName: String, updateMethod: (T, U) -> Void) {
        self.updateMethod = updateMethod
        super.init(fromNibName: nibName)
    }
    
    func update(data data: U) {
        updateMethod(self.view, data)
    }
    
    func getUpdatedSize(data data: U) -> CGSize {
        update(data: data)
        return getFittingSize()
    }
}