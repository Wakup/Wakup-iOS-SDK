//
//  NavigationControllerDelegate.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 16/12/14.
//  Copyright (c) 2014 Yellow Pineapple. All rights reserved.
//

import Foundation
import UIKit

open class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
    open func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        switch (operation, fromVC, toVC) {
        case (.push, is ZoomTransitionOrigin, is ZoomTransitionDestination):
            return ZoomTransitionAnimator()
        case (.pop, let destination as ZoomTransitionDestination, is ZoomTransitionOrigin) where isViewVisible(destination.zoomTransitionDestinationView()):
            return ZoomTransitionAnimator(reversed: true)
        default:
            return nil
        }
    }
    
    func isViewVisible(_ view: UIView) -> Bool {
        if let window = view.window {
            let viewFrame = window.convert(view.frame, from: view.superview)
            return window.bounds.intersects(viewFrame)
        }
        return false
    }
}
