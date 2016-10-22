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
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


enum HeaderViewAction {
    case showMap
    case showLink
    case share
    case showDescription
    case showCompany
    case showCode
    case showTag(tag: String)
}

protocol CouponDetailHeaderViewDelegate {
    func headerViewDidSelectAction(_ action: HeaderViewAction, headerView: CouponDetailHeaderView)
}

open class CouponDetailHeaderView: UICollectionReusableView {

    // MARK: UIAppearance proxy customization
    open dynamic var companyNameFont: UIFont? { get { return companyNameLabel?.font } set { companyNameLabel?.font = newValue } }
    open dynamic var companyNameTextColor: UIColor? { get { return companyNameLabel?.textColor } set { companyNameLabel?.textColor = newValue } }
    open dynamic var storeAddressFont: UIFont? { get { return storeAddressLabel?.font } set { storeAddressLabel?.font = newValue } }
    open dynamic var storeAddressTextColor: UIColor? { get { return storeAddressLabel?.textColor } set { storeAddressLabel?.textColor = newValue } }
    open dynamic var storeDistanceFont: UIFont? { get { return storeDistanceLabel?.font } set { storeDistanceLabel?.font = newValue } }
    open dynamic var storeDistanceTextColor: UIColor? { get { return storeDistanceLabel?.textColor } set { storeDistanceLabel?.textColor = newValue } }
    open dynamic var storeDistanceIconColor: UIColor? { get { return distanceIconView?.iconColor } set { distanceIconView?.iconColor = newValue } }
    open dynamic var couponNameFont: UIFont? { get { return couponNameLabel?.font } set { couponNameLabel?.font = newValue } }
    open dynamic var couponNameTextColor: UIColor? { get { return couponNameLabel?.textColor } set { couponNameLabel?.textColor = newValue } }
    open dynamic var couponDescriptionFont: UIFont? { get { return couponDescriptionLabel?.font } set { couponDescriptionLabel?.font = newValue } }
    open dynamic var couponDescriptionTextColor: UIColor? { get { return couponDescriptionLabel?.textColor } set { couponDescriptionLabel?.textColor = newValue } }
    open dynamic var expirationFont: UIFont? { get { return storeDistanceLabel?.font } set { storeDistanceLabel?.font = newValue } }
    open dynamic var expirationTextColor: UIColor? { get { return couponExpirationLabel?.textColor } set { couponExpirationLabel?.textColor = newValue } }
    open dynamic var expirationIconColor: UIColor? { get { return expirationIconView?.iconColor } set { expirationIconView?.iconColor = newValue } }
    open dynamic var companyDisclosureColor: UIColor? { get { return companyDisclosureIconView?.iconColor } set { companyDisclosureIconView?.iconColor = newValue } }
    open dynamic var couponDescriptionDisclosureColor: UIColor? { get { return couponDescriptionDisclosureView?.iconColor } set { couponDescriptionDisclosureView?.iconColor = newValue } }
    open dynamic var redemptionCodeDisclosureColor: UIColor? { get { return redemptionCodeDisclosureView?.iconColor } set { redemptionCodeDisclosureView?.iconColor = newValue } }
    open dynamic var redemptionCodeIconColor: UIColor? { get { return barcodeIconView?.iconColor } set { barcodeIconView?.iconColor = newValue } }
    open dynamic var redemptionCodeTitleColor: UIColor? { get { return redemptionCodeTitleLabel?.textColor } set { redemptionCodeTitleLabel?.textColor = newValue } }
    open dynamic var redemptionCodeTitleFont: UIFont? { get { return redemptionCodeTitleLabel?.font } set { redemptionCodeTitleLabel?.font = newValue } }
    open dynamic var redemptionCodeSubtitleColor: UIColor? { get { return redemptionCodeSubtitleLabel?.textColor } set { redemptionCodeSubtitleLabel?.textColor = newValue } }
    open dynamic var redemptionCodeSubtitleFont: UIFont? { get { return redemptionCodeSubtitleLabel?.font } set { redemptionCodeSubtitleLabel?.font = newValue } }
    open dynamic var hideTagsView: Bool = false
    
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
    
    open dynamic var tagPrefix = "#"
    
    // MARK: UIView
    override open func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        saveButton.setTitle("CouponHeaderSave".i18n(), for: UIControlState())
        saveButton.setTitle("CouponHeaderSaved".i18n(), for: .selected)
        shareButton.setTitle("CouponHeaderShare".i18n(), for: UIControlState())

        cellWidthConstraint!.constant = preferredWidth
        self.setNeedsLayout()
    }
    
    override open func layoutSubviews() {
        refreshUI()
        super.layoutSubviews()
    }
    
    func updateTags() {
        tagListView.removeAllTags()
        for tag in coupon.tags {
            let tagView = tagListView.addTag(tagPrefix + tag)
            tagView.onTap = { [unowned self] _ in
                self.delegate?.headerViewDidSelectAction(.showTag(tag: tag), headerView: self)
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
                
                self.couponDetailImageView?.isHidden = true
                if let image = coupon.image {
                    couponDetailImageView?.setImageAnimated(url: image.sourceUrl) { (_, error, _, _) -> Void in
                        if (error == nil) {
                            self.couponDetailImageView?.isHidden = false
                        }
                    }
                }
                
                if let logo = coupon.company.logo {
                    logoImageView.backgroundColor = logo.color
                    logoImageView.setImageAnimated(url: logo.sourceUrl) { _ -> Void in
                        // Restore background color just in case the logo is transparent
                        self.logoImageView.backgroundColor = UIColor.white
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
            
            storeDistanceLabel?.text = userLocation.map { location in coupon.distanceText(location) }
            
            if hasLink {
                showInMapButton?.iconIdentifier = "link"
                showInMapButton?.setTitle("CouponHeaderLink".i18n(), for: UIControlState())
            }
            else {
                showInMapButton?.iconIdentifier = "location"
                showInMapButton?.setTitle("CouponHeaderShowMap".i18n(), for: UIControlState())
                showInMapButton?.isEnabled = hasLocation
            }
            refreshSavedStatus()
            
            if let code = coupon.redemptionCode {
                redemptionCodeDisclosureView.isHidden = !code.alreadyAssigned && code.limited && code.availableCodes == 0
                switch (code.limited, code.alreadyAssigned, code.availableCodes) {
                case (true, true, _):
                    redemptionCodeTitleLabel.text = "CouponHeaderRedemptionCodeShow".i18n()
                    redemptionCodeSubtitleLabel.text = "CouponHeaderRedemptionCodeAssigned".i18n()
                    break
                case (true, false, .some(let available)) where available == 0:
                    redemptionCodeTitleLabel.text = "CouponHeaderRedemptionCodeOutOfStock".i18n()
                    redemptionCodeSubtitleLabel.text = ""
                    break
                case (true, false, .some(let available)) where available <= 1: // TODO: Maybe use a more configurable value
                    redemptionCodeTitleLabel.text = "CouponHeaderRedemptionCodeGet".i18n()
                    redemptionCodeSubtitleLabel.text = "CouponHeaderRedemptionCodeLast".i18n()
                    break
                case (true, false, .some(let available)) where available > 1:
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
        saveButton.isSelected = persistenceService.isSaved(coupon.id)
    }
    
    open override func updateConstraints() {
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
        let hideTags = hideTagsView || coupon?.tags.isEmpty ?? true
        tagViewConstraint.constant = hideTags ? 0 : 150
        
        super.updateConstraints()
    }

    func aspectRatioConstraint(forView view: UIView, ratio: Float) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.height, multiplier: CGFloat(ratio), constant: CGFloat(0))
        return constraint
    }
    
    // MARK: IBActions
    @IBAction func showMapButtonTapped(_ sender: AnyObject) {
        delegate?.headerViewDidSelectAction(hasLink ? .showLink : .showMap, headerView: self)
    }
    @IBAction func saveButtonTapped(_ sender: AnyObject) {
        persistenceService.toggle(coupon.id)
        refreshUI()
    }
    @IBAction func shareButtonTapped(_ sender: AnyObject) {
        delegate?.headerViewDidSelectAction(.share, headerView: self)
    }
    @IBAction func descriptionButtonTapped(_ sender: AnyObject) {
        delegate?.headerViewDidSelectAction(.showDescription, headerView: self)
    }
    @IBAction func companyButtonTapped(_ sender: AnyObject) {
        delegate?.headerViewDidSelectAction(.showCompany, headerView: self)
    }
    @IBAction func codeButtonTapped(_ sender: AnyObject) {
        // Ignore requests if limited codes are out of stock
        guard let code = coupon?.redemptionCode , code.alreadyAssigned || !code.limited || code.availableCodes > 0 else { return }
        delegate?.headerViewDidSelectAction(.showCode, headerView: self)
    }
    
}
