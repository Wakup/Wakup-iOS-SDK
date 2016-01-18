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
        let mapVC = self.storyboard?.instantiateViewControllerWithIdentifier("couponMap") as! CouponMapViewController
        mapVC.coupons = [offer]
        mapVC.selectedCoupon = offer
        
        self.navigationController?.pushViewController(mapVC, animated: true)
    }

    func shareTextImageAndURL(sharingText sharingText: String?, sharingImage: UIImage?, sharingURL: NSURL?) {
        var sharingItems = [AnyObject]()
        
        if let text = sharingText {
            sharingItems.append(text)
        }
        if let image = sharingImage {
            sharingItems.append(image)
        }
        if let url = sharingURL {
            sharingItems.append(url)
        }
        
        let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityTypeAddToReadingList, UIActivityTypePrint, UIActivityTypeAssignToContact]
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
}

private func shareCouponInPresenter(coupon: Coupon, presenter: UIViewController, loadViewPresenter: LoadingViewProtocol) {
    let url: NSURL! = nil
    let text = coupon.shortDescription ?? coupon.description ?? ""
    let shareText = coupon.company.name + " - " + text + "\n" + "ShareOfferFooter".i18n()
    if let imageUrl = coupon.image?.sourceUrl {
        loadViewPresenter.showLoadingView(animated: true)
        SDWebImageManager.sharedManager().downloadImageWithURL(imageUrl, options: .HighPriority, progress: nil, completed: { (image, error, cacheType, finished, imageUrl) -> Void in
            
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
    func shareCoupon(coupon: Coupon) {
        let presenter = self.navigationController ?? self
        shareCouponInPresenter(coupon, presenter: presenter, loadViewPresenter: self)
    }
}