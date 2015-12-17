//
//  NavigationControllerDelegate.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 16/12/14.
//  Copyright (c) 2014 Yellow Pineapple. All rights reserved.
//

import Foundation
import UIKit

class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        switch (operation, fromVC, toVC) {
        case (.Push, is ZoomTransitionOrigin, is ZoomTransitionDestination):
            return ZoomTransitionAnimator()
        case (.Pop, let destination as ZoomTransitionDestination, is ZoomTransitionOrigin) where isViewVisible(destination.zoomTransitionDestinationView()):
            return ZoomTransitionAnimator(reversed: true)
        default:
            return nil
        }
    }
    
    func isViewVisible(view: UIView) -> Bool {
        if let window = view.window {
            let viewFrame = window.convertRect(view.frame, fromView: view.superview)
            return CGRectIntersectsRect(window.bounds, viewFrame)
        }
        return false
    }
}