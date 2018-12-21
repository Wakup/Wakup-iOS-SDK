//
//  CategorySelectionView.swift
//  Wakup
//
//  Created by Guillermo Gutiérrez Doral on 14/12/18.
//  Copyright © 2018 Yellow Pineapple. All rights reserved.
//

import Foundation
import UIKit

public protocol CategorySelectionViewDelegate: NSObjectProtocol {
    func didSelectCategory(_ category: CompanyCategory?, company: CompanyWithCount?)
}

@IBDesignable
open class CategorySelectionView: UIView {
    
    @IBOutlet public weak var categorySelector: BarButtonView!
    @IBOutlet public weak var companySelector: BarButtonView!
    
    // Callback
    open var onCategorySelected: ((CompanyCategory?, CompanyWithCount?) -> Void)?
    
    var categoryHelper: BarButtonView.Helper<CompanyCategory, UIButton>?
    var companyHelper: BarButtonView.Helper<CompanyWithCount, UIButton>?
    
    public let offerService = OffersService.sharedInstance
    
    open var categories: [CompanyCategory]? { didSet { reloadCategories() } }
    open var selectedCategory: CompanyCategory? { didSet { reloadCompanies() } }
    open var selectedCompany: CompanyWithCount?
    
    var categoriesHeightConstraint: NSLayoutConstraint?
    var companiesHeightConstraint: NSLayoutConstraint?
    
    open func fetchCategories() {
        guard categories == nil else { return }
        offerService.getCategories { [weak self] categories, error in
            self?.categories = categories
        }
    }
    
    open func reloadCategories() {
        categoryHelper?.items = self.categories ?? []
        selectedCategory = nil
        
        if let constraint = categoriesHeightConstraint {
            categorySelector.removeConstraint(constraint)
            categoriesHeightConstraint = nil
        }
        if categories?.isEmpty ?? true {
            categoriesHeightConstraint = categorySelector.heightAnchor.constraint(equalToConstant: 0)
            categorySelector.addConstraint(categoriesHeightConstraint!)
        }
    }
    
    open func reloadCompanies() {
        let availableCompanies = selectedCategory?.companies ?? Set(categories?.flatMap { $0.companies } ?? []).sorted { $0.name < $1.name }
        companyHelper?.items = availableCompanies
        selectedCompany = nil
        
        if let constraint = companiesHeightConstraint {
            companySelector.removeConstraint(constraint)
            companiesHeightConstraint = nil
        }
        if availableCompanies.isEmpty {
            companiesHeightConstraint = companySelector.heightAnchor.constraint(equalToConstant: 0)
            companySelector.addConstraint(companiesHeightConstraint!)
        }
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        categoryHelper = BarButtonView.Helper(view: categorySelector, onSelection: categorySelected, configureButton: configureCategoryButton)
        companyHelper = BarButtonView.Helper(view: companySelector, onSelection: companySelected, configureButton: configureCompanyButton)
        
        reloadCategories()
    }
    
    func categorySelected(category: CompanyCategory?) {
        selectedCategory = category
        selectedCompany = nil
        
        onCategorySelected?(selectedCategory, selectedCompany)
    }
    
    func companySelected(company: CompanyWithCount?) {
        selectedCompany = company
        onCategorySelected?(selectedCategory, selectedCompany)
    }
    
    func configureCategoryButton(button: UIButton, category: CompanyCategory) {
        button.setTitle(category.name, for: [])
    }
    
    func configureCompanyButton(button: UIButton, company: CompanyWithCount) {
        button.sd_cancelCurrentImageLoad()
        button.setBackgroundImage(nil, for: [])
        guard let logo = company.logo else { return }
        
        // Set aspect ratio
        button.removeConstraints(button.constraints)
        let aspectRatio = CGFloat(logo.height / logo.width)
        let _ = button.constrain(.height, .equal, button, .width, constant: CGFloat(0), multiplier: aspectRatio)
        let _ = button.constrain(.height, .equal, constant: companySelector.stackView.frame.height - 10)
        
        // Load image
        button.sd_setBackgroundImage(with: logo.sourceUrl, for: .normal, completed: nil)
    }
}
