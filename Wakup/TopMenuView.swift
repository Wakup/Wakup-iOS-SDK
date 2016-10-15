//
//  TopMenuView.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 10/02/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import UIKit

protocol TopMenuViewDelegate {
    func topMenuViewDidSelectOfferButton(_ view: TopMenuView)
    func topMenuViewDidSelectMapButton(_ view: TopMenuView)
    func topMenuViewDidSelectMyOffersButton(_ view: TopMenuView)
}

open class TopMenuView: UIView {
    
    var delegate: TopMenuViewDelegate?

    @IBAction func offerButtonClicked(_ sender: AnyObject) {
        delegate?.topMenuViewDidSelectOfferButton(self)
    }
    
    @IBAction func mapButtonClicked(_ sender: AnyObject) {
        delegate?.topMenuViewDidSelectMapButton(self)
    }

    @IBAction func myOffersButtonClicked(_ sender: AnyObject) {
        delegate?.topMenuViewDidSelectMyOffersButton(self)
    }
}
