Wakup SDK Library
==================

[![Badge w/ Version](https://cocoapod-badges.herokuapp.com/v/Wakup/badge.png)](https://github.com/Wakup/Wakup-iOS-SDK/blob/master/CHANGELOG.md)
[![Badge w/ Platform](https://cocoapod-badges.herokuapp.com/p/Wakup/badge.svg)](https://cocoapods.org/pods/Wakup)
[![License MIT](https://go-shields.herokuapp.com/license-MIT-blue.png)](https://github.com/Wakup/Wakup-iOS-SDK/blob/master/LICENSE)

Native iOS SDK for [Wakup platform](http://wakup.net).

## Installation

To start using Wakup you have to integrate the Wakup SDK in your iOS application. If you already have [CocoaPods](http://cocoapods.org/) installed, you can open the sample project by executing:

~~~
pod try Wakup
~~~

This will open the project with all the dependencies already installed and ready to execute.


### Using CocoaPods

[CocoaPods](http://cocoapods.org/) is the easiest and most maintainable way to install Wakup SDK. If you are using CocoaPods (that you should) just follow these steps:

1. Add a reference to the [Wakup pod](https://cocoapods.org/pods/Wakup) to your `Podfile`.

	~~~
	pod 'Wakup'
	~~~

2. Install the pods executing in your command line:

	~~~
	pod install
	~~~

## Basic Wakup SDK Integration

Basic integration includes everything required to get the offers module up and running with little effort.

### Import module

If you installed Wakup SDK using CocoaPods, you have to import the `Wakup` module on any file accessing any Wakup class:

~~~swift
import Wakup
~~~


### Setup Wakup SDK

In order to access to Wakup functionality, the `WakupManager` has to be setup. The perfect place to do it is `application: didFinishLaunchingWithOptions:` method of your application delegate.

~~~swift
// Setup Wakup SDK with API Key
WakupManager.manager.setup("WAKUP_API_KEY")
~~~

Replace `WAKUP_API_KEY ` with the configuration values for your application in [app.wakup.net](https://app.wakup.com). The method `setup` must be called before presenting any Wakup view controller.


### Present root Wakup Controller

Once configured, you can present the offer list controller anywhere in your application. Wakup gives access to the root controller through the `rootController` method of `WakupManager` instance. You can push this controller to any `UINavigationController` of your application:

~~~swift
// Obtain Wakup root controller
let wakupController = WakupManager.manager.rootController()
// Enable animation zoom-in and zoom-out transitions
navigationController.delegate = NavigationControllerDelegate()
// Present the Wakup root controller in the current navigation controller
navigationManager.pushViewController(wakupController, animated: true)
~~~
    
Note that Wakup requires a translucent navigation bar in order to be displayed correctly.


#### Using embedded navigation controller

Wakup SDK also provides its own `UINavigationController` with animation delegate pre-configured to make other presentation forms easier. It can be obtained by calling `rootNavigationController` method of `WakupManager` instance.

~~~swift
// Obtain Wakup root navigation controller
let wakupController = WakupManager.manager.rootNavigationController()
// Present the Wakup root navigation controller modally
presentViewController(wakupController, animated: true, completion: nil)
~~~

Wakup controller will automatically detect if it's being presented modally and add a close button to the navigation bar.



## Customization

The default Wakup integration would look like this:

[![](http://imgur.com/lSOAScDm.png)](http://imgur.com/lSOAScD.png) [![](http://imgur.com/Enc6IDBm.png)](http://imgur.com/Enc6IDB.png) [![](http://imgur.com/j9h9HZXm.png)](http://imgur.com/j9h9HZX.png) [![](http://imgur.com/lJvMTMFm.png)](http://imgur.com/lJvMTMF.png)

Most application colors, fonts and icons are easily customizable. If not customized, they will appear with the default look&feel of Wakup.


### Customize colors

Most component colors are configurable using `UIAppearance` proxies, the same way native components are customized. This customization must be applied before presenting any Wakup controller.


#### Navigation bar

Navigation bar can be customized using `UINavigationBar` appearance proxy like any other iOS application. Icons and buttons will take the navigation bar `tintColor` property for tinting themselves.

[![](http://imgur.com/ywguOtAl.png)](http://imgur.com/ywguOtA.png)

~~~swift
let navBarColor = UIColor(red:0.26, green:0.07, blue:0.25, alpha:1)
let tintColor = UIColor(red:0.56, green:0.38, blue:0.57, alpha:1)

UINavigationBar.appearance().barTintColor = navBarColor
UINavigationBar.appearance().tintColor = tintColor
UINavigationBar.appearance().titleTextAttributes = [
    NSForegroundColorAttributeName: tintColor
]
~~~
    
    


#### Offer list top bar

Top bar view can be customized by using `TopMenuButton` and `TopMenuView` appearance proxies. Change `TopMenuView` background color to change the separator colors and customize `TopMenuButton` as standard `UIButton` with some extension properties for changing icon color.

[![](http://imgur.com/SPnJZdrl.png)](http://imgur.com/SPnJZdr.png)

~~~swift
let backgroundColor = UIColor(red:0.26, green:0.15, blue:0.26, alpha:1)
let buttonBackgroundColor = UIColor(red:0.23, green:0.12, blue:0.24, alpha:1)
let buttonColor = UIColor(red:0.56, green:0.38, blue:0.57, alpha:1)
let highlightedButtonColor = buttonColor.colorWithAlphaComponent(0.5)
    
TopMenuButton.appearance().setTitleColor(buttonColor, forState: .Normal)
TopMenuButton.appearance().setTitleColor(highlightedButtonColor, forState: .Highlighted)
TopMenuButton.appearance().iconColor = buttonColor
TopMenuButton.appearance().highlightedIconColor = highlightedButtonColor
TopMenuButton.appearance().backgroundColor = buttonBackgroundColor
TopMenuButton.appearance().highlightedBackgroundColor = buttonBackgroundColor
TopMenuView.appearance().backgroundColor = backgroundColor
~~~

In addition, icons can be removed from the menu buttons by setting the `iconIdentifier` to `nil` and restoring the edge insets:

~~~swift
// Remove icons from menu buttons
TopMenuButton.appearance().iconIdentifier = nil
TopMenuButton.appearance().titleEdgeInsets = UIEdgeInsetsZero
TopMenuButton.appearance().imageEdgeInsets = UIEdgeInsetsZero
~~~



#### Offer views

Offer cascade views can be customized using `CollectionViewCell` appearance proxy, in addition to the `DiscountTagView` that modifies both the list and the detail green discount tag.

[![](http://imgur.com/rsyNPGZl.png)](http://imgur.com/rsyNPGZ.png)


~~~swift
let titleColor = UIColor.blackColor()
let descriptionColor = UIColor(white: 0.33, alpha: 1)
let detailsColor = UIColor(white:0.56, alpha:1)
    
CouponCollectionViewCell.appearance().storeNameTextColor = titleColor
CouponCollectionViewCell.appearance().descriptionTextColor = descriptionColor
CouponCollectionViewCell.appearance().distanceTextColor = detailsColor
CouponCollectionViewCell.appearance().distanceIconColor = detailsColor
CouponCollectionViewCell.appearance().expirationTextColor = detailsColor
CouponCollectionViewCell.appearance().expirationIconColor = detailsColor

let tagColor = UIColor(red:0.5, green:0.59, blue:0.1, alpha:1)
DiscountTagView.appearance().backgroundColor = tagColor
DiscountTagView.appearance().labelColor = UIColor.whiteColor()
~~~



#### Offer quick actions

Quick actions appear when a offer view is pressed for a few seconds. They can be customized using `ContextItemView` appearance proxy.

[![](http://imgur.com/PDJIE2ql.png)](http://imgur.com/PDJIE2q.png)

~~~swift
let quickActionColor = UIColor(red:0.56, green:0.39, blue:0.56, alpha:1)
let quickActionHighlightedColor = UIColor(red:0.7, green:0.42, blue:0.71, alpha:1)

ContextItemView.appearance().backgroundColor = quickActionColor
ContextItemView.appearance().highlightedBackgroundColor = quickActionHighlightedColor
ContextItemView.appearance().iconColor = UIColor.whiteColor()
ContextItemView.appearance().highlightedIconColor = UIColor.whiteColor()
ContextItemView.appearance().borderColor = UIColor.whiteColor()
~~~



#### Offer details

Offer details view can be customized using `CouponDetailHeaderView` appearance proxy. The green tag can be customized using `DiscountTagView` and shares appearance with the main offer view described above.

[![](http://imgur.com/CIh11Acl.png)](http://imgur.com/CIh11Ac.png)

~~~swift
let titleColor = UIColor.blackColor()
let descriptionColor = UIColor(white: 0.33, alpha: 1)
let detailsColor = UIColor(white:0.56, alpha:1)

CouponDetailHeaderView.appearance().companyNameTextColor = titleColor
CouponDetailHeaderView.appearance().storeAddressTextColor = detailsColor
CouponDetailHeaderView.appearance().storeDistanceTextColor = detailsColor
CouponDetailHeaderView.appearance().storeDistanceIconColor = detailsColor
CouponDetailHeaderView.appearance().couponNameTextColor = descriptionColor
CouponDetailHeaderView.appearance().couponDescriptionTextColor = detailsColor
CouponDetailHeaderView.appearance().expirationTextColor = detailsColor
CouponDetailHeaderView.appearance().expirationIconColor = detailsColor
CouponDetailHeaderView.appearance().companyDisclosureColor = detailsColor
CouponDetailHeaderView.appearance().couponDescriptionDisclosureColor = detailsColor
CouponDetailHeaderView.appearance().companyNameTextColor = detailsColor

let tagColor = UIColor(red:0.5, green:0.59, blue:0.1, alpha:1)
DiscountTagView.appearance().backgroundColor = tagColor
DiscountTagView.appearance().labelColor = UIColor.whiteColor()
~~~





#### Offer action buttons

Offer action buttons appear below the offer details and can be customized using the `CouponActionButton` appearance proxy.

[![](http://imgur.com/b5AJ67il.png)](http://imgur.com/b5AJ67i.png)

~~~swift
let actionColor = UIColor(red:0.56, green:0.38, blue:0.57, alpha:1)
CouponActionButton.appearance().iconColor = actionColor
CouponActionButton.appearance().highlightedBackgroundColor = actionColor
CouponActionButton.appearance().setTitleColor(actionColor, forState: .Normal)
CouponActionButton.appearance().normalBorderColor = actionColor
~~~



#### Offer finder

Offer finder allows customization of filter icons through `SearchFilterButton` appearance proxy and result cells using `SearchResultCell`.

[![](http://imgur.com/NBH4Xs2l.png)](http://imgur.com/NBH4Xs2.png)

~~~swift
let searchButtonColor = UIColor(red:0.56, green:0.38, blue:0.57, alpha:1)
let iconTintColor = UIColor(red:0.56, green:0.38, blue:0.57, alpha:1)

SearchFilterButton.appearance().iconColor = searchButtonColor
SearchFilterButton.appearance().highlightedBackgroundColor = searchButtonColor
SearchFilterButton.appearance().setTitleColor(searchButtonColor, forState: .Normal)
SearchFilterButton.appearance().normalBorderColor = searchButtonColor
    
SearchResultCell.appearance().iconColor = iconTintColor
~~~


#### Offer map

Offer map view allows customization of map pin colors using `CouponAnnotationView` appearance proxy.

[![](http://imgur.com/bCTSODDl.png)](http://imgur.com/bCTSODD.png)

~~~swift
let restaurantCategoryColor: UIColor = UIColor(red: 0.660, green: 0.133, blue: 0.159, alpha: 1.000)
let leisureCategoryColor: UIColor = UIColor(red: 0.201, green: 0.310, blue: 0.550, alpha: 1.000)
let servicesCategoryColor: UIColor = UIColor(red: 0.803, green: 0.341, blue: 0.092, alpha: 1.000)
let shoppingCategoryColor: UIColor = UIColor(red: 0.321, green: 0.498, blue: 0.190, alpha: 1.000)
    
CouponAnnotationView.appearance().restaurantCategoryColor = restaurantCategoryColor
CouponAnnotationView.appearance().leisureCategoryColor = leisureCategoryColor
CouponAnnotationView.appearance().servicesCategoryColor = servicesCategoryColor
CouponAnnotationView.appearance().shoppingCategoryColor = shoppingCategoryColor
~~~


### Customize fonts

Most fonts of the Wakup views can be customized using the same `UIAppearance` proxies that are used for color customization. Take into account that font size has to be explicitly specified and some labels have minimum font scale to avoid word clipping.


### Customize icons

Wakup SDK uses vectorial CoreGraphics methods to draw icons that allow resizing and tinting icons using native iOS functionality. All Wakup icons are packed in a 'icon library', that can be extended (or completely overriden) to replace the application icons.

To achieve it, simply subclass `DefaultIconLibrary` class and return the new draw method of the desired icons.

For example, we want to override the default share icon:

![](http://imgur.com/cN8ls2h.png)

with a new paper plane version:

![](http://imgur.com/FerbLaJ.png)



First convert the icon to CoreGraphics format using [PaintCode](http://www.paintcodeapp.com) or any other vectorial to CoreGraphics application. Remember to set the resizing mask so the icon size is relative to the frame. The generated code would look like this:

~~~swift
class CustomDrawMethods {
    // Draw method generated using PaintCode
    class func drawPaperPlane(frame frame: CGRect = CGRectMake(0, 0, 88, 87), fillColor: UIColor = UIColor(red: 0.381, green: 0.421, blue: 0.442, alpha: 1.000)) {
        
        //// Subframes
        let group: CGRect = CGRectMake(frame.minX - 0.39, frame.minY + 0.07, frame.width + 0.39, frame.height - 0.07)
        
        //// Group
        //// Bezier 86 Drawing
        let bezier86Path = UIBezierPath()
        bezier86Path.moveToPoint(CGPointMake(group.minX + 0.79353 * group.width, group.minY + 1.00000 * group.height))
        bezier86Path.addLineToPoint(CGPointMake(group.minX + 0.51238 * group.width, group.minY + 0.77596 * group.height))
        bezier86Path.addLineToPoint(CGPointMake(group.minX + 0.31396 * group.width, group.minY + 1.00000 * group.height))
        bezier86Path.addLineToPoint(CGPointMake(group.minX + 0.28096 * group.width, group.minY + 0.66389 * group.height))
        bezier86Path.addLineToPoint(CGPointMake(group.minX + 0.00000 * group.width, group.minY + 0.46550 * group.height))
        bezier86Path.addLineToPoint(CGPointMake(group.minX + 1.00000 * group.width, group.minY + 0.00000 * group.height))
        bezier86Path.addLineToPoint(CGPointMake(group.minX + 0.79353 * group.width, group.minY + 1.00000 * group.height))
        bezier86Path.addLineToPoint(CGPointMake(group.minX + 0.79353 * group.width, group.minY + 1.00000 * group.height))
        bezier86Path.closePath()
        bezier86Path.moveToPoint(CGPointMake(group.minX + 0.49593 * group.width, group.minY + 0.66389 * group.height))
        bezier86Path.addLineToPoint(CGPointMake(group.minX + 0.99177 * group.width, group.minY + 0.00861 * group.height))
        bezier86Path.addLineToPoint(CGPointMake(group.minX + 0.36377 * group.width, group.minY + 0.63805 * group.height))
        bezier86Path.addLineToPoint(CGPointMake(group.minX + 0.49593 * group.width, group.minY + 0.66389 * group.height))
        bezier86Path.addLineToPoint(CGPointMake(group.minX + 0.49593 * group.width, group.minY + 0.66389 * group.height))
        bezier86Path.closePath()
        bezier86Path.miterLimit = 4;
        
        bezier86Path.usesEvenOddFillRule = true;
        
        fillColor.setFill()
        bezier86Path.fill()
    }
}
~~~

Then, subclass `DefaultIconLibrary` and override `drawMethodForIcon` to return the new draw method for the `share` identifier (full list of available identifiers in the [`DefaultIconLibrary` sources](https://github.com/Wakup/Wakup-iOS-SDK/blob/master/Wakup/DefaultIconLibrary.swift))

~~~swift
class CustomIconLibrary: DefaultIconLibrary {
    override func drawMethodForIcon(iconIdentifier iconIdentifier: String) -> (drawMethod: IconDrawMethod, aspectRatio: CGFloat) {
        switch iconIdentifier {
        case "share":
            // Replace share icon with a paper plane
            return (CustomDrawMethods.drawPaperPlane, 88/87)
        default:
            // For any other method, return default draw method
            return super.drawMethodForIcon(iconIdentifier: iconIdentifier)
        }
    }
}
~~~

Then, when setting up `WakupManager`, set the `iconLibrary` property of `WakupOptions` to an instance of your new `CustomIconLibrary` (or the name you just gave it):


Run the App and you'll see your new icon, pixel perfect regardless the size and colored as you wish:

[![](http://imgur.com/JcCkce9l.png)](http://imgur.com/JcCkce9.png)


### Adding additional languages or replacing strings

Addint additional languages or replacing strings in an already existing language is very easy. Wakup SDK will find strings in a `Wakup.strings` file for the current language or fall back to embedded SDK strings if the file or the specific string is not found.

Copy [`Wakup.strings`](https://github.com/Wakup/Wakup-iOS-SDK/blob/master/Wakup/Wakup.strings) file from the SDK sources into your project. You can now replace the strings that you want and internationalize that file to your supported languages.