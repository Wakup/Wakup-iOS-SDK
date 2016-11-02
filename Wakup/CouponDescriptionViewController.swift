//
//  CouponDescriptionViewController.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 25/02/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import UIKit

class CouponDescriptionViewController: UIViewController {

    @IBOutlet weak var descriptionLabel: UITextView!
    var descriptionText: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        descriptionLabel?.text = descriptionText
        
        view.backgroundColor = UIColor.clear
        for view in view.subviews {
            view.alpha = 0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let subviews = view.subviews
        
        let blurView = UIVisualEffectView()
        blurView.frame = view.bounds
        view.insertSubview(blurView, at: 0)
        
        UIView.animate(withDuration: 0.3) {
            for view in subviews {
                view.alpha = 1
                blurView.effect = UIBlurEffect(style: .dark)
            }
        }
        
    }

    @IBAction func actionButtonTapped(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}
