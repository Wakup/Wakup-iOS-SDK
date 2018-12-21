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

#### Setting user alias

To report the user alias (or user identifier) to the server, you can use the `setAlias` method.

~~~swift
WakupManager.manager.setAlias("example@mycompany.com".lowercased())
~~~

User aliases are case sensitive by default. If your aliases are case insensitive, they can be lower-cased to prevent case sensitivity issues.

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

[![](https://i.imgur.com/lSOAScDm.png)](https://i.imgur.com/lSOAScD.png) [![](https://i.imgur.com/Enc6IDBm.png)](https://i.imgur.com/Enc6IDB.png) [![](https://i.imgur.com/j9h9HZXm.png)](https://i.imgur.com/j9h9HZX.png) [![](https://i.imgur.com/lJvMTMFm.png)](https://i.imgur.com/lJvMTMF.png)

Most application colors, fonts and icons are easily customizable. If not customized, they will appear with the default look&feel of Wakup.


### Customize colors

Wakup SDK provides some convenience methods for configuring the appearance using `WakupAppearance` class. For fine tuning, most component colors are configurable using `UIAppearance` proxies, the same way native components are customized. This customization must be applied before presenting any Wakup controller.

#### Main and secondary tint colors

In order to make color customization easier, Wakup provides a convenience method that change the color of the entire application using a main tint color and an optional secondary tint color.

It will use derived colors (darker or lighter versions of the same color) to tint the application. If the color is light, a darker color will be used as contrast, and the opposite if it's a dark color. This contrast color can also be passed as parameter.

For example, this call:

~~~swift
WakupManager.appearance.setTint(mainColor: UIColor(fromHexString: "#5788a9"))
~~~


Would result in the following tinted result:

[![](https://i.imgur.com/OEeP8WOm.png)](https://i.imgur.com/OEeP8WO.png)
[![](https://i.imgur.com/MSF2EdRm.png)](https://i.imgur.com/MSF2EdR.png)

You can then configure components one by one if required.

#### Navigation bar

Navigation bar can be customized using `UINavigationBar` appearance proxy like any other iOS application. Icons and buttons will take the navigation bar `tintColor` property for tinting themselves.

[![](https://i.imgur.com/ywguOtAl.png)](https://i.imgur.com/ywguOtA.png)

~~~swift
let navBarColor = UIColor(red:0.26, green:0.07, blue:0.25, alpha:1)
let tintColor = UIColor(red:0.56, green:0.38, blue:0.57, alpha:1)

// Using convenience method
WakupManager.appearance.setNavigationBarTint(navBarColor: navBarColor, tintColor: tintColor)

// Using UIAppearance proxy
UINavigationBar.appearance().barTintColor = navBarColor
UINavigationBar.appearance().tintColor = tintColor
UINavigationBar.appearance().titleTextAttributes = [
    NSAttributedStringKey.foregroundColor: tintColor
]
NavBarIconView.appearance().iconColor = tintColor
~~~


#### Category and company filter bar

The category and company filter located at the top of the main scene view can be customized by using appearance proxies for the different elements. For customizing the background scroll view colors use `CategoryFilterView` and `CompanyFilterView` classes. Category and company buttons can be customized using the `CategoryFilterButton` and `CompanyFilterButton` and lastly, the small selection indicator can be customized using `CompanyFilterIndicatorView`.

[![](https://i.imgur.com/e6DTAzj.png)](https://i.imgur.com/e6DTAzj.png)

~~~swift
let backgroundColor = UIColor(red:0.26, green:0.15, blue:0.26, alpha:1)
let buttonColor = UIColor(red:0.56, green:0.38, blue:0.57, alpha:1)
    
// Using convenience method
WakupManager.appearance.setCategoryFilterTint(backgroundColor: backgroundColor, buttonColor: buttonColor)
    
// Using UIAppearance proxy
CategoryFilterButton.appearance().setTitleColor(buttonColor, for: [])
CategoryFilterButton.appearance().setTitleColor(.white, for: .selected)
CategoryFilterView.appearance().backgroundColor = backgroundColor
CompanyFilterIndicatorView.appearance().iconColor = backgroundColor
CompanyFilterView.appearance().backgroundColor = .white
~~~



#### Offer views

Offer cascade views can be customized using `CollectionViewCell` appearance proxy, in addition to the `DiscountTagView` that modifies both the list and the detail green discount tag.

[![](https://i.imgur.com/rsyNPGZl.png)](https://i.imgur.com/rsyNPGZ.png)


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
// Using convenience method
WakupManager.appearance.setDiscountTagTint(tagColor)

// Using UIAppearance proxy
DiscountTagView.appearance().backgroundColor = tagColor
DiscountTagView.appearance().labelColor = .white
~~~



#### Offer quick actions

Quick actions appear when a offer view is pressed for a few seconds. They can be customized using `ContextItemView` appearance proxy.

[![](https://i.imgur.com/PDJIE2ql.png)](https://i.imgur.com/PDJIE2q.png)

~~~swift
let quickActionColor = UIColor(red:0.56, green:0.39, blue:0.56, alpha:1)
let quickActionHighlightedColor = UIColor(red:0.7, green:0.42, blue:0.71, alpha:1)

// Using convenience method
WakupManager.appearance.setQuickActionsTint(quickActionColor, secondaryColor: quickActionHighlightedColor)

// Using UIAppearance proxy
ContextItemView.appearance().backgroundColor = quickActionColor
ContextItemView.appearance().highlightedBackgroundColor = quickActionHighlightedColor
ContextItemView.appearance().iconColor = UIColor.whiteColor()
ContextItemView.appearance().highlightedIconColor = UIColor.whiteColor()
ContextItemView.appearance().borderColor = UIColor.whiteColor()
~~~



#### Offer details

Offer details view can be customized using `CouponDetailHeaderView` appearance proxy. The green tag can be customized using `DiscountTagView` and shares appearance with the main offer view described above.

[![](https://i.imgur.com/CIh11Acl.png)](https://i.imgur.com/CIh11Ac.png)

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
// Using convenience method
WakupManager.appearance.setDiscountTagTint(tagColor)

// Using UIAppearance proxy
DiscountTagView.appearance().backgroundColor = tagColor
DiscountTagView.appearance().labelColor = .white
~~~





#### Offer action buttons

Offer action buttons appear below the offer details and can be customized using the `CouponActionButton` appearance proxy.

[![](https://i.imgur.com/b5AJ67il.png)](https://i.imgur.com/b5AJ67i.png)

~~~swift
let actionColor = UIColor(red:0.56, green:0.38, blue:0.57, alpha:1)

// Using convenience method
WakupManager.appearance.setOfferActionButtonsTint(secondaryColor)

// Using UIAppearance proxy
CouponActionButton.appearance().iconColor = actionColor
CouponActionButton.appearance().highlightedBackgroundColor = actionColor
CouponActionButton.appearance().setTitleColor(actionColor, for: [])
CouponActionButton.appearance().normalBorderColor = actionColor
~~~


#### Offer tag cloud

Tag cloud appearance can be customized using `WakupTagListView` appearance proxy:

[![](https://i.imgur.com/tISlQgQl.png)](https://i.imgur.com/tISlQgQ.png)

~~~swift
let darkColor = UIColor(red:0.26, green:0.07, blue:0.25, alpha:1)
let lightColor = UIColor(red:0.56, green:0.38, blue:0.57, alpha:1)

// Using convenience method        
WakupManager.appearance.setTagListTint(tintColor)

// Using UIAppearance proxy
WakupTagListView.appearance().tagBackgroundColor = lightColor
WakupTagListView.appearance().tagHighlightedBackgroundColor = darkColor
WakupTagListView.appearance().wakupBorderColor = darkColor
~~~


The tag list view can be hidden by setting the `hideTagsView` property of the `CouponDetailHeadersView` appearance proxy to `false`:

~~~swift
// Disable tags view in offer details
CouponDetailHeaderView.appearance().hideTagsView = false
~~~


#### Offer finder

Offer finder allows customization of filter icons through `SearchFilterButton` appearance proxy and result cells using `SearchResultCell`.

[![](https://i.imgur.com/NBH4Xs2l.png)](https://i.imgur.com/NBH4Xs2.png)

~~~swift
let searchButtonColor = UIColor(red:0.56, green:0.38, blue:0.57, alpha:1)

// Using convenience method        
WakupManager.appearance.setSearchTint(searchButtonColor)

// Using UIAppearance proxy
SearchFilterButton.appearance().iconColor = searchButtonColor
SearchFilterButton.appearance().highlightedBackgroundColor = searchButtonColor
SearchFilterButton.appearance().setTitleColor(searchButtonColor, for: [])
SearchFilterButton.appearance().normalBorderColor = searchButtonColor
    
SearchResultCell.appearance().iconColor = searchButtonColor
~~~

-

Category shortcuts can be replaced using `searchCategories` property of `WakupOptions` when configuring `WakupManager`:

~~~swift
let options = WakupOptions()
options.searchCategories = [
    OfferCategory(title: "Food", icon: "restaurant", associatedTags: ["restaurants"]),
    OfferCategory(title: "Shopping", icon: "shopping", associatedTags: ["shopping"]),
    OfferCategory(title: "Services", icon: "services", associatedTags: ["services"])
]

WakupManager.manager.setup("YOUR API KEY", options: options)
~~~

Will render this:

[![](https://i.imgur.com/qhJMlfJl.png)](https://i.imgur.com/qhJMlfJ.png)

Button titles can be internationalized using `NSLocalizedString`. Make sure to check  the length of the title to avoid render issues.

To remove category shortcuts, simply set `searchCategories` to `nil`:

~~~swift
let options = WakupOptions()
options.searchCategories = nil

WakupManager.manager.setup("YOUR API KEY", options: options)
~~~

#### Offer map

Offer map view allows customization of map pin icons and colors using `CouponAnnotationView` appearance proxy. Icons and colors are assigned based on offer tags. You can associate more than one tag to each group. You can also declare an empty tag group for offers not matching any previous tag:

[![](https://i.imgur.com/bCTSODDl.png)](https://i.imgur.com/bCTSODD.png)

~~~swift
let restaurantCategoryColor: UIColor = UIColor(red: 0.660, green: 0.133, blue: 0.159, alpha: 1.000)
let leisureCategoryColor: UIColor = UIColor(red: 0.201, green: 0.310, blue: 0.550, alpha: 1.000)
let servicesCategoryColor: UIColor = UIColor(red: 0.803, green: 0.341, blue: 0.092, alpha: 1.000)
let shoppingCategoryColor: UIColor = UIColor(red: 0.321, green: 0.498, blue: 0.190, alpha: 1.000)

CouponAnnotationView.appearance().mapPinSize = CGSize(width: 46, height: 60)
CouponAnnotationView.appearance().iconAndColorForTags = [
    ColorForTags(tags: ["restaurants", "food"], mapIcon: "map-restaurant-pin", color: restaurantCategoryColor),
    ColorForTags(tags: ["leisure", "cinema"], mapIcon: "map-leisure-pin", color: leisureCategoryColor),
    ColorForTags(tags: ["services"], mapIcon: "map-services-pin", color: servicesCategoryColor),
    ColorForTags(tags: ["shopping"], mapIcon: "map-shopping-pin", color: shoppingCategoryColor),
    ColorForTags(tags: [], mapIcon: "map-pin", color: UIColor.darkGrayColor()) // Empty tag list for default pin and color
]
~~~


### Customize fonts

Most fonts of the Wakup views can be customized using the same `UIAppearance` proxies that are used for color customization. Take into account that font size has to be explicitly specified and some labels have minimum font scale to avoid word clipping.

This example shows how to replace most of the application fonts with the [Aller family](http://www.fontsquirrel.com/fonts/aller) fonts:

~~~swift
// Navigation bar
UINavigationBar.appearance().titleTextAttributes = [
    NSAttributedStringKey.font: UIFont(name: "Aller", size: 18)!
]

// Top menu and search bar
TopMenuButton.appearance().titleFont = UIFont(name: "Aller-Light", size: 14)
SearchFilterButton.appearance().titleFont = UIFont(name: "Aller", size: 10)

// Collection view cells
CouponCollectionViewCell.appearance().storeNameFont = UIFont(name: "Aller-Bold", size: 17)
CouponCollectionViewCell.appearance().descriptionTextFont = UIFont(name: "Aller-Italic", size: 15)
CouponCollectionViewCell.appearance().distanceFont = UIFont(name: "Aller-Italic", size: 11)
CouponCollectionViewCell.appearance().expirationFont = UIFont(name: "Aller-Italic", size: 11)
DiscountTagView.appearance().labelFont = UIFont(name: "AllerDisplay", size: 17)

// Offer details
CouponActionButton.appearance().titleFont = UIFont(name: "Aller", size: 10)
CouponDetailHeaderView.appearance().companyNameFont = UIFont(name: "Aller", size: 18)
CouponDetailHeaderView.appearance().storeAddressFont = UIFont(name: "Aller-LightItalic", size: 14)
CouponDetailHeaderView.appearance().storeDistanceFont = UIFont(name: "Aller-Italic", size: 11)
CouponDetailHeaderView.appearance().couponNameFont = UIFont(name: "Aller", size: 19)
CouponDetailHeaderView.appearance().couponDescriptionFont = UIFont(name: "Aller", size: 14)
CouponDetailHeaderView.appearance().expirationFont = UIFont(name: "Aller-Italic", size: 13)

if #available(iOS 9.0, *) {
    let headerTitle = UILabel.appearanceWhenContainedInInstancesOfClasses([UITableViewHeaderFooterView.self])
    headerTitle.font = UIFont(name: "Aller", size: 16)
    
    let searchBarTextField = UITextField.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self])
    searchBarTextField.defaultTextAttributes = [
        NSFontAttributeName: UIFont(name: "Aller", size: 14)!
    ]
}
~~~


### Customize icons

Wakup SDK uses vectorial CoreGraphics methods to draw icons that allow resizing and tinting icons using native iOS functionality. All Wakup icons are packed in a 'icon library', that can be extended (or completely overriden) to replace the application icons.

To achieve it, simply subclass `DefaultIconLibrary` class and return the new draw method of the desired icons.

For example, we want to override the default share icon:

![](https://i.imgur.com/cN8ls2h.png)

with a new paper plane version:

![](https://i.imgur.com/FerbLaJ.png)


#### Using vectorial icons with PaintCode

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

#### Configure Icon library

Then, subclass `DefaultIconLibrary` and override `drawMethodForIcon` to return the new draw method for the `share` identifier (full list of available identifiers in the [`DefaultIconLibrary` sources](https://github.com/Wakup/Wakup-iOS-SDK/blob/master/Wakup/DefaultIconLibrary.swift))

~~~swift
class CustomIconLibrary: DefaultIconLibrary {
    override func drawMethodForIcon(iconIdentifier: String) -> (drawMethod: IconDrawMethod, aspectRatio: CGFloat) {
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

~~~swift
let wakupOptions = WakupOptions()
wakupOptions.iconLibrary = CustomIconLibrary()
WakupManager.manager.setup("YOUR_API_TOKEN_HERE", options: wakupOptions)
~~~

Run the App and you'll see your new icon, pixel perfect regardless the size and colored as you wish:

[![](https://i.imgur.com/JcCkce9l.png)](https://i.imgur.com/JcCkce9.png)


#### Using non-vectorial images

Although highly recommended, converting images to vectorial format is not always available. In this case, you can fall back to using standard `UIImage` images. It's recommended that you use transparent background PNG files.

They are configured exactly like vectorial code-drawn icons in your implementation of `IconLibrary`, with the help of `CodeIconLibrary.drawMethodForImage` utility method:

~~~swift
class CustomIconLibrary: DefaultIconLibrary {
    override func drawMethodForIcon(iconIdentifier: String) -> (drawMethod: IconDrawMethod, aspectRatio: CGFloat) {
        switch iconIdentifier {
        case "share":
            // Replace share icon with a paper plane
            return CodeIconLibrary.drawMethodForImage(UIImage(named: "paper_plane.png")!)
        default:
            // For any other method, return default draw method
            return super.drawMethodForIcon(iconIdentifier: iconIdentifier)
        }
    }
}
~~~

The provided image will be colored using the designated tint color for that icon.
If the logo should not be tinted (for example, multi-color company logos), make sure to set the `tinted` parameter of `drawMethodForImage` to `false`:

~~~
return CodeIconLibrary.drawMethodForImage(UIImage(named: "my-logo")!, tinted: false)
~~~

Vectorial and non-vectorial images can be mixed in the same IconLibrary. But for better results, use vectorial images whenver possible.

### Adding additional languages or replacing strings

Adding additional languages or replacing strings in an already existing language is very easy. Wakup SDK will find strings in a `Wakup.strings` file for the current language or fall back to embedded SDK strings if the file or the specific string is not found.

Copy [`Wakup.strings`](https://github.com/Wakup/Wakup-iOS-SDK/blob/master/Wakup/Wakup.strings) file from the SDK sources into your project. You can now replace the strings that you want and internationalize that file to your supported languages.