//
//  CircleCodeButton.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 05/01/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CircleCodeButton: UIControl {
    
    @IBOutlet var textLabel: UILabel?
    @IBOutlet var iconView: CodeIconView?
    
    override var isEnabled: Bool { didSet { updateUI() } }
    
    fileprivate var touchingInside: Bool = false { didSet { updateUI() } }
    
    override var isHighlighted: Bool { didSet { updateUI() } }
    
    fileprivate var originalBackgroundColor: UIColor?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        originalBackgroundColor = backgroundColor
    }
    
    func updateUI() {
        let isHighlighted = self.isHighlighted || isSelected || touchingInside
        
        textLabel?.isHighlighted = isHighlighted
        iconView?.highlighted = isHighlighted
        backgroundColor = isHighlighted ? borderColor : originalBackgroundColor
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        touchingInside = true
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        delay(0.1) {
            self.touchingInside = false
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        delay(0.1) {
            self.touchingInside = false
        }
        sendActions(for: .touchUpInside)
    }
    
}
