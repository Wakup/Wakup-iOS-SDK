//
//  SectionHeaderView.swift
//  Wakup
//
//  Created by Guillermo Gutiérrez Doral on 03/09/2019.
//  Copyright © 2019 Yellow Pineapple. All rights reserved.
//

import UIKit

open class SectionHeaderView: UICollectionReusableView {

    @IBOutlet weak open var titleLabel: UILabel!
    
    open var title: String? {
        didSet { titleLabel.text = self.title }
    }
    
}
