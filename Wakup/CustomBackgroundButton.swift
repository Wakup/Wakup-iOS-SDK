//
//  CustomBackgroundButton.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 23/02/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable public class CustomBackgroundButton: UIButton {
    @IBOutlet var highlightedElements: Array<UIView>?
    @IBInspectable public dynamic var selectedBackgroundColor: UIColor?
    @IBInspectable public dynamic var highlightedBackgroundColor: UIColor?
    @IBInspectable public dynamic var disabledBackgroundColor: UIColor?
    @IBInspectable public dynamic var highlightedDisabledBackgroundColor: UIColor?
    @IBInspectable public dynamic var highlightedSelectedBackgroundColor: UIColor?
    @IBInspectable public var toggleButton: Bool = false
    var originalBackgroundColor: UIColor?
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setTitleColor(titleColorForState(.Selected), forState: [.Highlighted, .Selected])
        setTitle(titleForState(.Selected), forState: [.Highlighted, .Selected])
        configureToggle()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureToggle()
    }
    
    override public var highlighted: Bool {
        get { return super.highlighted }
        set { super.highlighted = newValue; setNeedsLayout() }
    }
    
    override public var selected: Bool {
        get { return super.selected }
        set { super.selected = newValue; setNeedsLayout() }
    }
    
    override public var enabled: Bool {
        get { return super.enabled }
        set { super.enabled = newValue; setNeedsLayout() }
    }
    
    private func configureToggle() {
        addTarget(self, action: "buttonAction:", forControlEvents: .TouchUpInside)
    }
    
    func buttonAction(sender: UIButton!) {
        if toggleButton {
            selected = !selected
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        refreshUI()
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
