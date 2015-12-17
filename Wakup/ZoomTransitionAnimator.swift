//
//  CircleTransitionAnimator.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 16/12/14.
//  Copyright (c) 2014 Yellow Pineapple. All rights reserved.
//

import UIKit

@objc protocol ZoomTransitionOrigin {
    func zoomTransitionOriginView() -> UIView
}

@objc protocol ZoomTransitionDestination {
    func zoomTransitionDestinationView() -> UIView
}

class ZoomTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    let firstStepAnimationDuration = 0.35
    let secondStepAnimationDuration = 0.15
    
    var presenting = true
    
    convenience init(reversed: Bool) {
        self.init()
        self.presenting = !reversed
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return firstStepAnimationDuration + secondStepAnimationDuration
    }
    
    private func substract(fromPoint p1: CGPoint, toPoint p2: CGPoint) -> CGPoint {
        return CGPointMake(p1.x - p2.x, p1.y - p2.y)
    }
    
    private func setAnchorPoint(anchorPoint: CGPoint, forView view: UIView) {
        var newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x, view.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x, view.bounds.size.height * view.layer.anchorPoint.y)
        
        newPoint = CGPointApplyAffineTransform(newPoint, view.transform)
        oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform)
        
        var position = view.layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        view.layer.position = position
        view.layer.anchorPoint = anchorPoint
    }
    
    private func getFromView(forTransitionContext transitionContext: UIViewControllerContextTransitioning) -> UIView {
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        if presenting {
            return (fromViewController as! ZoomTransitionOrigin).zoomTransitionOriginView()
        }
        else {
            return (fromViewController as! ZoomTransitionDestination).zoomTransitionDestinationView()
        }
    }
    
    private func getToView(forTransitionContext transitionContext: UIViewControllerContextTransitioning) -> UIView {
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        if presenting {
            return (toViewController as! ZoomTransitionDestination).zoomTransitionDestinationView()
        }
        else {
            return (toViewController as! ZoomTransitionOrigin).zoomTransitionOriginView()
        }
    }
    
    func getSnapshot(fromView view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, true, 0.0)
        let context = UIGraphicsGetCurrentContext()
        view.layer.renderInContext(context!)
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
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let containerView = transitionContext.containerView() else { return }
        let fromMainView = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!.view!
        let toMainView = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!.view!
        fromMainView.frame = containerView.bounds
        toMainView.frame = containerView.bounds
        containerView.addSubview(fromMainView)
        containerView.addSubview(toMainView)
        
        let fromView = getFromView(forTransitionContext: transitionContext)
        let toView = getToView(forTransitionContext: transitionContext)
        
        let fromSnapshotView = getSnapshotView(fromView: fromView)
        containerView.addSubview(fromSnapshotView)
        
        // Center of the 'from' view relative to its view controller
        let fromViewCenter = fromMainView.convertPoint(fromView.center, fromView: fromView.superview)
        // Center of the 'from' view relative to the container view
        let fromSnapshotCenter = containerView.convertPoint(fromView.center, fromView: fromView.superview)
        
        // Center of the 'to' view relative to its view controller
        let toViewCenter = toMainView.convertPoint(toView.center, fromView: toView.superview)
        // Center of the 'to' view relative to the container view
        let toSnapshotCenter = containerView.convertPoint(toView.center, fromView: toView.superview)
        
        // Distance of center of the 'from' view to the 'to' view relative to the container view
        let fromCenterOffset = substract(fromPoint: fromSnapshotCenter, toPoint: toSnapshotCenter)
        let toCenterOffset = CGPointMake(-fromCenterOffset.x, -fromCenterOffset.y)
        
        // Translation transform of each view to the other
        let fromTranslationTransform = CGAffineTransformMakeTranslation(-fromCenterOffset.x, -fromCenterOffset.y)
        let toTranslationTransform = CGAffineTransformMakeTranslation(-toCenterOffset.x, -toCenterOffset.y)
        
        // Image scale between the 'from' view and the 'to' view
        let fromScale = CGRectGetWidth(toView.frame) / CGRectGetWidth(fromView.frame)
        let toScale = 1 / fromScale
        // Translation and scale transform for each view to match the other's position
        let fromScaleTransform = CGAffineTransformScale(fromTranslationTransform, fromScale, fromScale)
        let toScaleTransform = CGAffineTransformScale(toTranslationTransform, toScale, toScale)
        
        // Background view to fill
        let backgroundView = UIView(frame: containerView.bounds)
        backgroundView.backgroundColor = toMainView.backgroundColor
        
        let fromAnchorPoint = CGPointMake(fromViewCenter.x / CGRectGetWidth(fromMainView.bounds), fromViewCenter.y / CGRectGetHeight(fromMainView.bounds))
        let toAnchorPoint = CGPointMake(toViewCenter.x / CGRectGetWidth(toMainView.bounds), toViewCenter.y / CGRectGetHeight(toMainView.bounds))

        // Set the center of the animation in the center of the view the container view when the current view doesn't cover the screen or it's not opaque
        setAnchorPoint(fromAnchorPoint, forView: fromMainView)
        setAnchorPoint(toAnchorPoint, forView: toMainView)
        
        fromSnapshotView.center = fromSnapshotCenter
        
        containerView.insertSubview(backgroundView, atIndex: 0)
        
        if presenting {
            // Two-step animation
            toMainView.alpha = 0
            // First step: Hide the 'from' main view while both the 'from' view and the snapshot
            // scale and re-position to match the 'to' view position
            UIView.animateWithDuration(firstStepAnimationDuration, animations: { () -> Void in
                fromMainView.alpha = 0
                fromMainView.transform = fromScaleTransform
                fromSnapshotView.transform = fromScaleTransform
                }, completion: { finished in
                    if finished {
                        // Second step: Show the 'to' main view, covering the still visible snapshot and
                        // showing the rest of the view
                        UIView.animateWithDuration(self.secondStepAnimationDuration, animations: { () -> Void in
                            toMainView.alpha = 1
                            }, completion: { finished in
                                if (finished) {
                                    // Animation finished, cleanup
                                    self.setAnchorPoint(CGPointMake(0.5, 0.5), forView: fromMainView)
                                    self.setAnchorPoint(CGPointMake(0.5, 0.5), forView: toMainView)
                                    fromMainView.alpha = 1
                                    fromMainView.transform = CGAffineTransformIdentity
                                    fromMainView.removeFromSuperview()
                                    fromSnapshotView.removeFromSuperview()
                                    backgroundView.removeFromSuperview()
                                    transitionContext.completeTransition(true)
                                }
                        })
                        
                    }
            })
        }
        else {
            // Reverse animation is exactly the opposite steps
            containerView.bringSubviewToFront(fromSnapshotView)
            containerView.bringSubviewToFront(toMainView)
            toMainView.alpha = 0
            toMainView.transform = toScaleTransform
            
            // First step: Hide the 'from' main fiew to show the snapshot view in the same spot as the 'from' view
            UIView.animateWithDuration(secondStepAnimationDuration, animations: { () -> Void in
                fromMainView.alpha = 0
                }, completion: { finished in
                    if finished {
                        fromMainView.removeFromSuperview()
                        // Second step: Show the 'to' view, covering the snapshot view while it scales back to its original size and position
                        UIView.animateWithDuration(self.firstStepAnimationDuration, animations: { () -> Void in
                            fromSnapshotView.transform = fromScaleTransform
                            toMainView.transform = CGAffineTransformIdentity
                            toMainView.alpha = 1
                            }, completion: { finished in
                                if (finished) {
                                    // Animation finished, cleanup
                                    self.setAnchorPoint(CGPointMake(0.5, 0.5), forView: fromMainView)
                                    self.setAnchorPoint(CGPointMake(0.5, 0.5), forView: toMainView)
                                    fromMainView.alpha = 1
                                    fromMainView.removeFromSuperview()
                                    fromSnapshotView.removeFromSuperview()
                                    backgroundView.removeFromSuperview()
                                    transitionContext.completeTransition(true)
                                }
                        })
                        
                    }
            })
        }
        
    }
    
    
    
}
