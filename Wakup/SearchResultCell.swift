//
//  SearchResultCell.swift
//  Wakup
//
//  Created by Guillermo Gutiérrez on 8/1/16.
//  Copyright © 2016 Yellow Pineapple. All rights reserved.
//

import Foundation

public class SearchResultCell: UITableViewCell {
    public dynamic var titleTextColor: UIColor?  { didSet { textLabel?.textColor = titleTextColor } }
    public dynamic var titleFont: UIFont? { didSet { textLabel?.font = titleFont } }
    public dynamic var detailTextColor: UIColor? { didSet { detailTextLabel?.textColor = detailTextColor } }
    public dynamic var detailFont: UIFont? { didSet { detailTextLabel?.font = detailFont } }
    
    public dynamic var iconColor: UIColor? { didSet { updateIcon() } }
    
    var iconIdentifier: String? { didSet { updateIcon() } }
    
    func updateIcon() {
        let iconFrame = CGRectMake(0, 0, 20, 20)
        imageView?.image = iconIdentifier.map { CodeIcon(iconIdentifier: $0).getImage(iconFrame, color: self.iconColor) }
    }
}