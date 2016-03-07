//
//  WebViewController.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 13/02/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import UIKit

public class WebViewController: LoadingPresenterViewController, UIWebViewDelegate {
    
    public var url: NSURL?
    public var showRefreshButton = false
    
    var isModal: Bool {
        guard let navigationController = navigationController else { return false }
        return navigationController.presentingViewController != nil && navigationController.viewControllers.first == self
    }
    
    @IBOutlet var webView: UIWebView!
    
    public func loadUrl(url: NSURL, animated: Bool = true) {
        self.url = url
        showLoadingView()
        webView?.loadRequest(NSURLRequest(URL: url))
    }
    
    // MARK: View lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()

        setupLoadingView()
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if self.presentedViewController == nil {
            if let url = self.url {
                loadUrl(url, animated: false)
            }
        }
        
        // Auto-detect modal and add close button
        if isModal && navigationItem.leftBarButtonItem == nil {
            let closeButton = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: "dismissAction:")
            navigationItem.leftBarButtonItem = closeButton
        }
        
        if showRefreshButton && navigationItem.rightBarButtonItem == nil {
            let refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "refreshAction:")
            navigationItem.rightBarButtonItem = refreshButton
        }
    }
    
    public func openInSafari() -> Bool {
        guard let url = url else { return false }
        return UIApplication.sharedApplication().openURL(url)
    }
    
    public func closeController(animated: Bool = true) {
        if let navigationController = navigationController {
            navigationController.popViewControllerAnimated(animated)
        }
        if let presentingViewController = presentingViewController {
            presentingViewController.dismissViewControllerAnimated(animated, completion: nil)
        }
    }
    
    // MARK: Actions
    func dismissAction(sender: NSObject!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func refreshAction(sender: NSObject!) {
        webView.reload()
    }
    
    // MARK: UIWebViewDelegate
    public func webViewDidStartLoad(webView: UIWebView) {
        showLoadingView()
    }
    public func webViewDidFinishLoad(webView: UIWebView) {
        dismissLoadingView()
    }
    public func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        dismissLoadingView()
        
        guard let error = error else { return }
        if error.domain == "WebKitErrorDomain" && error.code == 204 {
            return
        }
        if #available(iOS 9.0, *) {
            if error.domain == NSURLErrorDomain && error.code == NSURLErrorAppTransportSecurityRequiresSecureConnection {
                if openInSafari() {
                    closeController()
                    return
                }
            }
        }
        UIAlertView(title: "WebViewError".i18n(), message: error.localizedDescription, delegate: nil, cancelButtonTitle: "CloseDialogButton".i18n()).show()
        
    }
}
