//
//  LoadingPresenterViewController.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 17/02/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation

@objc public protocol LoadingViewProtocol {
    @objc func showLoadingView(animated: Bool)
    @objc func dismissLoadingView(animated: Bool, completion: (() -> Void)?)
}

open class LoadingPresenterViewController: UIViewController, LoadingViewProtocol {
    var showingLoadingView = false
    
    var loadingController: UIViewController?
    
    fileprivate var loading = false
    
    func setupLoadingView() {
        loadingController = self.storyboard?.instantiateViewController(withIdentifier: "loadingViewController")
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if loading {
            showLoadingView(animated: true)
        }
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.loadingController?.view.removeFromSuperview()
        showingLoadingView = false
    }
    
    public func showLoadingView(animated: Bool = true) {
        loading = true
        if (loadingController == nil) {
            setupLoadingView()
        }
        if (showingLoadingView) {
            return
        }
        
        showingLoadingView = true;
        if let loadingController = loadingController {
            if let window = UIApplication.shared.keyWindow {
                loadingController.view.frame = window.bounds
                if animated {
                    loadingController.view.alpha = 0
                    window.addSubview(loadingController.view)
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        loadingController.view.alpha = 1
                    })
                }
                else {
                    window.addSubview(loadingController.view)
                }
            }
        }
    }
    
    public func dismissLoadingView(animated: Bool = true, completion: (() -> Void)? = nil) {
        loading = false
        if (loadingController == nil) {
            setupLoadingView()
        }
        if (!showingLoadingView) {
            return
        }
        showingLoadingView = false;
        if animated {
            UIView.animate(withDuration: 0.3, delay: 0.3, options: .beginFromCurrentState, animations: { () -> Void in
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

import SDWebImage
extension LoadingPresenterViewController {
    private func shareCouponInPresenter(_ coupon: Coupon, presenter: UIViewController) {
        let shareText = coupon.company.name + " - " + coupon.shortDescription + "\n" + "ShareOfferFooter".i18n()
        let imageUrl = coupon.image?.sourceUrl
        presenter.shareTextImageAndURL(text: shareText, imageURL: imageUrl, linkURL: nil, loadingProtocol: self)
    }
    
    func shareCoupon(_ coupon: Coupon) {
        let presenter = self.navigationController ?? self
        
        if let customShareFunction = WakupManager.manager.options.customShareFunction {
            customShareFunction(coupon, presenter, self)
        }
        else {
            shareCouponInPresenter(coupon, presenter: presenter)
        }
    }
}
