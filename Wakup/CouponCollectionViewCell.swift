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

public enum CouponContextAction: String {
    case ShowMap = "show-map"
    case Share = "share"
    case Save = "save"
    case Remove = "remove"
}

public typealias OnContextMenuAction = (_ action: CouponContextAction, _ forCoupon: Coupon) -> Void

open class CouponCollectionViewCell: UICollectionViewCell {

    @objc open dynamic var storeNameFont: UIFont! { get { return storeNameLabel?.font } set { storeNameLabel?.font = newValue } }
    @objc open dynamic var storeNameTextColor: UIColor! { get { return storeNameLabel?.textColor } set { storeNameLabel?.textColor = newValue } }
    @objc open dynamic var descriptionTextFont: UIFont! { get { return offerDescriptionLabel?.font } set { offerDescriptionLabel?.font = newValue } }
    @objc open dynamic var descriptionTextColor: UIColor! { get { return offerDescriptionLabel?.textColor } set { offerDescriptionLabel?.textColor = newValue } }
    @objc open dynamic var fullDescriptionTextFont: UIFont! { get { return fullDescriptionLabel?.font } set { fullDescriptionLabel?.font = newValue } }
    @objc open dynamic var fullDescriptionTextColor: UIColor! { get { return fullDescriptionLabel?.textColor } set { fullDescriptionLabel?.textColor = newValue } }
    @objc open dynamic var distanceFont: UIFont! { get { return distanceLabel?.font } set { distanceLabel?.font = newValue } }
    @objc open dynamic var distanceTextColor: UIColor! { get { return distanceLabel?.textColor } set { distanceLabel?.textColor = newValue } }
    @objc open dynamic var distanceIconColor: UIColor! { get { return distanceIconView?.iconColor } set { distanceIconView?.iconColor = newValue } }
    @objc open dynamic var expirationFont: UIFont! { get { return expirationLabel?.font } set { expirationLabel?.font = newValue } }
    @objc open dynamic var expirationTextColor: UIColor! { get { return expirationLabel?.textColor } set { expirationLabel?.textColor = newValue } }
    @objc open dynamic var expirationIconColor: UIColor! { get { return expirationIconView?.iconColor } set { expirationIconView?.iconColor = newValue } }
    
    @IBOutlet open weak var couponImageView: UIImageView!
    @IBOutlet open weak var shortTextLabel: UILabel!
    @IBOutlet open weak var storeNameLabel: UILabel!
    @IBOutlet open weak var offerDescriptionLabel: UILabel!
    @IBOutlet open weak var fullDescriptionLabel: UILabel!
    @IBOutlet open weak var distanceLabel: UILabel!
    @IBOutlet open weak var expirationLabel: UILabel!
    @IBOutlet open weak var distanceIconView: CodeIconView!
    @IBOutlet open weak var expirationIconView: CodeIconView!
    
    fileprivate var imageAspectRatioConstraint: NSLayoutConstraint?
    @IBOutlet open weak var widthConstraint: NSLayoutConstraint!
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open var preferredWidth: CGFloat? { didSet { setNeedsUpdateConstraints() } }
    
    open var coupon: Coupon? { didSet { refreshUI() } }
    open var userLocation: CLLocation? { didSet { refreshDistance() } }
    open var onContextMenuAction: OnContextMenuAction? { didSet { refreshMenuActivation() } }
    
    open var loadImages = true
    
    fileprivate var menuDelegate = ContextMenuSource()
    fileprivate var contextualMenu: BAMContextualMenu?
    
    func refreshUI() {
        if (loadImages) {
            if let image = coupon?.thumbnail {
                couponImageView?.backgroundColor = image.color
                couponImageView?.setImageAnimated(url: image.sourceUrl)
            }
        }
        shortTextLabel?.text = coupon?.shortText
        offerDescriptionLabel?.text = coupon?.shortDescription
        fullDescriptionLabel?.text = coupon?.description
        storeNameLabel?.text = coupon?.company.name
        expirationLabel?.text = coupon?.expirationDate?.humanFriendlyDate() ?? "ExpiresUndefined".i18n()
        
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
        refreshMenuActivation()
    }
        
    func refreshMenuActivation() {
        contextualMenu?.shouldActivateMenu = onContextMenuAction != nil
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
        setupContextualMenu()
    }
    
    func refreshDistance() {
        guard let userLocation = userLocation else { return }
        distanceLabel?.text = coupon?.distanceText(userLocation)
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
        let constraint = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.height, multiplier: CGFloat(ratio), constant: CGFloat(0))
        return constraint
    }
    
}
