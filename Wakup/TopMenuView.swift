//
//  TopMenuView.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 10/02/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import UIKit

protocol TopMenuViewDelegate {
    func topMenuViewDidSelectOfferButton(view: TopMenuView)
    func topMenuViewDidSelectMapButton(view: TopMenuView)
    func topMenuViewDidSelectMyOffersButton(view: TopMenuView)
}

class TopMenuView: UIView {
    
    var delegate: TopMenuViewDelegate?

    @IBAction func offerButtonClicked(sender: AnyObject) {
        delegate?.topMenuViewDidSelectOfferButton(self)
    }
    
    @IBAction func mapButtonClicked(sender: AnyObject) {
        delegate?.topMenuViewDidSelectMapButton(self)
    }

    @IBAction func myOffersButtonClicked(sender: AnyObject) {
        delegate?.topMenuViewDidSelectMyOffersButton(self)
    }
}
