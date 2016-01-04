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
    
    @IBOutlet weak var restaurantsButton: CodeIconButton!
    @IBOutlet weak var shoppingButton: CodeIconButton!
    @IBOutlet weak var leisureButton: CodeIconButton!
    @IBOutlet weak var servicesButton: CodeIconButton!
    
    let geocoder = CLGeocoder()
    let locationManager = CLLocationManager()
    let searchService = SearchService.sharedInstance
    
    let searchComplement = ", Spain"
    
    var userLocation: CLLocation? { didSet { reloadData([.UserLocation]) } }
    var searchResult: SearchResult? { didSet { reloadData([.UserLocation, .Companies]) } }
    var placemarks: [CLPlacemark]? { didSet { reloadData([.UserLocation, .Locations]) } }
    var searchHistory: [SearchHistory]? { didSet { reloadData([.History]); } }
    
    
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
        var categories = [OfferCategory]()
        
        if restaurantsButton?.selected ?? false {
            categories.append(.Restaurants)
        }
        if (shoppingButton?.selected ?? false) {
            categories.append(.Shopping)
        }
        if (leisureButton?.selected ?? false) {
            categories.append(.Leisure)
        }
        if (servicesButton?.selected ?? false) {
            categories.append(.Services)
        }
        
        if categories.count > 0 {
            return categories
        }
        else {
            return nil
        }
    }
    
    private func iconWithIdentifier(iconIdentifier: String) -> UIImage! {
        let iconFrame = CGRectMake(0, 0, 20, 20)
        let icon = CodeIcon(iconIdentifier: iconIdentifier)
        return icon.getImage(iconFrame)
    }
    
    // MARK: UIView Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.barTintColor = UIColor.clearColor()
        searchBar.backgroundImage = UIImage()
        searchBar.scopeBarBackgroundImage = UIImage()
        
        locationManager.delegate = self
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
            
            self.geocoder.geocodeAddressString(searchText + self.searchComplement, completionHandler: { (results, error) in
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
        var cell: UITableViewCell!
        if let section = Section(rawValue: indexPath.section) {
            switch section {
            case .Companies:
                cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell!
                let company = searchResult?.companies[indexPath.row]
                cell.textLabel?.text = company?.name
                cell.imageView?.image = iconWithIdentifier("star")
            case .Locations:
                cell = tableView.dequeueReusableCellWithIdentifier("SubtitleCell") as UITableViewCell!
                let placemark = placemarks?[indexPath.row]
                let name = placemark?.name ?? ""
                let address = ABCreateStringWithAddressDictionary((placemark?.addressDictionary)!, false)
                cell.textLabel?.text = name
                cell.detailTextLabel?.text = address
                cell.imageView?.image = iconWithIdentifier("map-pin")
            case .UserLocation:
                cell = tableView.dequeueReusableCellWithIdentifier("FeaturedCell") as UITableViewCell!
                cell.textLabel?.text = "SearchCellUserLocation".i18n()
                cell.imageView?.image = iconWithIdentifier("location")
            case .History:
                if let history = searchHistory?[indexPath.row] {
                    switch history {
                    case .Location(let name, let address, _, _):
                        cell = tableView.dequeueReusableCellWithIdentifier("SubtitleCell") as UITableViewCell!
                        cell.textLabel?.text = name
                        cell.detailTextLabel?.text = address
                        cell.imageView?.image = iconWithIdentifier("map-pin")
                    case .Company(_, let name):
                        cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell!
                        cell.textLabel?.text = name
                        cell.imageView?.image = iconWithIdentifier("brand")
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
        let filterOptions = FilterOptions(searchTerm: searchTerm, categories: categories, companyId: companyId)
        
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
