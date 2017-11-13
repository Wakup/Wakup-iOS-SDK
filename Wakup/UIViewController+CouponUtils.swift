//
//  UIViewController+CouponUtils.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 20/02/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation
import SDWebImage

extension UIViewController {
    func showMap(forOffer offer: Coupon) {
        let mapVC = WakupManager.manager.mapController(for: offer)
        self.navigationController?.pushViewController(mapVC, animated: true)
    }

    func shareTextImageAndURL(sharingText: String?, sharingImage: UIImage?, sharingURL: URL?) {
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
        activityViewController.excludedActivityTypes = [UIActivityType.addToReadingList, UIActivityType.print, UIActivityType.assignToContact]
        self.present(activityViewController, animated: true, completion: nil)
    }
}

private func shareCouponInPresenter(_ coupon: Coupon, presenter: UIViewController, loadViewPresenter: LoadingViewProtocol) {
    let url: URL! = nil
    let text = coupon.shortDescription
    let shareText = coupon.company.name + " - " + text + "\n" + "ShareOfferFooter".i18n()
    if let imageUrl = coupon.image?.sourceUrl {
        loadViewPresenter.showLoadingView(animated: true)
        SDWebImageManager.shared().imageDownloader?.downloadImage(with: imageUrl as URL!, options: .highPriority, progress: nil, completed: { (image, error, cacheType, imageUrl) -> Void in
            
            loadViewPresenter.dismissLoadingView(animated: true, completion: {
                presenter.shareTextImageAndURL(sharingText: shareText, sharingImage: image, sharingURL: url)
            })
        })
    }
    else {
        presenter.shareTextImageAndURL(sharingText: shareText, sharingImage: nil, sharingURL: url)
    }
}

extension LoadingPresenterViewController {
    func shareCoupon(_ coupon: Coupon) {
        let presenter = self.navigationController ?? self
        shareCouponInPresenter(coupon, presenter: presenter, loadViewPresenter: self)
    }
}
