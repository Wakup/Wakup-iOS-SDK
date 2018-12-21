//
//  ShowMapButton.swift
//  Wakup
//
//  Created by Guillermo Gutiérrez Doral on 21/12/18.
//  Copyright © 2018 Yellow Pineapple. All rights reserved.
//

import Foundation

@IBDesignable
open class ShowMapButton: CodeIconButton {
    @IBInspectable open dynamic var buttonSize: CGSize = .zero { didSet { setNeedsUpdateConstraints() } }
    
    override open func updateConstraints() {
        super.updateConstraints()
        
        if !buttonSize.equalTo(.zero) {
            removeConstraints(constraints)
            addConstraints([
                widthAnchor.constraint(equalToConstant: buttonSize.width),
                heightAnchor.constraint(equalToConstant: buttonSize.height)
                ])
        
        }
        
    }
}
