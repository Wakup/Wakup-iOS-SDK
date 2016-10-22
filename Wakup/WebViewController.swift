//
//  WebViewController.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 13/02/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import UIKit

open class WebViewController: LoadingPresenterViewController, UIWebViewDelegate {
    
    open var url: URL?
    open var showRefreshButton = false
    
    var isModal: Bool {
        guard let navigationController = navigationController else { return false }
        return navigationController.presentingViewController != nil && navigationController.viewControllers.first == self
    }
    
    @IBOutlet var webView: UIWebView!
    
    open func loadUrl(_ url: URL, animated: Bool = true) {
        self.url = url
        showLoadingView()
        webView?.loadRequest(URLRequest(url: url))
    }
    
    // MARK: View lifecycle
    open override func viewDidLoad() {
        super.viewDidLoad()

        setupLoadingView()
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
        return UIApplication.shared.openURL(url)
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
    func dismissAction(_ sender: NSObject!) {
        dismiss(animated: true, completion: nil)
    }
    
    func refreshAction(_ sender: NSObject!) {
        webView.reload()
    }
    
    // MARK: UIWebViewDelegate
    open func webViewDidStartLoad(_ webView: UIWebView) {
        showLoadingView()
    }
    open func webViewDidFinishLoad(_ webView: UIWebView) {
        dismissLoadingView()
    }
    open func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
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
}
