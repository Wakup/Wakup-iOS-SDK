//
//  WebViewController.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 13/02/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import UIKit

class WebViewController: LoadingPresenterViewController, UIWebViewDelegate {
    
    var url: NSURL?
    
    @IBOutlet var webView: UIWebView!
    
    func loadUrl(url: NSURL, animated: Bool = true) {
        showLoadingView()
        webView?.loadRequest(NSURLRequest(URL: url))
    }
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLoadingView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if self.presentedViewController == nil {
            if let url = self.url {
                loadUrl(url, animated: false)
            }
        }
    }
    
    // MARK: UIWebViewDelegate
    func webViewDidStartLoad(webView: UIWebView) {
        showLoadingView()
    }
    func webViewDidFinishLoad(webView: UIWebView) {
        dismissLoadingView()
    }
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        dismissLoadingView()
        
        guard let error = error else { return }
        if error.domain == "WebKitErrorDomain" && error.code == 204 {
            return
        }
        UIAlertView(title: "WebViewError".i18n(), message: error.localizedDescription, delegate: nil, cancelButtonTitle: "CloseDialogButton".i18n()).show()
        
    }
}
