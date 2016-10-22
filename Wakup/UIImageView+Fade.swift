//
//  UIImageView+Fade.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 08/01/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation
import SDWebImage

extension UIImageView {
    func setImageAnimated(url: URL!, completed: SDWebImageCompletionBlock? = nil) {
        sd_setImage(with: url) { (image, error, cacheType, url) in
            if (cacheType ==  .none) {
                let animation = CATransition()
                animation.duration = 0.3
                animation.type = kCATransitionFade
                
                self.layer.add(animation, forKey: "image-load")
            }
            if let completeBlock = completed {
                completeBlock(image, error, cacheType, url)
            }
        }
    }
}
