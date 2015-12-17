//
//  CouponDetailHeaderView.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 24/12/14.
//  Copyright (c) 2014 Yellow Pineapple. All rights reserved.
//

import UIKit
import CoreLocation

enum HeaderViewAction {
    case ShowMap
    case Share
    case ShowDescription
    case ShowCompany
}

protocol CouponDetailHeaderViewDelegate {
    func headerViewDidSelectAction(action: HeaderViewAction, headerView: CouponDetailHeaderView)
}

class CouponDetailHeaderView: UICollectionReusableView {

    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var storeAddressLabel: UILabel!
    @IBOutlet weak var storeDistanceLabel: UILabel!
    @IBOutlet weak var couponNameLabel: UILabel!
    @IBOutlet weak var couponDescriptionLabel: UILabel!
    @IBOutlet weak var shortTextLabel: UILabel!
    @IBOutlet weak var couponImageView: UIImageView!
    @IBOutlet weak var couponDetailImageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var cellWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var couponExpirationLabel: UILabel!
    @IBOutlet weak var showInMapButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var companyButton: UIButton!
    @IBOutlet weak var companyDisclosureIconView: CodeIconView!
    
    var imageAspectRatioConstraint: NSLayoutConstraint?
    var logoAspectRatioConstraint: NSLayoutConstraint?
    @IBOutlet weak var descriptionViewConstraint: NSLayoutConstraint!
    
    var coupon: Coupon! { didSet { setNeedsLayout() } }
    var userLocation: CLLocation? { didSet { setNeedsLayout() } }
    
    var loadImages = true
    
    var delegate: CouponDetailHeaderViewDelegate?
    
    var preferredWidth: CGFloat = 0.0 { didSet { cellWidthConstraint?.constant = preferredWidth } }
    
    let persistenceService = PersistenceService.sharedInstance
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellWidthConstraint!.constant = preferredWidth
        self.setNeedsLayout()
    }
    
    override func layoutSubviews() {
        refreshUI()
        super.layoutSubviews()
    }
    
    func refreshUI() {
        if let coupon = self.coupon {
            if (loadImages) {
                if let thumbnail = coupon.thumbnail {
                    couponImageView.backgroundColor = thumbnail.color
                    couponImageView.setImageAnimated(url: thumbnail.sourceUrl)
                }
                
                self.couponDetailImageView?.hidden = true
                if let image = coupon.image {
                    couponDetailImageView?.setImageAnimated(url: image.sourceUrl) { (_, error, _, _) -> Void in
                        if (error == .None) {
                            self.couponDetailImageView?.hidden = false
                        }
                    }
                }
                
                if let logo = coupon.company.logo {
                    logoImageView.backgroundColor = logo.color
                    logoImageView.setImageAnimated(url: logo.sourceUrl) { _ -> Void in
                        // Restore background color just in case the logo is transparent
                        self.logoImageView.backgroundColor = UIColor.whiteColor()
                    }
                }
            }

            couponDescriptionLabel?.text = coupon.description
            descriptionViewConstraint?.constant = coupon.description.characters.count > 0 ? 1000 : 0
            couponNameLabel?.text = coupon.shortDescription
            shortTextLabel?.text = coupon.shortText
            couponExpirationLabel?.text = coupon.expirationDate?.humanFriendlyDate() ?? "ExpiresUndefined".i18n()
            companyNameLabel?.text = coupon.company.name
            storeAddressLabel?.text = coupon.store?.address
            
            storeDistanceLabel?.text = coupon.distanceText <*> userLocation

            let hasLocation = (coupon.store?.location() ?? .None) != .None
            showInMapButton?.enabled = hasLocation
            refreshSavedStatus()
            
            setNeedsUpdateConstraints()
        }
    }
    
    func refreshSavedStatus() {
        saveButton.selected = persistenceService.isSaved(coupon.id)
    }
    
    override func updateConstraints() {
        // Remove previous constraints
        if let constraint = imageAspectRatioConstraint {
            couponImageView?.removeConstraint(constraint)
            imageAspectRatioConstraint = nil
        }
        if let constraint = logoAspectRatioConstraint {
            logoImageView?.removeConstraint(constraint)
            logoAspectRatioConstraint = nil
        }

        // Add constraint for coupon aspect ratio
        if let image = coupon?.image {
            let aspectRatio = image.width / image.height
            imageAspectRatioConstraint = aspectRatioConstraint(forView: couponImageView!, ratio: aspectRatio)
            couponImageView.addConstraint(imageAspectRatioConstraint!)
        }
        
        // Add constraint for logo aspect ratio
        if let image = coupon?.company.logo {
            let aspectRatio = image.width / image.height
            logoAspectRatioConstraint = aspectRatioConstraint(forView: logoImageView!, ratio: aspectRatio)
            logoImageView.addConstraint(logoAspectRatioConstraint!)
        }
        super.updateConstraints()
    }

    func aspectRatioConstraint(forView view: UIView, ratio: Float) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Height, multiplier: CGFloat(ratio), constant: CGFloat(0))
        return constraint
    }
    
    // MARK: IBActions
    @IBAction func showMapButtonTapped(sender: AnyObject) {
        delegate?.headerViewDidSelectAction(.ShowMap, headerView: self)
    }
    @IBAction func saveButtonTapped(sender: AnyObject) {
        persistenceService.toggle(coupon.id)
        refreshUI()
    }
    @IBAction func shareButtonTapped(sender: AnyObject) {
        delegate?.headerViewDidSelectAction(.Share, headerView: self)
    }
    @IBAction func descriptionButtonTapped(sender: AnyObject) {
        delegate?.headerViewDidSelectAction(.ShowDescription, headerView: self)
    }
    @IBAction func companyButtonTapped(sender: AnyObject) {
        delegate?.headerViewDidSelectAction(.ShowCompany, headerView: self)
    }
}
