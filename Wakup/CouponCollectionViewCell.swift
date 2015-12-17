//
//  CouponCollectionViewCell.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 10/12/14.
//  Copyright (c) 2014 Yellow Pineapple. All rights reserved.
//

import UIKit
import CoreLocation
import iOSContextualMenu

enum CouponContextAction: String {
    case ShowMap = "show-map"
    case Share = "share"
    case Save = "save"
    case Remove = "remove"
}

typealias OnContextMenuAction = (action: CouponContextAction, forCoupon: Coupon) -> Void

class CouponCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var couponImageView: UIImageView!
    @IBOutlet weak var shortTextLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var offerDescriptionLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var expirationLabel: UILabel!
    
    private var imageAspectRatioConstraint: NSLayoutConstraint?
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var preferredWidth: CGFloat? { didSet { setNeedsUpdateConstraints() } }
    
    var coupon: Coupon? { didSet { refreshUI() } }
    var userLocation: CLLocation? { didSet { refreshDistance() } }
    var onContextMenuAction: OnContextMenuAction?
    
    var loadImages = true
    
    private var menuDelegate = ContextMenuSource()
    private var contextualMenu: BAMContextualMenu?
    
    func refreshUI() {
        if (loadImages) {
            if let image = coupon?.thumbnail {
                couponImageView.backgroundColor = image.color
                couponImageView.setImageAnimated(url: image.sourceUrl)
            }
        }
        shortTextLabel.text = coupon?.shortText
        offerDescriptionLabel.text = coupon?.shortDescription
        storeNameLabel.text = coupon?.company.name
        expirationLabel.text = coupon?.expirationDate?.humanFriendlyDate() ?? "ExpiresUndefined".i18n()
        
        refreshDistance()
        setupContextualMenu()
        
        self.setNeedsUpdateConstraints()
    }
    
    func setupContextualMenu() {
        var menuItems = [ContextMenuItem]()
        let location: CLLocation? = coupon?.store?.location()
        if location != .None {
            menuItems.append(ContextMenuItem.withCustomView(CouponContextAction.ShowMap.rawValue, titleText: "ActionShowMap".i18n()))
        }
        
        if isSaved() {
            menuItems.append(ContextMenuItem.withCustomView(CouponContextAction.Remove.rawValue, titleText: "ActionRemove".i18n()))
        }
        else {
            menuItems.append(ContextMenuItem.withCustomView(CouponContextAction.Save.rawValue, titleText: "ActionSave".i18n()))
        }
        menuItems.append(ContextMenuItem.withCustomView(CouponContextAction.Share.rawValue, titleText: "ActionShare".i18n()))
        
        menuDelegate.menuItems = menuItems
        contextualMenu?.reloadDataAndRelayoutSubviews()
    }
    
    func isSaved() -> Bool {
        if let coupon = self.coupon {
            return PersistenceService.sharedInstance.isSaved(coupon.id)
        }
        return false
    }
    
    override func awakeFromNib() {
        contextualMenu = BAMContextualMenu.addContextualMenuToView(contentView, delegate: menuDelegate, dataSource: menuDelegate, activateOption: kBAMContextualMenuActivateOptionLongPress)
        menuDelegate.onSelection = { menuItem, index in
            if let actionId = menuItem?.identifier ?? .None {
                let action = CouponContextAction(rawValue: actionId)
                if let action = action {
                    if let coupon = self.coupon {
                        NSLog("Selected action %@ for coupon %d", action.rawValue, coupon.id)
                        self.onContextMenuAction?(action: action, forCoupon: coupon)
                        self.refreshUI()
                    }
                }
            }
        }
    }
    
    func refreshDistance() {
        distanceLabel.text = coupon?.distanceText <*> userLocation
    }
    
    override func updateConstraints() {
        if let constraint = imageAspectRatioConstraint {
            couponImageView?.removeConstraint(constraint)
            imageAspectRatioConstraint = nil
        }
        
        if let image = coupon?.image {
            let aspectRatio = image.width / image.height
            imageAspectRatioConstraint = aspectRatioConstraint(forView: couponImageView!, ratio: aspectRatio)
            couponImageView.addConstraint(imageAspectRatioConstraint!)
        }
        
        if let width = preferredWidth {
            widthConstraint.constant = width
        }
        
        super.updateConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        couponImageView?.backgroundColor = UIColor.clearColor()
        couponImageView?.image = nil
    }
    
    func aspectRatioConstraint(forView view: UIView, ratio: Float) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Height, multiplier: CGFloat(ratio), constant: CGFloat(0))
        return constraint
    }
    
}
