Pod::Spec.new do |s|

  # Meta data
  s.name         = "Wakup"
  s.version      = "0.1.0"
  s.summary      = "Wakup allows you to find offers near your location"
  s.homepage     = "http://wakup.net"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Yellow Pineapple" => "juan.cerro@101offers.co" }
  s.platform     = :ios
  s.ios.deployment_target = '8.0'
  s.source       = { :git => "https://github.com/*****/*****.git", :tag => "v#{s.version}" }

  # Source configuration
  s.source_files  = "Wakup/**/*.swift"
  s.resources = "Wakup/**/*.{png,jpeg,jpg,storyboard,xib,strings}"

  s.requires_arc = true

  # Dependencies

  # Background image load and cache
  s.dependency 'SDWebImage', '~> 3.7'

  # An easy-to-plug-in Contextual Menu for iOS inspired by Pinterest.
  s.dependency 'iOSContextualMenu', '~> 1.1'

  # A drop-in superclass category for showing empty datasets whenever the view has no content to display.
  s.dependency 'DZNEmptyDataSet', '~> 1.7'

  # SwiftyJSON makes it easy to deal with JSON data in Swift
  s.dependency 'SwiftyJSON', '~> 2.3'

  # Elegant HTTP Networking in Swift
  s.dependency 'Alamofire', '~> 3.1'

  # Delightful on-disk cache
  s.dependency 'AwesomeCache', '~> 2.0'

  # The waterfall (i.e., Pinterest-like) layout for UICollectionView.
  s.dependency 'CHTCollectionViewWaterfallLayout', '~> 0.9'

end