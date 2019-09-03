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
    
    @objc open dynamic var title: String? { get { return titleLabel?.text } set { titleLabel?.text = newValue } }
    @objc open dynamic var titleFont: UIFont? { get { return titleLabel?.font } set { titleLabel?.font = newValue } }
    @objc open dynamic var titleColor: UIColor? { get { return titleLabel?.textColor } set { titleLabel?.textColor = newValue } }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        if title?.count ?? 0 == 0 {
            title = "RelatedOffers".i18n()
        }
    }
}
