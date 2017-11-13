source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

target 'Wakup' do

    # Background image load and cache
    pod 'SDWebImage', '~> 4.2'

    # An easy-to-plug-in Contextual Menu for iOS inspired by Pinterest.
    pod 'iOSContextualMenu', '~> 1.1'

    # A drop-in superclass category for showing empty datasets whenever the view has no content to display.
    pod 'DZNEmptyDataSet', '~> 1.8'

    # SwiftyJSON makes it easy to deal with JSON data in Swift
    pod 'SwiftyJSON', '~> 4.0'

    # Elegant HTTP Networking in Swift
    pod 'Alamofire', '~> 4.5'

    # The waterfall (i.e., Pinterest-like) layout for UICollectionView.
    pod 'CHTCollectionViewWaterfallLayout', '~> 0.9'

    # Simple and highly customizable tag list view
    pod 'TagListView', '1.3'

end

# Workaround until https://github.com/CocoaPods/CocoaPods/issues/5334 is fixed
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CONFIGURATION_BUILD_DIR'] = '$PODS_CONFIGURATION_BUILD_DIR'
        end
    end
end
