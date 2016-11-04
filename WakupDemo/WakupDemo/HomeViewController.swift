//
//  HomeViewController.swift
//  WakupDemo
//
//  Created by Guillermo Gutiérrez Doral on 26/10/16.
//  Copyright © 2016 Yellow Pineapple. All rights reserved.
//

import Foundation
import UIKit
import Wakup

class HomeViewController: UIViewController {
    
    @IBOutlet weak var offersWidgetView: OffersWidgetView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        offersWidgetView.fetchLocationIfAvailable()
        offersWidgetView.configure(withParentController: self)
    }
    
    @IBAction func viewAllOffersAction(_ sender: AnyObject) {
        let wakupVC = WakupManager.manager.rootNavigationController()!
        self.present(wakupVC, animated: true, completion: nil)
    }
}
