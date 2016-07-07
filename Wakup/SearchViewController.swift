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

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {

    enum Section: Int {
        case UserLocation
        case Companies
        case Locations
        case History
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var filterButtonsScrollView: UIScrollView!
    
    var categoryButtons: [SearchFilterButton]?
    var categoryButtonNib = UINib(nibName: "SearchFilterButton", bundle: NSBundle(forClass: SearchViewController.self))
    
    let geocoder = CLGeocoder()
    let locationManager = CLLocationManager()
    let searchService = SearchService.sharedInstance
    
    var searchCountry: String? { return WakupManager.manager.options.searchCountryCode.flatMap { NSLocale.currentLocale().displayNameForKey(NSLocaleCountryCode, value: $0) } }
    var searchComplement: String? { return searchCountry.map{", " + $0} }
    
    var userLocation: CLLocation? { didSet { reloadData([.UserLocation]) } }
    var searchResult: SearchResult? { didSet { reloadData([.UserLocation, .Companies]) } }
    var placemarks: [CLPlacemark]? { didSet { reloadData([.UserLocation, .Locations]) } }
    var searchHistory: [SearchHistory]? { didSet { reloadData([.History]); } }
    
    let buttonsPadding: CGFloat = 8
    let buttonsSeparation: CGFloat = 8
    
    func configureFilterButtons() {
        categoryButtons = WakupManager.manager.options.searchCategories?.map { category in
            let button = categoryButtonNib.instantiateWithOwner(self, options: nil)[0] as! SearchFilterButton
            button.category = category
            return button
        }
        
        guard let buttons = categoryButtons where !buttons.isEmpty else {
            tableView.tableHeaderView = nil
            return
        }
        
        var previousButton: UIButton? = nil
        for button in buttons {
            filterButtonsScrollView.addSubview(button)
            if let previousButton = previousButton {
                filterButtonsScrollView.addConstraint(NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: previousButton, attribute: .Right, multiplier: 1, constant: buttonsSeparation))
            }
            else {
                filterButtonsScrollView.addConstraint(NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: filterButtonsScrollView, attribute: .Left, multiplier: 1, constant: 0))
            }
            filterButtonsScrollView.addConstraint(NSLayoutConstraint(item: button, attribute: .CenterY, relatedBy: .Equal, toItem: filterButtonsScrollView, attribute: .CenterY, multiplier: 1, constant: 0))
            
            previousButton = button
        }
        if let lastButton = previousButton {
            filterButtonsScrollView.addConstraint(NSLayoutConstraint(item: lastButton, attribute: .Right, relatedBy: .Equal, toItem: filterButtonsScrollView, attribute: .Right, multiplier: 1, constant: 0))
        }
    }
    
    func reloadData(sections: [Section]?) {
        if let sections = sections where sections.count > 0 {
            let indexSet = NSMutableIndexSet()
            for section in sections {
                indexSet.addIndex(section.rawValue)
            }
            self.tableView.reloadSections(indexSet, withRowAnimation: .None)
        }
        else {
            self.tableView.reloadData()
        }
    }
    
    func getSelectedCategories() -> [OfferCategory]? {
        let categories = categoryButtons?.filter{$0.selected}.flatMap{$0.category}
        return categories?.isEmpty ?? true ? nil : categories
    }
    
    // MARK: UIView Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.barTintColor = UIColor.clearColor()
        searchBar.backgroundImage = UIImage()
        searchBar.scopeBarBackgroundImage = UIImage()
        
        locationManager.delegate = self
        
        configureFilterButtons()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.startUpdatingLocation()
        searchHistory = searchService.getSavedHistory()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let offset = (filterButtonsScrollView.frame.width - filterButtonsScrollView.contentSize.width) / 2
        filterButtonsScrollView.contentInset = UIEdgeInsets(top: 0, left: max(buttonsPadding, offset), bottom: 0, right: buttonsPadding)
    }

    // MARK: UISearchBarDelegate
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchResult = .None
            placemarks = .None
            return
        }
        
        Async.background(after: 0.2, block: {
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
                    self.searchResult = .None
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
                    NSLog("Received error searching placemarks: %@", error)
                    self.placemarks = .None
                }
                else if let results = results {
                    NSLog("Received placemarks \(results.map { $0.name })")
                    self.placemarks = results
                }
            })
        })
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.endEditing(false)
    }
    
    // MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Section.History.rawValue + 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let section = Section(rawValue: section) {
            switch section {
            case .Companies:
                return searchResult?.companies.count ?? 0
            case .Locations:
                return placemarks?.count ?? 0
            case .UserLocation:
                if userLocation != .None && placemarks?.count ?? 0 == 0 && searchResult?.companies.count ?? 0 == 0 {
                    return 1
                }
            case .History:
                return searchHistory?.count ?? 0
            }
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: SearchResultCell!
        if let section = Section(rawValue: indexPath.section) {
            switch section {
            case .Companies:
                cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! SearchResultCell
                let company = searchResult?.companies[indexPath.row]
                cell.textLabel?.text = company?.name
                cell.iconIdentifier = "star"
            case .Locations:
                cell = tableView.dequeueReusableCellWithIdentifier("SubtitleCell") as! SearchResultCell
                let placemark = placemarks?[indexPath.row]
                let name = placemark?.name ?? ""
                let address = ABCreateStringWithAddressDictionary((placemark?.addressDictionary)!, false)
                cell.textLabel?.text = name
                cell.detailTextLabel?.text = address
                cell.iconIdentifier = "location"
            case .UserLocation:
                cell = tableView.dequeueReusableCellWithIdentifier("FeaturedCell") as! SearchResultCell
                cell.textLabel?.text = "SearchCellUserLocation".i18n()
                cell.iconIdentifier = "location"
            case .History:
                if let history = searchHistory?[indexPath.row] {
                    switch history {
                    case .Location(let name, let address, _, _):
                        cell = tableView.dequeueReusableCellWithIdentifier("SubtitleCell") as! SearchResultCell
                        cell.textLabel?.text = name
                        cell.detailTextLabel?.text = address
                        cell.iconIdentifier = "location"
                    case .Company(_, let name):
                        cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! SearchResultCell
                        cell.textLabel?.text = name
                        cell.iconIdentifier = "star"
                    }
                }
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let section = Section(rawValue: section) {
            switch section {
            case .Companies:
                if (searchResult?.companies.count ?? 0) > 0 {
                    return "SearchHeaderCompanies".i18n()
                }
            case .Locations:
                if (placemarks?.count ?? 0) > 0 {
                    return "SearchHeaderLocations".i18n()
                }
            case .UserLocation:
                break
            case .History:
                if searchHistory?.count ?? 0 > 0 {
                    return "SearchHeaderHistory".i18n()
                }
                break
            }
        }
        return .None
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let searchTerm: String? = nil
        var companyId: Int?
        var companyName: String?
        var location: CLLocation?
        var locationName: String?
        
        var newHistory: SearchHistory? = .None
        if let section = Section(rawValue: indexPath.section) {
            switch section {
            case .Companies:
                if let company = searchResult?.companies[indexPath.row] {
                    companyId = company.id
                    companyName = company.name
                    newHistory = .Company(id: company.id, name: company.name)
                }
            case .Locations:
                if let placemark = placemarks?[indexPath.row], let coord = placemark.location?.coordinate {
                    location = placemark.location
                    locationName = placemark.name
                    let address = ABCreateStringWithAddressDictionary(placemark.addressDictionary!, false)
                    newHistory = SearchHistory.Location(name: placemark.name!, address: address, latitude: coord.latitude, longitude: coord.longitude)
                }
            case .UserLocation:
                break
            case .History:
                if let history = searchHistory?[indexPath.row] {
                    newHistory = history
                    switch history {
                    case .Location(let name, _, let latitude, let longitude):
                        locationName = name
                        location = CLLocation(latitude: latitude, longitude: longitude)
                    case .Company(let id, let name):
                        companyId = id
                        companyName = name
                    }
                }
                break
            }
        }
        
        if let newHistory = newHistory {
            searchService.addToHistory(newHistory)
        }
        
        let categories = getSelectedCategories()
        let tags = categories?.flatMap { $0.associatedTags }
        let filterOptions = FilterOptions(searchTerm: searchTerm, tags: tags, companyId: companyId)
        
        if let couponVC = storyboard?.instantiateViewControllerWithIdentifier(CouponWaterfallViewController.storyboardId) as? CouponWaterfallViewController {
            couponVC.forcedLocation = location
            couponVC.filterOptions = filterOptions
            couponVC.filterTitle = companyName ?? locationName ?? "SearchResults".i18n()
            navigationController?.pushViewController(couponVC, animated: true)
        }
        
        Async.main(after: 0.1) {
            tableView.deselectRowAtIndexPath(indexPath, animated: false)
        }

    }
    
    // MARK: CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        NSLog("Received new location: %@", newLocation)
        self.userLocation = newLocation
        locationManager.stopUpdatingLocation()
    }

}
