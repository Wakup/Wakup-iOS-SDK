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

typealias OnContextMenuAction = (_ action: CouponContextAction, _ forCoupon: Coupon) -> Void

open class CouponCollectionViewCell: UICollectionViewCell {

    open dynamic var storeNameFont: UIFont! { get { return storeNameLabel?.font } set { storeNameLabel?.font = newValue } }
    open dynamic var storeNameTextColor: UIColor! { get { return storeNameLabel?.textColor } set { storeNameLabel?.textColor = newValue } }
    open dynamic var descriptionTextFont: UIFont! { get { return offerDescriptionLabel?.font } set { offerDescriptionLabel?.font = newValue } }
    open dynamic var descriptionTextColor: UIColor! { get { return offerDescriptionLabel?.textColor } set { offerDescriptionLabel?.textColor = newValue } }
    open dynamic var distanceFont: UIFont! { get { return distanceLabel?.font } set { distanceLabel?.font = newValue } }
    open dynamic var distanceTextColor: UIColor! { get { return distanceLabel?.textColor } set { distanceLabel?.textColor = newValue } }
    open dynamic var distanceIconColor: UIColor! { get { return distanceIconView?.iconColor } set { distanceIconView?.iconColor = newValue } }
    open dynamic var expirationFont: UIFont! { get { return expirationLabel?.font } set { expirationLabel?.font = newValue } }
    open dynamic var expirationTextColor: UIColor! { get { return expirationLabel?.textColor } set { expirationLabel?.textColor = newValue } }
    open dynamic var expirationIconColor: UIColor! { get { return expirationIconView?.iconColor } set { expirationIconView?.iconColor = newValue } }
    
    @IBOutlet weak var couponImageView: UIImageView!
    @IBOutlet weak var shortTextLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var offerDescriptionLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var expirationLabel: UILabel!
    @IBOutlet weak var distanceIconView: CodeIconView!
    @IBOutlet weak var expirationIconView: CodeIconView!
    
    fileprivate var imageAspectRatioConstraint: NSLayoutConstraint?
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var preferredWidth: CGFloat? { didSet { setNeedsUpdateConstraints() } }
    
    var coupon: Coupon? { didSet { refreshUI() } }
    var userLocation: CLLocation? { didSet { refreshDistance() } }
    var onContextMenuAction: OnContextMenuAction?
    
    var loadImages = true
    
    fileprivate var menuDelegate = ContextMenuSource()
    fileprivate var contextualMenu: BAMContextualMenu?
    
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
        if location != .none {
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
    
    override open func awakeFromNib() {
        contextualMenu = BAMContextualMenu.add(to: contentView, delegate: menuDelegate, dataSource: menuDelegate, activateOption: kBAMContextualMenuActivateOptionLongPress)
        menuDelegate.onSelection = { menuItem, index in
            if let actionId = menuItem?.identifier ?? .none {
                let action = CouponContextAction(rawValue: actionId)
                if let action = action {
                    if let coupon = self.coupon {
                        NSLog("Selected action %@ for coupon %d", action.rawValue, coupon.id)
                        self.onContextMenuAction?(action, coupon)
                        self.refreshUI()
                    }
                }
            }
        }
    }
    
    func refreshDistance() {
        distanceLabel.text = userLocation.flatMap { coupon?.distanceText($0) }
    }
    
    override open func updateConstraints() {
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
    
    override open func prepareForReuse() {
        super.prepareForReuse()
        couponImageView?.backgroundColor = UIColor.clear
        couponImageView?.image = nil
    }
    
    func aspectRatioConstraint(forView view: UIView, ratio: Float) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.height, multiplier: CGFloat(ratio), constant: CGFloat(0))
        return constraint
    }
    
}
