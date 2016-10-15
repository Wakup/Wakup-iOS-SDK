//
//  CustomBackgroundButton.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 23/02/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable open class CustomBackgroundButton: UIButton {
    @IBOutlet var highlightedElements: Array<UIView>?
    @IBInspectable open dynamic var selectedBackgroundColor: UIColor?
    @IBInspectable open dynamic var highlightedBackgroundColor: UIColor?
    @IBInspectable open dynamic var disabledBackgroundColor: UIColor?
    @IBInspectable open dynamic var highlightedDisabledBackgroundColor: UIColor?
    @IBInspectable open dynamic var highlightedSelectedBackgroundColor: UIColor?
    @IBInspectable open var toggleButton: Bool = false
    var originalBackgroundColor: UIColor?
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setTitleColor(titleColor(for: .selected), for: [.highlighted, .selected])
        setTitle(title(for: .selected), for: [.highlighted, .selected])
        configureToggle()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureToggle()
    }
    
    override open var isHighlighted: Bool {
        get { return super.isHighlighted }
        set { super.isHighlighted = newValue; setNeedsLayout() }
    }
    
    override open var isSelected: Bool {
        get { return super.isSelected }
        set { super.isSelected = newValue; setNeedsLayout() }
    }
    
    override open var isEnabled: Bool {
        get { return super.isEnabled }
        set { super.isEnabled = newValue; setNeedsLayout() }
    }
    
    fileprivate func configureToggle() {
        addTarget(self, action: #selector(CustomBackgroundButton.buttonAction(_:)), for: .touchUpInside)
    }
    
    func buttonAction(_ sender: UIButton!) {
        if toggleButton {
            isSelected = !isSelected
        }
    }
    
    open override func layoutSubviews() {
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
            let highlighted = self.isSelected || self.isHighlighted
            for element in highlightedElements {
                if let element = element as? Highlightable {
                    var e = element
                    e.highlighted = highlighted
                }
            }
        }
    }
    
    func getCurrentBackgroundColor() -> UIColor? {
        switch (isEnabled, isHighlighted, isSelected) {
        case (false, true, _): return highlightedDisabledBackgroundColor ?? disabledBackgroundColor
        case (false, false, _): return disabledBackgroundColor ?? originalBackgroundColor?.colorWithAlpha(0.5)
        case (true, true, true): return highlightedSelectedBackgroundColor ?? highlightedBackgroundColor
        case (true, true, false): return highlightedBackgroundColor
        case (true, false, true): return selectedBackgroundColor ?? highlightedBackgroundColor
        default: return .none
        }
    }
}
