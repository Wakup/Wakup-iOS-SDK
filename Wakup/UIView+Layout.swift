//
//  UIView+Layout.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 05/01/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    /**
    - returns: true if v is in this view's super view chain
    */
    public func isSuper(_ v : UIView) -> Bool
    {
        var s = self
        while (s.superview != nil) {
            s = s.superview!
            if (v == s) {
                return true

            }
        }
        return false
    }
    
    func constraint(_ item1: UIView, _ attribute1: NSLayoutAttribute, _ relation: NSLayoutRelation, _ item2: UIView, _ attribute2: NSLayoutAttribute, constant: CGFloat = 0.0, multiplier: CGFloat = 1.0) -> NSLayoutConstraint
    {
        return NSLayoutConstraint(item: item1, attribute: attribute1, relatedBy: relation, toItem: item2, attribute: attribute2, multiplier: multiplier, constant: constant)
    }
    
    func constraint(_ item1: UIView, _ attribute1: NSLayoutAttribute, _ relation: NSLayoutRelation, constant: CGFloat = 0.0, multiplier : CGFloat = 1.0) -> NSLayoutConstraint
    {
        return NSLayoutConstraint(item: item1, attribute: attribute1, relatedBy: relation, toItem: nil, attribute: .notAnAttribute, multiplier: multiplier, constant: constant)
    }
    
    public func constrain(_ attribute: NSLayoutAttribute, _ relation: NSLayoutRelation, _ otherView: UIView, _ otherAttribute: NSLayoutAttribute, constant: CGFloat = 0.0, multiplier : CGFloat = 1.0) -> UIView?
    {
        let c = constraint(self, attribute, relation, otherView, otherAttribute, constant: constant, multiplier: multiplier)
        
        if isSuper(otherView) {
            otherView.addConstraint(c)
            return self
        }
        else if(otherView.isSuper(self) || otherView == self)
        {
            self.addConstraint(c)
            return self
        }
        assert(false)
        return nil
    }
    
    public func constrain(_ attribute: NSLayoutAttribute, _ relation: NSLayoutRelation, constant: CGFloat, multiplier : CGFloat = 1.0) -> UIView?
    {
        let c = constraint(self, attribute, relation, constant: constant, multiplier: multiplier)
        self.addConstraint(c)
        return self
    }
    
}
