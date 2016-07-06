//
//  CouponDetailHeaderView.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 24/12/14.
//  Copyright (c) 2014 Yellow Pineapple. All rights reserved.
//

import UIKit
import CoreLocation
import TagListView

enum HeaderViewAction {
    case ShowMap
    case ShowLink
    case Share
    case ShowDescription
    case ShowCompany
    case ShowCode
    case ShowTag(tag: String)
}

protocol CouponDetailHeaderViewDelegate {
    func headerViewDidSelectAction(action: HeaderViewAction, headerView: CouponDetailHeaderView)
}

public class CouponDetailHeaderView: UICollectionReusableView {

    // MARK: UIAppearance proxy customization
    public dynamic var companyNameFont: UIFont? { get { return companyNameLabel?.font } set { companyNameLabel?.font = newValue } }
    public dynamic var companyNameTextColor: UIColor? { get { return companyNameLabel?.textColor } set { companyNameLabel?.textColor = newValue } }
    public dynamic var storeAddressFont: UIFont? { get { return storeAddressLabel?.font } set { storeAddressLabel?.font = newValue } }
    public dynamic var storeAddressTextColor: UIColor? { get { return storeAddressLabel?.textColor } set { storeAddressLabel?.textColor = newValue } }
    public dynamic var storeDistanceFont: UIFont? { get { return storeDistanceLabel?.font } set { storeDistanceLabel?.font = newValue } }
    public dynamic var storeDistanceTextColor: UIColor? { get { return storeDistanceLabel?.textColor } set { storeDistanceLabel?.textColor = newValue } }
    public dynamic var storeDistanceIconColor: UIColor? { get { return distanceIconView?.iconColor } set { distanceIconView?.iconColor = newValue } }
    public dynamic var couponNameFont: UIFont? { get { return couponNameLabel?.font } set { couponNameLabel?.font = newValue } }
    public dynamic var couponNameTextColor: UIColor? { get { return couponNameLabel?.textColor } set { couponNameLabel?.textColor = newValue } }
    public dynamic var couponDescriptionFont: UIFont? { get { return couponDescriptionLabel?.font } set { couponDescriptionLabel?.font = newValue } }
    public dynamic var couponDescriptionTextColor: UIColor? { get { return couponDescriptionLabel?.textColor } set { couponDescriptionLabel?.textColor = newValue } }
    public dynamic var expirationFont: UIFont? { get { return storeDistanceLabel?.font } set { storeDistanceLabel?.font = newValue } }
    public dynamic var expirationTextColor: UIColor? { get { return couponExpirationLabel?.textColor } set { couponExpirationLabel?.textColor = newValue } }
    public dynamic var expirationIconColor: UIColor? { get { return expirationIconView?.iconColor } set { expirationIconView?.iconColor = newValue } }
    public dynamic var companyDisclosureColor: UIColor? { get { return companyDisclosureIconView?.iconColor } set { companyDisclosureIconView?.iconColor = newValue } }
    public dynamic var couponDescriptionDisclosureColor: UIColor? { get { return couponDescriptionDisclosureView?.iconColor } set { couponDescriptionDisclosureView?.iconColor = newValue } }
    public dynamic var redemptionCodeDisclosureColor: UIColor? { get { return redemptionCodeDisclosureView?.iconColor } set { redemptionCodeDisclosureView?.iconColor = newValue } }
    public dynamic var redemptionCodeIconColor: UIColor? { get { return barcodeIconView?.iconColor } set { barcodeIconView?.iconColor = newValue } }
    public dynamic var redemptionCodeTitleColor: UIColor? { get { return redemptionCodeTitleLabel?.textColor } set { redemptionCodeTitleLabel?.textColor = newValue } }
    public dynamic var redemptionCodeTitleFont: UIFont? { get { return redemptionCodeTitleLabel?.font } set { redemptionCodeTitleLabel?.font = newValue } }
    public dynamic var redemptionCodeSubtitleColor: UIColor? { get { return redemptionCodeSubtitleLabel?.textColor } set { redemptionCodeSubtitleLabel?.textColor = newValue } }
    public dynamic var redemptionCodeSubtitleFont: UIFont? { get { return redemptionCodeSubtitleLabel?.font } set { redemptionCodeSubtitleLabel?.font = newValue } }
    
    // MARK: IBOutlets
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var storeAddressLabel: UILabel!
    @IBOutlet weak var storeDistanceLabel: UILabel!
    @IBOutlet weak var couponNameLabel: UILabel!
    @IBOutlet weak var couponDescriptionLabel: UILabel!
    @IBOutlet weak var couponDescriptionDisclosureView: CodeIconView!
    @IBOutlet weak var shortTextLabel: UILabel!
    @IBOutlet weak var couponImageView: UIImageView!
    @IBOutlet weak var couponDetailImageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var cellWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var couponExpirationLabel: UILabel!
    @IBOutlet weak var showInMapButton: CodeIconButton!
    @IBOutlet weak var saveButton: CodeIconButton!
    @IBOutlet weak var shareButton: CodeIconButton!
    @IBOutlet weak var companyButton: UIButton!
    @IBOutlet weak var companyDisclosureIconView: CodeIconView!
    @IBOutlet weak var distanceIconView: CodeIconView!
    @IBOutlet weak var expirationIconView: CodeIconView!
    @IBOutlet weak var redemptionCodeConstraint: NSLayoutConstraint!
    @IBOutlet weak var barcodeIconView: CodeIconView!
    @IBOutlet weak var redemptionCodeTitleLabel: UILabel!
    @IBOutlet weak var redemptionCodeSubtitleLabel: UILabel!
    @IBOutlet weak var redemptionCodeDisclosureView: CodeIconView!
    @IBOutlet weak var tagViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var tagListView: TagListView!
    
    var imageAspectRatioConstraint: NSLayoutConstraint?
    var logoAspectRatioConstraint: NSLayoutConstraint?
    @IBOutlet weak var descriptionViewConstraint: NSLayoutConstraint!
    
    // MARK: Properties
    var coupon: Coupon! { didSet { setNeedsLayout(); updateTags() } }
    var userLocation: CLLocation? { didSet { setNeedsLayout() } }
    
    var loadImages = true
    
    var delegate: CouponDetailHeaderViewDelegate?
    
    var preferredWidth: CGFloat = 0.0 { didSet { cellWidthConstraint?.constant = preferredWidth } }
    
    let persistenceService = PersistenceService.sharedInstance
    
    var hasLocation: Bool { return coupon?.store?.location() != nil }
    var hasLink: Bool { return coupon?.online ?? false && coupon?.link != nil }
    
    public dynamic var tagPrefix = "#"
    
    // MARK: UIView
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        saveButton.setTitle("CouponHeaderSave".i18n(), forState: .Normal)
        saveButton.setTitle("CouponHeaderSaved".i18n(), forState: .Selected)
        shareButton.setTitle("CouponHeaderShare".i18n(), forState: .Normal)

        cellWidthConstraint!.constant = preferredWidth
        self.setNeedsLayout()
    }
    
    override public func layoutSubviews() {
        refreshUI()
        super.layoutSubviews()
    }
    
    func updateTags() {
        tagListView.removeAllTags()
        for tag in coupon.tags {
            let tagView = tagListView.addTag(tagPrefix + tag)
            tagView.onTap = { [unowned self] _ in
                self.delegate?.headerViewDidSelectAction(.ShowTag(tag: tag), headerView: self)
            }
        }
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
            
            if hasLink {
                showInMapButton?.iconIdentifier = "link"
                showInMapButton?.setTitle("CouponHeaderLink".i18n(), forState: .Normal)
            }
            else {
                showInMapButton?.iconIdentifier = "location"
                showInMapButton?.setTitle("CouponHeaderShowMap".i18n(), forState: .Normal)
                showInMapButton?.enabled = hasLocation
            }
            refreshSavedStatus()
            
            if let code = coupon.redemptionCode {
                redemptionCodeDisclosureView.hidden = !code.alreadyAssigned && code.limited && code.availableCodes == 0
                switch (code.limited, code.alreadyAssigned, code.availableCodes) {
                case (true, true, _):
                    redemptionCodeTitleLabel.text = "CouponHeaderRedemptionCodeShow".i18n()
                    redemptionCodeSubtitleLabel.text = "CouponHeaderRedemptionCodeAssigned".i18n()
                    break
                case (true, false, .Some(let available)) where available == 0:
                    redemptionCodeTitleLabel.text = "CouponHeaderRedemptionCodeOutOfStock".i18n()
                    redemptionCodeSubtitleLabel.text = ""
                    break
                case (true, false, .Some(let available)) where available <= 1: // TODO: Maybe use a more configurable value
                    redemptionCodeTitleLabel.text = "CouponHeaderRedemptionCodeGet".i18n()
                    redemptionCodeSubtitleLabel.text = "CouponHeaderRedemptionCodeLast".i18n()
                    break
                case (true, false, .Some(let available)) where available > 1:
                    redemptionCodeTitleLabel.text = "CouponHeaderRedemptionCodeGet".i18n()
                    redemptionCodeSubtitleLabel.text = String(format: "CouponHeaderRedemptionCodeXLeft".i18n(), available)
                    break
                default:
                    redemptionCodeTitleLabel.text = "CouponHeaderRedemptionCodeShow".i18n()
                    redemptionCodeSubtitleLabel.text = ""
                }
            }
            
            setNeedsUpdateConstraints()
        }
    }
    
    func refreshSavedStatus() {
        saveButton.selected = persistenceService.isSaved(coupon.id)
    }
    
    public override func updateConstraints() {
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
        
        // Hide Redemption code view if needed
        redemptionCodeConstraint.constant = coupon?.redemptionCode != nil ? 150 : 0
        
        // Hide tag view if no tags found
        tagViewConstraint.constant = coupon?.tags.isEmpty ?? true ? 0 : 150
        
        super.updateConstraints()
    }

    func aspectRatioConstraint(forView view: UIView, ratio: Float) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Height, multiplier: CGFloat(ratio), constant: CGFloat(0))
        return constraint
    }
    
    // MARK: IBActions
    @IBAction func showMapButtonTapped(sender: AnyObject) {
        delegate?.headerViewDidSelectAction(hasLink ? .ShowLink : .ShowMap, headerView: self)
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
    @IBAction func codeButtonTapped(sender: AnyObject) {
        // Ignore requests if limited codes are out of stock
        guard let code = coupon?.redemptionCode where code.alreadyAssigned || !code.limited || code.availableCodes > 0 else { return }
        delegate?.headerViewDidSelectAction(.ShowCode, headerView: self)
    }
    
}
