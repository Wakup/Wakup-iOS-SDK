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
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return firstStepAnimationDuration + secondStepAnimationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let containerView = transitionContext.containerView else { return }
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let fromMainView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        let fromView = (fromViewController as! ZoomTransitionOrigin).zoomTransitionOriginView()
        let fromSnapshot = getSnapshotView(fromView: fromView)
        
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let toMainView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        let toView = (toViewController as! ZoomTransitionDestination).zoomTransitionDestinationView()
        
        containerView.addSubview(fromMainView)
        containerView.addSubview(fromSnapshot)
        containerView.addSubview(toMainView)
        
        let fromSnapshotFrame = containerView.convert(fromView.frame, from: fromView.superview)
        let toSnapshotFrame = containerView.convert(toView.frame, from: toView.superview)
        
        fromSnapshot.frame = fromSnapshotFrame
        toMainView.alpha = 0
        
        let backgroundView = UIView(frame: containerView.bounds)
        backgroundView.backgroundColor = toMainView.backgroundColor
        backgroundView.alpha = 0
        containerView.insertSubview(backgroundView, belowSubview: fromSnapshot)
        
        UIView.animate(withDuration: firstStepAnimationDuration, animations: { () -> Void in
            fromMainView.alpha = 0
            backgroundView.alpha = 1
            fromSnapshot.frame = toSnapshotFrame
            }, completion: { finished in
                if finished {
                    fromMainView.removeFromSuperview()
                    fromMainView.alpha = 1
                    UIView.animate(withDuration: self.secondStepAnimationDuration, animations: { () -> Void in
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
        view.layer.render(in: context)
        let snapshot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        return snapshot!
    }
    
    func getSnapshotView(fromView view: UIView) -> UIImageView {
        let image = getSnapshot(fromView: view)
        let imageView = UIImageView(image: image)
        imageView.frame = view.frame
        return imageView
    }
    
}
