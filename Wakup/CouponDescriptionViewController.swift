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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 8.0, *) {
            view.backgroundColor = UIColor.clearColor()
            
            let blurEffect = UIBlurEffect(style: .Dark)
            let blurView = UIVisualEffectView(effect: blurEffect)
            blurView.frame = view.bounds
            view.insertSubview(blurView, atIndex: 0)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        descriptionLabel?.text = descriptionText
    }

    @IBAction func actionButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
