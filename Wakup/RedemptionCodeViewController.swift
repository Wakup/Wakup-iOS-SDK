//
//  RedemptionCodeViewController.swift
//  Wakup
//
//  Created by Guillermo Gutiérrez on 27/6/16.
//  Copyright © 2016 Yellow Pineapple. All rights reserved.
//

import Foundation

class RedemptionCodeViewController: UIViewController, UIScrollViewDelegate {
    
    var redemptionCode: RedemptionCode!
    var offer: Coupon!
    
    // MARK: IBOutlets
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var imagesScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var imageViews = [UIImageView]()
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        codeLabel.text = redemptionCode.displayCode
        pageControl.numberOfPages = redemptionCode.formats.count
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let imageSize = imagesScrollView.frame.size
        if imageViews.count != redemptionCode.formats.count {
            for imageView in imageViews {
                imageView.removeFromSuperview()
            }
            imageViews.removeAll()
            
            for format in redemptionCode.formats {
                let imageView = UIImageView()
                imageView.contentMode = .ScaleAspectFit
                imagesScrollView.addSubview(imageView)
                imageViews.append(imageView)
                
                let imageUrl = OffersService.sharedInstance.redemptionCodeImageUrl(offer.id, format: format, width: Int(imageSize.width), height: Int(imageSize.height))
                imageView.sd_setImageWithURL(NSURL(string: imageUrl ?? ""))
            }
        }
        
        // Adjust image frames
        var offset: CGFloat = 0
        for imageView in imageViews {
            imageView.frame = CGRect(origin: CGPoint(x: offset, y: 0), size: imageSize)
            offset += imageSize.width
        }
        imagesScrollView.contentSize = CGSize(width: offset, height: 0)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        if redemptionCode.formats.count == 0 {
            imagesScrollView.removeConstraints(imagesScrollView.constraints)
        }
    }
    
    
    // MARK: IBActions
    func actionButtonTapped(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let page = Int(0.5 + scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = page
    }
}