# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]
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

[Unreleased]: https://github.com/Wakup/Wakup-iOS-SDK/compare/v0.3.3...HEAD
[0.3.3]: https://github.com/Wakup/Wakup-iOS-SDK/compare/v0.3.2...v0.3.3
[0.3.2]: https://github.com/Wakup/Wakup-iOS-SDK/compare/v0.3.1...v0.3.2
[0.3.1]: https://github.com/Wakup/Wakup-iOS-SDK/compare/v0.3.0...v0.3.1
[0.3.0]: https://github.com/Wakup/Wakup-iOS-SDK/compare/v0.2.1...v0.3.0
[0.2.1]: https://github.com/Wakup/Wakup-iOS-SDK/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/Wakup/Wakup-iOS-SDK/compare/v0.1.0...v0.2.0