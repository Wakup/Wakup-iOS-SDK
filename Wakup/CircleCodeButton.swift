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
    
    override var enabled: Bool { didSet { updateUI() } }
    
    private var touchingInside: Bool = false { didSet { updateUI() } }
    
    override var highlighted: Bool { didSet { updateUI() } }
    
    private var originalBackgroundColor: UIColor?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        originalBackgroundColor = backgroundColor
    }
    
    func updateUI() {
        let isHighlighted = highlighted || selected || touchingInside
        
        textLabel?.highlighted = isHighlighted
        iconView?.highlighted = isHighlighted
        backgroundColor = isHighlighted ? borderColor : originalBackgroundColor
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        touchingInside = true
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
        delay(0.1) {
            self.touchingInside = false
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        delay(0.1) {
            self.touchingInside = false
        }
        sendActionsForControlEvents(.TouchUpInside)
    }
    
}