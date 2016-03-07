//
//  LoadingPresenterViewController.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 17/02/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation


protocol LoadingViewProtocol {
    func showLoadingView(animated animated: Bool)
    func dismissLoadingView(animated animated: Bool, completion: (() -> Void)?)
}

public class LoadingPresenterViewController: UIViewController, LoadingViewProtocol {
    var showingLoadingView = false
    
    var loadingController: UIViewController?
    
    private var loading = false
    
    func setupLoadingView() {
        loadingController = self.storyboard?.instantiateViewControllerWithIdentifier("loadingViewController")
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if loading {
            showLoadingView(animated: true)
        }
    }
    
    public override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.loadingController?.view.removeFromSuperview()
        showingLoadingView = false
    }
    
    func showLoadingView(animated animated: Bool = true) {
        loading = true
        if (loadingController == nil) {
            setupLoadingView()
        }
        if (showingLoadingView) {
            return
        }
        
        showingLoadingView = true;
        if let loadingController = loadingController {
            if let window = UIApplication.sharedApplication().keyWindow {
                loadingController.view.frame = window.bounds
                if animated {
                    loadingController.view.alpha = 0
                    window.addSubview(loadingController.view)
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        loadingController.view.alpha = 1
                    })
                }
                else {
                    window.addSubview(loadingController.view)
                }
            }
        }
    }
    
    func dismissLoadingView(animated animated: Bool = true, completion: (() -> Void)? = nil) {
        loading = false
        if (loadingController == nil) {
            setupLoadingView()
        }
        if (!showingLoadingView) {
            return
        }
        showingLoadingView = false;
        if animated {
            UIView.animateWithDuration(0.3, delay: 0.3, options: .BeginFromCurrentState, animations: { () -> Void in
                self.loadingController?.view.alpha = 0
                return
                }, completion: { (finished) -> Void in
                    self.loadingController?.view.alpha = 1
                    self.loadingController?.view.removeFromSuperview()
                    completion?()
            })
        }
        else {
            loadingController?.view.removeFromSuperview()
            completion?()
        }
    }

}