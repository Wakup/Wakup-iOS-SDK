//
//  SearchViewController.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 11/5/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import UIKit
import AddressBookUI
import CoreLocation
import Contacts

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, UISearchResultsUpdating {

    enum Section: Int {
        case userLocation
        case companies
        case tags
        case locations
        case history
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var filterButtonsScrollView: UIScrollView!
    
    var categoryButtons: [SearchFilterButton]?
    var categoryButtonNib = UINib(nibName: "SearchFilterButton", bundle: Bundle(for: SearchViewController.self))
    
    let geocoder = CLGeocoder()
    let locationManager = CLLocationManager()
    let searchService = SearchService.sharedInstance
    
    let searchController = UISearchController(searchResultsController: nil)
    var searchCountry: String? { return WakupManager.manager.options.searchCountryCode.flatMap { (Locale.current as NSLocale).displayName(forKey: NSLocale.Key.countryCode, value: $0) } }
    var searchComplement: String? { return searchCountry.map{", " + $0} }
    
    var userLocation: CLLocation? { didSet { reloadData([.userLocation]) } }
    var searchResult: SearchResult? { didSet { reloadData([.userLocation, .companies, .tags]) } }
    var placemarks: [CLPlacemark]? { didSet { reloadData([.userLocation, .locations]) } }
    var searchHistory: [SearchHistory]? { didSet { reloadData([.history]); } }
    
    let buttonsPadding: CGFloat = 8
    let buttonsSeparation: CGFloat = 8
    
    func configureFilterButtons() {
        categoryButtons = WakupManager.manager.options.searchCategories?.map { category in
            let button = categoryButtonNib.instantiate(withOwner: self, options: nil)[0] as! SearchFilterButton
            button.category = category
            return button
        }
        
        guard let buttons = categoryButtons , !buttons.isEmpty else {
            tableView.tableHeaderView = nil
            return
        }
        
        var previousButton: UIButton? = nil
        for button in buttons {
            filterButtonsScrollView.addSubview(button)
            if let previousButton = previousButton {
                filterButtonsScrollView.addConstraint(NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: previousButton, attribute: .right, multiplier: 1, constant: buttonsSeparation))
            }
            else {
                filterButtonsScrollView.addConstraint(NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: filterButtonsScrollView, attribute: .left, multiplier: 1, constant: 0))
            }
            filterButtonsScrollView.addConstraint(NSLayoutConstraint(item: button, attribute: .centerY, relatedBy: .equal, toItem: filterButtonsScrollView, attribute: .centerY, multiplier: 1, constant: 0))
            
            previousButton = button
        }
        if let lastButton = previousButton {
            filterButtonsScrollView.addConstraint(NSLayoutConstraint(item: lastButton, attribute: .right, relatedBy: .equal, toItem: filterButtonsScrollView, attribute: .right, multiplier: 1, constant: 0))
        }
    }
    
    func reloadData(_ sections: [Section]?) {
        if let sections = sections , sections.count > 0 {
            let indexSet = NSMutableIndexSet()
            for section in sections {
                indexSet.add(section.rawValue)
            }
            self.tableView.reloadSections(indexSet as IndexSet, with: .none)
        }
        else {
            self.tableView.reloadData()
        }
    }
    
    func getSelectedCategories() -> [OfferCategory]? {
        let categories = categoryButtons?.filter{$0.isSelected}.compactMap{$0.category}
        return categories?.isEmpty ?? true ? nil : categories
    }
    
    func configureSearchBar() {
        if #available(iOS 11.0, *) {
            // Setup the Search Controller
            searchController.searchResultsUpdater = self
            searchController.obscuresBackgroundDuringPresentation = false
            searchController.searchBar.placeholder = "SearchBarPlaceholder".i18n()
            
            navigationItem.titleView = nil
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
            
            definesPresentationContext = true
            searchBar = searchController.searchBar
        }
        else {
            // Setup the Search Bar
            let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 260, height: 44))
            searchBar.placeholder = "SearchBarPlaceholder".i18n()
            searchBar.barTintColor = UIColor.clear
            searchBar.backgroundImage = UIImage()
            searchBar.scopeBarBackgroundImage = UIImage()
            searchBar.delegate = self
            navigationItem.titleView = searchBar
            self.searchBar = searchBar
        }
    }
    
    // MARK: UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        searchBar(searchController.searchBar, textDidChange: searchController.searchBar.text ?? "")
    }
    
    // MARK: UIView Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        configureFilterButtons()
        configureSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.startUpdatingLocation()
        searchHistory = searchService.getSavedHistory()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let offset = (filterButtonsScrollView.frame.width - filterButtonsScrollView.contentSize.width) / 2
        filterButtonsScrollView.contentInset = UIEdgeInsets(top: 0, left: max(buttonsPadding, offset), bottom: 0, right: buttonsPadding)
    }

    // MARK: UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchResult = .none
            placemarks = .none
            return
        }
        
        delay(0.2) {
            if (searchBar.text ?? "") != searchText {
                return
            }
            
            self.searchService.genericSearch(searchText, completion: { (result, error) in
                if (searchBar.text ?? "") != searchText {
                    return
                }
                if let error = error {
                    // TODO: Show error to user
                    NSLog("Received error searching: \(error)")
                    self.searchResult = .none
                }
                else if let result = result {
                    NSLog("Received companies \(result.companies.map { $0.name })")
                    self.searchResult = result
                }
            })
            
            
            self.geocoder.geocodeAddressString(searchText + (self.searchComplement ?? ""), completionHandler: { (results, error) in
                if (searchBar.text ?? "") != searchText {
                    return
                }
                if let error = error {
                    // TODO: Show error to user
                    NSLog("Received error searching placemarks: \(error)")
                    self.placemarks = .none
                }
                else if let results = results {
                    NSLog("Received placemarks \(results.map { $0.name })")
                    self.placemarks = results
                }
            })
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(false)
    }
    
    // MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.history.rawValue + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let section = Section(rawValue: section) {
            switch section {
            case .companies:
                return searchResult?.companies.count ?? 0
            case .tags:
                return searchResult?.tags.count ?? 0
            case .locations:
                return placemarks?.count ?? 0
            case .userLocation:
                if userLocation != .none && placemarks?.count ?? 0 == 0 && searchResult?.companies.count ?? 0 == 0 {
                    return 1
                }
            case .history:
                return searchHistory?.count ?? 0
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: SearchResultCell!
        if let section = Section(rawValue: (indexPath as NSIndexPath).section) {
            switch section {
            case .companies:
                cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? SearchResultCell
                let company = searchResult?.companies[(indexPath as NSIndexPath).row]
                cell.textLabel?.text = company?.name
                cell.iconIdentifier = "star"
            case .tags:
                cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? SearchResultCell
                let tag = searchResult?.tags[(indexPath as NSIndexPath).row]
                cell.textLabel?.text = "#" + tag!
                cell.iconIdentifier = "tag"
            case .locations:
                cell = tableView.dequeueReusableCell(withIdentifier: "SubtitleCell") as? SearchResultCell
                let placemark = placemarks?[(indexPath as NSIndexPath).row]
                let name = placemark?.name ?? ""
                let addressFormatter = CNPostalAddressFormatter()
                if let address = placemark?.postalAddress {
                    cell.detailTextLabel?.text = addressFormatter.string(from: address)
                }
                else {
                    cell.detailTextLabel?.text = ""
                }

                cell.textLabel?.text = name
                cell.iconIdentifier = "location"
            case .userLocation:
                cell = tableView.dequeueReusableCell(withIdentifier: "FeaturedCell") as? SearchResultCell
                cell.textLabel?.text = "SearchCellUserLocation".i18n()
                cell.iconIdentifier = "location"
            case .history:
                if let history = searchHistory?[(indexPath as NSIndexPath).row] {
                    switch history {
                    case .location(let name, let address, _, _):
                        cell = tableView.dequeueReusableCell(withIdentifier: "SubtitleCell") as? SearchResultCell
                        cell.textLabel?.text = name
                        cell.detailTextLabel?.text = address
                        cell.iconIdentifier = "location"
                    case .company(_, let name):
                        cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? SearchResultCell
                        cell.textLabel?.text = name
                        cell.iconIdentifier = "star"
                    case .tag(let tag):
                        cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? SearchResultCell
                        cell.textLabel?.text = "#" + tag
                        cell.iconIdentifier = "tag"
                    }
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let section = Section(rawValue: section) {
            switch section {
            case .companies:
                if (searchResult?.companies.count ?? 0) > 0 {
                    return "SearchHeaderCompanies".i18n()
                }
            case .tags:
                if (searchResult?.tags.count ?? 0) > 0 {
                    return "SearchHeaderTags".i18n()
                }
            case .locations:
                if (placemarks?.count ?? 0) > 0 {
                    return "SearchHeaderLocations".i18n()
                }
            case .userLocation:
                break
            case .history:
                if searchHistory?.count ?? 0 > 0 {
                    return "SearchHeaderHistory".i18n()
                }
                break
            }
        }
        return .none
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchTerm: String? = nil
        var companyId: Int?
        var companyName: String?
        var location: CLLocation?
        var locationName: String?
        var selectedTag: String?
        
        var newHistory: SearchHistory? = .none
        if let section = Section(rawValue: (indexPath as NSIndexPath).section) {
            switch section {
            case .companies:
                if let company = searchResult?.companies[(indexPath as NSIndexPath).row] {
                    companyId = company.id
                    companyName = company.name
                    newHistory = .company(id: company.id, name: company.name)
                }
            case .tags:
                if let tag = searchResult?.tags[(indexPath as NSIndexPath).row] {
                    selectedTag = tag
                    newHistory = .tag(tag: tag)
                }
            case .locations:
                if let placemark = placemarks?[(indexPath as NSIndexPath).row], let coord = placemark.location?.coordinate {
                    location = placemark.location
                    locationName = placemark.name
                    let address = (placemark.addressDictionary?["FormattedAddressLines"] as? Array<String>)?.joined(separator: ", ")
                    newHistory = SearchHistory.location(name: placemark.name!, address: address, latitude: coord.latitude, longitude: coord.longitude)
                }
            case .userLocation:
                break
            case .history:
                if let history = searchHistory?[(indexPath as NSIndexPath).row] {
                    newHistory = history
                    switch history {
                    case .location(let name, _, let latitude, let longitude):
                        locationName = name
                        location = CLLocation(latitude: latitude, longitude: longitude)
                    case .company(let id, let name):
                        companyId = id
                        companyName = name
                    case .tag(let tag):
                        selectedTag = tag
                    }
                }
                break
            }
        }
        
        if let newHistory = newHistory {
            searchService.addToHistory(newHistory)
        }
        
        let categories = getSelectedCategories()
        var tags = categories?.flatMap { $0.associatedTags } ?? []
        if let tag = selectedTag {
            tags.append(tag)
        }
        let filterOptions = FilterOptions(searchTerm: searchTerm, tags: tags, companyId: companyId)
        
        if let couponVC = storyboard?.instantiateViewController(withIdentifier: CouponWaterfallViewController.storyboardId) as? CouponWaterfallViewController {
            couponVC.forcedLocation = location
            couponVC.filterOptions = filterOptions
            couponVC.filterTitle = companyName ?? locationName ?? selectedTag.map{"#\($0)"} ?? "SearchResults".i18n()
            navigationController?.pushViewController(couponVC, animated: true)
        }
        
        Async.main(after: 0.1) {
            tableView.deselectRow(at: indexPath, animated: false)
        }

    }
    
    // MARK: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        NSLog("Received new location: %@", newLocation)
        self.userLocation = newLocation
        manager.stopUpdatingLocation()
    }

}
