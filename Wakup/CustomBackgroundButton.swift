//
//  CustomBackgroundButton.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 23/02/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CustomBackgroundButton: UIButton {
    @IBOutlet var highlightedElements: Array<UIView>?
    @IBInspectable var selectedBackgroundColor: UIColor?
    @IBInspectable var highlightedBackgroundColor: UIColor?
    @IBInspectable var disabledBackgroundColor: UIColor?
    @IBInspectable var highlightedDisabledBackgroundColor: UIColor?
    @IBInspectable var highlightedSelectedBackgroundColor: UIColor?
    @IBInspectable var toggleButton: Bool = false
    var originalBackgroundColor: UIColor?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        originalBackgroundColor = backgroundColor
        setTitleColor(titleColorForState(.Selected), forState: [.Highlighted, .Selected])
        setTitle(titleForState(.Selected), forState: [.Highlighted, .Selected])
        configureToggle()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureToggle()
    }
    
    override var highlighted: Bool {
        get { return super.highlighted }
        set { super.highlighted = newValue; refreshUI() }
    }
    
    override var selected: Bool {
        get { return super.selected }
        set { super.selected = newValue; refreshUI() }
    }
    
    override var enabled: Bool {
        get { return super.enabled }
        set { super.enabled = newValue; refreshUI() }
    }
    
    private func configureToggle() {
        addTarget(self, action: "buttonAction:", forControlEvents: .TouchUpInside)
    }
    
    func buttonAction(sender: UIButton!) {
        if toggleButton {
            selected = !selected
        }
    }
    
    func refreshUI() {
        if originalBackgroundColor == nil {
            originalBackgroundColor = self.backgroundColor
        }
        self.backgroundColor = getCurrentBackgroundColor() ?? originalBackgroundColor
        updateElements()
    }
    
    func updateElements() {
        if let highlightedElements = highlightedElements {
            let highlighted = self.selected || self.highlighted
            for element in highlightedElements {
                if let element = element as? Highlightable {
                    var e = element
                    e.highlighted = highlighted
                }
            }
        }
    }
    
    func getCurrentBackgroundColor() -> UIColor? {
        switch (enabled, highlighted, selected) {
        case (false, true, _): return highlightedDisabledBackgroundColor ?? disabledBackgroundColor
        case (false, false, _): return disabledBackgroundColor ?? originalBackgroundColor?.colorWithAlpha(0.5)
        case (true, true, true): return highlightedSelectedBackgroundColor ?? highlightedBackgroundColor
        case (true, true, false): return highlightedBackgroundColor
        case (true, false, true): return selectedBackgroundColor ?? highlightedBackgroundColor
        default: return .None
        }
    }
}
