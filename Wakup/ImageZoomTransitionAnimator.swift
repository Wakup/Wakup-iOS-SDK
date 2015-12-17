//
//  ImageZoomTransitionAnimator.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 18/12/14.
//  Copyright (c) 2014 Yellow Pineapple. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 8.0, *)
class ImageZoomTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let firstStepAnimationDuration = 0.35
    let secondStepAnimationDuration = 0.15
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return firstStepAnimationDuration + secondStepAnimationDuration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let containerView = transitionContext.containerView() else { return }
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let fromMainView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let fromView = (fromViewController as! ZoomTransitionOrigin).zoomTransitionOriginView()
        let fromSnapshot = getSnapshotView(fromView: fromView)
        
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let toMainView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        let toView = (toViewController as! ZoomTransitionDestination).zoomTransitionDestinationView()
        
        containerView.addSubview(fromMainView)
        containerView.addSubview(fromSnapshot)
        containerView.addSubview(toMainView)
        
        let fromSnapshotFrame = containerView.convertRect(fromView.frame, fromView: fromView.superview)
        let toSnapshotFrame = containerView.convertRect(toView.frame, fromView: toView.superview)
        
        fromSnapshot.frame = fromSnapshotFrame
        toMainView.alpha = 0
        
        let backgroundView = UIView(frame: containerView.bounds)
        backgroundView.backgroundColor = toMainView.backgroundColor
        backgroundView.alpha = 0
        containerView.insertSubview(backgroundView, belowSubview: fromSnapshot)
        
        UIView.animateWithDuration(firstStepAnimationDuration, animations: { () -> Void in
            fromMainView.alpha = 0
            backgroundView.alpha = 1
            fromSnapshot.frame = toSnapshotFrame
            }, completion: { finished in
                if finished {
                    fromMainView.removeFromSuperview()
                    fromMainView.alpha = 1
                    UIView.animateWithDuration(self.secondStepAnimationDuration, animations: { () -> Void in
                        toMainView.alpha = 1
                        }, completion: { finished in
                            if (finished) {
                                fromSnapshot.removeFromSuperview()
                                backgroundView.removeFromSuperview()
                                transitionContext.completeTransition(true)
                            }
                    })
                    
                }
        })
        
    }
    
    func getSnapshot(fromView view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, true, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }
        view.layer.renderInContext(context)
        let snapshot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        return snapshot
    }
    
    func getSnapshotView(fromView view: UIView) -> UIImageView {
        let image = getSnapshot(fromView: view)
        let imageView = UIImageView(image: image)
        imageView.frame = view.frame
        return imageView
    }
    
}