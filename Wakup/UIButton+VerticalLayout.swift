//
//  UIButton+VerticalLayout.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 23/02/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation

extension UIButton {
    func centerVerticallyWithPadding(_ padding: CGFloat) {
        let imageSize = self.imageView?.frame.size ?? CGSize.zero
        let titleSize = self.titleLabel?.frame.size ?? CGSize.zero
        
        let totalHeight = imageSize.height + titleSize.height + padding
        imageEdgeInsets = UIEdgeInsets(top: imageSize.height - totalHeight, left: 0, bottom: 0, right: -titleSize.width)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width, bottom: titleSize.height - totalHeight, right: 0)
    }
    
    func centerVertically() {
        let defaultPadding: CGFloat = 6
        centerVerticallyWithPadding(defaultPadding)
    }
}
