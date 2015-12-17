//
//  ContextItemView.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 19/02/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import UIKit

@IBDesignable class ContextItemView: UIView {

    var iconIdentifier: String? { get { return codeIconView?.iconIdentifier } set(value) { codeIconView?.iconIdentifier = value ?? "" } }
    
    @IBOutlet weak var codeIconView: CodeIconView!

}
