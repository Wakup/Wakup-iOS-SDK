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
    func setImageAnimated(url url: NSURL!, completed: SDWebImageCompletionBlock? = nil) {
        sd_setImageWithURL(url, completed: onLoadComplete(completed))
    }
    
    func setImageAnimated(url url: NSURL!, placeholder: UIImage!, completed: SDWebImageCompletionBlock? = nil) {
        sd_setImageWithURL(url, placeholderImage: placeholder, completed: onLoadComplete(completed))
    }
    
    private func onLoadComplete(completed: SDWebImageCompletionBlock?)(image: UIImage?, error: NSError?, cacheType: SDImageCacheType, url: NSURL!) {
        if (cacheType ==  .None) {
            let animation = CATransition()
            animation.duration = 0.3
            animation.type = kCATransitionFade
            
            self.layer.addAnimation(animation, forKey: "image-load")
        }
        if let completeBlock = completed {
            completeBlock(image, error, cacheType, url)
        }
    }
}