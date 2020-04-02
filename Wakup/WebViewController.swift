//
//  WebViewController.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 13/02/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import UIKit
import WebKit

open class WebViewController: LoadingPresenterViewController, WKNavigationDelegate, WKUIDelegate {
    
    open var url: URL?
    open var showRefreshButton = false
    
    var isModal: Bool {
        guard let navigationController = navigationController else { return false }
        return navigationController.presentingViewController != nil && navigationController.viewControllers.first == self
    }
    
    @IBOutlet var webView: WKWebView!
    
    open func loadUrl(_ url: URL, animated: Bool = true) {
        self.url = url
        showLoadingView()
        webView?.load(URLRequest(url: url))
    }
    
    // MARK: View lifecycle
    open override func viewDidLoad() {
        super.viewDidLoad()

        setupLoadingView()
        webView?.uiDelegate = self
        webView?.navigationDelegate = self
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.presentedViewController == nil {
            if let url = self.url {
                loadUrl(url, animated: false)
            }
        }
        
        // Auto-detect modal and add close button
        if isModal && navigationItem.leftBarButtonItem == nil {
            let closeButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(WebViewController.dismissAction(_:)))
            navigationItem.leftBarButtonItem = closeButton
        }
        
        if showRefreshButton && navigationItem.rightBarButtonItem == nil {
            let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(WebViewController.refreshAction(_:)))
            navigationItem.rightBarButtonItem = refreshButton
        }
    }
    
    open func openInSafari() -> Bool {
        guard let url = url else { return false }
        if (UIApplication.shared.canOpenURL(url)) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            return true
        }
        return false;
    }
    
    open func closeController(_ animated: Bool = true) {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: animated)
        }
        if let presentingViewController = presentingViewController {
            presentingViewController.dismiss(animated: animated, completion: nil)
        }
    }
    
    // MARK: Actions
    @objc func dismissAction(_ sender: NSObject!) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func refreshAction(_ sender: NSObject!) {
        webView.reload()
    }
    
    // MARK: WKNavigationDelegate
    open func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        dismissLoadingView()
        
        let error = error as NSError
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
        let alert = UIAlertController(title: "WebViewError".i18n(), message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "CloseDialogButton".i18n(), style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    open func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showLoadingView()
    }
    
    open func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        dismissLoadingView()
    }
}
