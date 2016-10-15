//
//  LoadingViewController.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 21/01/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation
import UIKit

class LoadingViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 8.0, *) {
            view.backgroundColor = UIColor.clear
            
            let blurEffect = UIBlurEffect(style: .dark)
            let blurView = UIVisualEffectView(effect: blurEffect)
            blurView.frame = view.bounds
            view.insertSubview(blurView, at: 0)
        }
    }
}
