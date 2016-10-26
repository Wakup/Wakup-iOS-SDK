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
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return firstStepAnimationDuration + secondStepAnimationDuration
    }
    
    fileprivate func substract(fromPoint p1: CGPoint, toPoint p2: CGPoint) -> CGPoint {
        return CGPoint(x: p1.x - p2.x, y: p1.y - p2.y)
    }
    
    fileprivate func setAnchorPoint(_ anchorPoint: CGPoint, forView view: UIView) {
        var newPoint = CGPoint(x: view.bounds.size.width * anchorPoint.x, y: view.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x: view.bounds.size.width * view.layer.anchorPoint.x, y: view.bounds.size.height * view.layer.anchorPoint.y)
        
        newPoint = newPoint.applying(view.transform)
        oldPoint = oldPoint.applying(view.transform)
        
        var position = view.layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        view.layer.position = position
        view.layer.anchorPoint = anchorPoint
    }
    
    fileprivate func getFromView(forTransitionContext transitionContext: UIViewControllerContextTransitioning) -> UIView {
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        if presenting {
            return (fromViewController as! ZoomTransitionOrigin).zoomTransitionOriginView()
        }
        else {
            return (fromViewController as! ZoomTransitionDestination).zoomTransitionDestinationView()
        }
    }
    
    fileprivate func getToView(forTransitionContext transitionContext: UIViewControllerContextTransitioning) -> UIView {
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
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
        view.layer.render(in: context!)
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
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let fromMainView = transitionContext.view(forKey: .from)!
        let toMainView = transitionContext.view(forKey: .to)!
        fromMainView.frame = containerView.bounds
        toMainView.frame = containerView.bounds
        containerView.addSubview(fromMainView)
        containerView.addSubview(toMainView)
        toMainView.layoutIfNeeded()
        
        let fromView = getFromView(forTransitionContext: transitionContext)
        let toView = getToView(forTransitionContext: transitionContext)
        
        let fromSnapshotView = getSnapshotView(fromView: fromView)
        containerView.addSubview(fromSnapshotView)
        
        // Center of the 'from' view relative to its view controller
        let fromViewCenter = containerView.convert(fromView.center, from: fromView.superview)
        // Center of the 'from' view relative to the container view
        let fromSnapshotCenter = containerView.convert(fromView.center, from: fromView.superview)
        
        // Center of the 'to' view relative to its view controller
        let toViewCenter = containerView.convert(toView.center, from: toView.superview)
        // Center of the 'to' view relative to the container view
        let toSnapshotCenter = containerView.convert(toView.center, from: toView.superview)
        
        // Distance of center of the 'from' view to the 'to' view relative to the container view
        let fromCenterOffset = substract(fromPoint: fromSnapshotCenter, toPoint: toSnapshotCenter)
        let toCenterOffset = CGPoint(x: -fromCenterOffset.x, y: -fromCenterOffset.y)
        
        // Translation transform of each view to the other
        let fromTranslationTransform = CGAffineTransform(translationX: -fromCenterOffset.x, y: -fromCenterOffset.y)
        let toTranslationTransform = CGAffineTransform(translationX: -toCenterOffset.x, y: -toCenterOffset.y)
        
        // Image scale between the 'from' view and the 'to' view
        let fromScale = toView.frame.width / fromView.frame.width
        let toScale = 1 / fromScale
        // Translation and scale transform for each view to match the other's position
        let fromScaleTransform = fromTranslationTransform.scaledBy(x: fromScale, y: fromScale)
        let toScaleTransform = toTranslationTransform.scaledBy(x: toScale, y: toScale)
        
        // Background view to fill the container view when the current view doesn't cover the screen or it's not opaque
        let backgroundView = UIView(frame: containerView.bounds)
        backgroundView.backgroundColor = toMainView.backgroundColor
        
        let fromAnchorPoint = CGPoint(x: fromViewCenter.x / fromMainView.bounds.width, y: fromViewCenter.y / fromMainView.bounds.height)
        let toAnchorPoint = CGPoint(x: toViewCenter.x / toMainView.bounds.width, y: toViewCenter.y / toMainView.bounds.height)

        // Set the center of the animation in the center of the view
        setAnchorPoint(fromAnchorPoint, forView: fromMainView)
        setAnchorPoint(toAnchorPoint, forView: toMainView)
        
        fromSnapshotView.center = fromSnapshotCenter
        
        containerView.insertSubview(backgroundView, at: 0)
        
        if presenting {
            // Two-step animation
            toMainView.alpha = 0
            // First step: Hide the 'from' main view while both the 'from' view and the snapshot
            // scale and re-position to match the 'to' view position
            UIView.animate(withDuration: firstStepAnimationDuration, animations: { () -> Void in
                fromMainView.alpha = 0
                fromMainView.transform = fromScaleTransform
                fromSnapshotView.transform = fromScaleTransform
                }, completion: { finished in
                    if finished {
                        // Second step: Show the 'to' main view, covering the still visible snapshot and
                        // showing the rest of the view
                        UIView.animate(withDuration: self.secondStepAnimationDuration, animations: { () -> Void in
                            toMainView.alpha = 1
                            }, completion: { finished in
                                if (finished) {
                                    // Animation finished, cleanup
                                    self.setAnchorPoint(CGPoint(x: 0.5, y: 0.5), forView: fromMainView)
                                    self.setAnchorPoint(CGPoint(x: 0.5, y: 0.5), forView: toMainView)
                                    fromMainView.alpha = 1
                                    fromMainView.transform = CGAffineTransform.identity
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
            containerView.bringSubview(toFront: fromSnapshotView)
            containerView.bringSubview(toFront: toMainView)
            toMainView.alpha = 0
            toMainView.transform = toScaleTransform
            
            // First step: Hide the 'from' main fiew to show the snapshot view in the same spot as the 'from' view
            UIView.animate(withDuration: secondStepAnimationDuration, animations: { () -> Void in
                fromMainView.alpha = 0
                }, completion: { finished in
                    if finished {
                        fromMainView.removeFromSuperview()
                        // Second step: Show the 'to' view, covering the snapshot view while it scales back to its original size and position
                        UIView.animate(withDuration: self.firstStepAnimationDuration, animations: { () -> Void in
                            fromSnapshotView.transform = fromScaleTransform
                            toMainView.transform = CGAffineTransform.identity
                            toMainView.alpha = 1
                            }, completion: { finished in
                                if (finished) {
                                    // Animation finished, cleanup
                                    self.setAnchorPoint(CGPoint(x: 0.5, y: 0.5), forView: fromMainView)
                                    self.setAnchorPoint(CGPoint(x: 0.5, y: 0.5), forView: toMainView)
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
