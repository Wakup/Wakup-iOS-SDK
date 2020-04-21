//
//  UIViewController+CouponUtils.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 20/02/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation
import SDWebImage

public extension UIViewController {
    func showMap(forOffer offer: Coupon) {
        let mapVC = WakupManager.manager.mapController(for: offer)
        self.navigationController?.pushViewController(mapVC, animated: true)
    }

    @objc func shareTextImageAndURL(sharingText: String?, sharingImage: UIImage?, sharingURL: URL?) {
        var sharingItems = [AnyObject]()
        
        if let text = sharingText {
            sharingItems.append(text as AnyObject)
        }
        if let image = sharingImage {
            sharingItems.append(image)
        }
        if let url = sharingURL {
            sharingItems.append(url as AnyObject)
        }
        
        let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.print, UIActivity.ActivityType.assignToContact]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func shareTextImageAndURL(text: String?, imageURL: URL?, linkURL: URL?, loadingProtocol: LoadingViewProtocol) {
        if let imageUrl = imageURL {
            loadingProtocol.showLoadingView(animated: true)
            SDWebImageManager.shared.imageLoader.requestImage(with: imageUrl, options: .highPriority, context: nil, progress: nil, completed: { (image, data, error, finished) in
                loadingProtocol.dismissLoadingView(animated: true, completion: {
                    self.shareTextImageAndURL(sharingText: text, sharingImage: image, sharingURL: linkURL)
                })
            })
        }
        else {
            self.shareTextImageAndURL(sharingText: text, sharingImage: nil, sharingURL: linkURL)
        }
    }
}
