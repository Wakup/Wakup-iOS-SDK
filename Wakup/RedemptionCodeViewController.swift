//
//  RedemptionCodeViewController.swift
//  Wakup
//
//  Created by Guillermo Gutiérrez on 27/6/16.
//  Copyright © 2016 Yellow Pineapple. All rights reserved.
//

import Foundation

class RedemptionCodeViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate {
    
    var redemptionCode: RedemptionCode!
    var offer: Coupon!
    
    // MARK: IBOutlets
    @IBOutlet weak var codeField: UITextField!
    @IBOutlet weak var imagesScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var imageViews = [UIImageView]()
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        codeField.text = redemptionCode.displayCode
        codeField.inputView = UIView(frame: CGRect.zero) // Disable keyboard
        pageControl.numberOfPages = redemptionCode.formats.count
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let imageSize = imagesScrollView.frame.size
        if imageViews.count != redemptionCode.formats.count {
            for imageView in imageViews {
                imageView.removeFromSuperview()
            }
            imageViews.removeAll()
            
            for format in redemptionCode.formats {
                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFit
                imagesScrollView.addSubview(imageView)
                imageViews.append(imageView)
                
                let imageUrl = OffersService.sharedInstance.redemptionCodeImageUrl(offer.id, format: format, width: Int(imageSize.width), height: Int(imageSize.height))
                imageView.sd_setImage(with: URL(string: imageUrl ?? ""))
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
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int(0.5 + scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = page
    }
    
    // MARK: UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delay(0) {
            textField.selectAll(self)
        }
    }
}
