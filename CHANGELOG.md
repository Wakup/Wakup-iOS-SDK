# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]
### Added
- Added Objective-C compatibility
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

[Unreleased]: https://github.com/Wakup/Wakup-iOS-SDK/compare/v0.2.1...HEAD
[0.2.1]: https://github.com/Wakup/Wakup-iOS-SDK/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/Wakup/Wakup-iOS-SDK/compare/v0.1.0...v0.2.0