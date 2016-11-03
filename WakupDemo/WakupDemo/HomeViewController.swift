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
        offersWidgetView.onOfferSelected = { [unowned self] offer in
            print("Selected offer \(offer)")
            let offers = self.offersWidgetView.offers
            let location = self.offersWidgetView.location
            let detailsVC = WakupManager.manager.offerDetailsController(forOffer: offer, userLocation: location, offers: offers)!
            detailsVC.automaticallyAdjustsScrollViewInsets = false
            
            let navicationController = WakupManager.manager.rootNavigationController()!
            navicationController.viewControllers = [detailsVC]
            
            self.present(navicationController, animated: true, completion: nil)
        }
    }
    
    @IBAction func viewAllOffersAction(_ sender: AnyObject) {
        let wakupVC = WakupManager.manager.rootNavigationController()!
        self.present(wakupVC, animated: true, completion: nil)
    }
}
