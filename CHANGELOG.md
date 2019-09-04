# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]
- No changes

## [4.0.1] - 2019-09-04
- Added `swift_versions` property to podspec file.

## [4.0.0] - 2019-09-04
### Added
- Added category and company selectors on top of the offer list to filter the current selection.
- Added related offers section to the end of the company filtered offers.
/Users/redent/workspace/wakup-sdk/Wakup/CouponDetailCollectionViewCell.swift

## [3.3.0] - 2018-12-13
### Added
- Non-vectorial images can now be used instead of vectorial icons anywhere in the application.

## [3.2.0] - 2018-10-29
### Changed
- Serch controller will now use UISearchController for iOS 10+ devices and will use the legacy UISearchBar embedded in the navigation bar for older OS versions.

### Fixed
- Fixed warnings for accessing UI elements from background threads
- Fixed ambiguity errors in XCode 10

## [3.1.1] - 2017-12-18
### Changed
- Adapted string operations to Swift 4 to remove compilation warnings

## [3.1.0] - 2017-12-18
### Added
- Added convenience methods for customizing tint colors and general appearance

### Changed
- `TagListView` classes have been replaced with `WakupTagListView` subclass to improve customizing 

## [3.0.0] - 2017-11-14
### Changed
- Project has been migrated to Swift 4
- Updated dependencies for Swift 4 support

## [2.3.1] - 2017-11-03
### Added
- Changed accesibility of some classes to make customization easier.
 
## [2.3.0] - 2017-10-05
### Added
- Implemented `setAlias` method in `WakupManager`.

## [2.2.1] - 2017-01-17
### Fixed
- Fixed compilation issues after [SwiftJSON 3.1.4 included compatibility breaking changes](https://github.com/SwiftyJSON/SwiftyJSON/pull/755/commits/7afc077db6cd7dad2e81388bc8c3b6e959f90c50).

## [2.2.0] - 2016-11-04
### Added
- Added public method to fetch recommended offers. Used in the demo application for the home offers widget
- Added `IBOutlet` and customization properties for a full description label in offer collection view cell 

### Fixed
- Offer details view will now scroll to selected offer correctly when presented in a modal view

## [2.1.0] - 2016-11-03
### Changed
- Some classes are now public to allow better UI customization

### Fixed
- Fixed blur effect animation on coupon description modal view

### Added
- Offer details controller will now show a dismiss button when presented modally
- `WakupManager` now provides access to the offer details controller
- SDK Demo now includes a offer carrousel widget sample to show how to integrate `WakupManager` and `CouponDetailsViewController` directly in the application

## [2.0.0] - 2016-10-26
### Added
- Tag list view can now be hidden in the offer details view by setting the `hideTagsView` property of the `CouponDetailHeadersView` appearance proxy to `false`

### Changed
- Migrated code to Swift 3 and XCode 8
- Updated most dependencies for Swift 3
- Updated WakupDemo `Podspec` to use a different version of `iOSContextualMenu` that works correctly on modal controllers

## [1.0.0] - 2016-07-11
### Added
- Added tag search to search controller
- Offer details now show the associated tags. Tags are clickable and will allow browsing offers with that tag.
- Offer details now show redemption code if available.

### Changed
- Categories filter in search controller are now dynamic and can be configured via `WakupOptions` on setup
- Map icon categories are now dynamic and can be configured via `CouponAnnotationView` appearance proxy.
- Updated framework and demo `Podfile` to CocoaPods 1.0 spec

## [0.3.5] - 2016-03-11
### Fixed
- Fixed issue that shown offers that expire today as already expired.

## [0.3.4] - 2016-03-07
### Added
- Web view controller is now public and accesible using `WakupManager`

### Changed
- Modal close button is now the default iOS 'stop' icon instead of a custom one

## [0.3.3] - 2016-03-07
### Fixed
- Fixed an issue that could cause empty distance labels when navigating related results after a location search.

## [0.3.2] - 2016-03-04
### Added
- Added link, phone and address link detection in offer details text.

### Fixed
- 'Report offer error' button will now correctly use navigation bar tint color.

## [0.3.1] - 2016-02-19
### Fixed
- Fixed an issue that could cause unnecessary API requests when opening an offer

## [0.3.0] - 2016-02-17
### Added
- Implemented user statistics and device information reporting
- Added 'report offer error' functionality in offer details view
- Added Objective-C compatibility in WakupManager class
- Included minimal Objective-C sample project

## [0.2.1] - 2016-01-18
### Added
- Added `pod try Wakup` documentation to [`README`](https://github.com/Wakup/Wakup-iOS-SDK/blob/master/README.md) file

### Changed
- Changed highlighted offer URL to the application-specific URL
- Highlighted offer unsecure URLs are now opened in Safari

## [0.2.0] - 2016-01-18
### Added
- Added CHANGELOG file to keep track of changes between versions
- Included original PaintCode file with all icons included in the SDK
- Online offers now may have an external link that opens in Safari
- Added 'link' icon for the external URL button of the offer
- Offer share text now includes the company name

### Changed
- Default user location is now configurable via `WakupOptions`
- Search location country is now configurable via `WakupOptions`
- Minor changes in README file

### Fixed
- Application no longer shows duplicated offers when there are very few results
- Fixed sample application window frame on iOS 8


## 0.1.0 - 2016-01-13
### Added
- First fully functional public release.

[Unreleased]: https://github.com/Wakup/Wakup-iOS-SDK/compare/v4.0.1...HEAD
[4.0.1]: https://github.com/Wakup/Wakup-iOS-SDK/compare/v4.0.0...v4.0.1
[4.0.0]: https://github.com/Wakup/Wakup-iOS-SDK/compare/v3.3.0...v4.0.0
[3.3.0]: https://github.com/Wakup/Wakup-iOS-SDK/compare/v3.2.0...v3.3.0
[3.2.0]: https://github.com/Wakup/Wakup-iOS-SDK/compare/v3.1.1...v3.2.0
[3.1.1]: https://github.com/Wakup/Wakup-iOS-SDK/compare/v3.1.0...v3.1.1
[3.1.0]: https://github.com/Wakup/Wakup-iOS-SDK/compare/v3.0.0...v3.1.0
[3.0.0]: https://github.com/Wakup/Wakup-iOS-SDK/compare/v2.3.1...v3.0.0
[2.3.1]: https://github.com/Wakup/Wakup-iOS-SDK/compare/v2.3.0...v2.3.1
[2.3.0]: https://github.com/Wakup/Wakup-iOS-SDK/compare/v2.2.1...v2.3.0
[2.2.1]: https://github.com/Wakup/Wakup-iOS-SDK/compare/v2.2.0...v2.2.1
[2.2.0]: https://github.com/Wakup/Wakup-iOS-SDK/compare/v2.1.0...v2.2.0
[2.1.0]: https://github.com/Wakup/Wakup-iOS-SDK/compare/v2.0.0...v2.1.0
[2.0.0]: https://github.com/Wakup/Wakup-iOS-SDK/compare/v1.0.0...v2.0.0
[1.0.0]: https://github.com/Wakup/Wakup-iOS-SDK/compare/v0.3.5...v1.0.0
[0.3.5]: https://github.com/Wakup/Wakup-iOS-SDK/compare/v0.3.4...v0.3.5
[0.3.4]: https://github.com/Wakup/Wakup-iOS-SDK/compare/v0.3.3...v0.3.4
[0.3.3]: https://github.com/Wakup/Wakup-iOS-SDK/compare/v0.3.2...v0.3.3
[0.3.2]: https://github.com/Wakup/Wakup-iOS-SDK/compare/v0.3.1...v0.3.2
[0.3.1]: https://github.com/Wakup/Wakup-iOS-SDK/compare/v0.3.0...v0.3.1
[0.3.0]: https://github.com/Wakup/Wakup-iOS-SDK/compare/v0.2.1...v0.3.0
[0.2.1]: https://github.com/Wakup/Wakup-iOS-SDK/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/Wakup/Wakup-iOS-SDK/compare/v0.1.0...v0.2.0
