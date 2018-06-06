#  Be sure to run `pod spec lint OneSky.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "OneSky"
  s.version      = "0.0.1"
  s.summary      = "locale framework by OneSky"
  s.homepage     = "Oneskyapp.com"
  s.license      = "MIT"
  s.author       = { "Daniil Vorobyev" => "daniil.vorobyev@umbrella-web.com" }
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/onesky/onesky-sdk-ios.git" }
  s.ios.deployment_target = "10.0"
  #s.ios.vendored_frameworks = "OneSky.framework"
  s.ios.resource_bundle = { 'Resources' => 'OneSky/*.xcassets' }

  s.dependency "Siesta"
  s.dependency "Ably"

  s.source_files = "OneSky/*.swift", "OneSky/API/*.swift", "OneSky/API/Delegates/*.swift", "OneSky/API/Manager/*.swift", "OneSky/API/Services/*.swift", "OneSky/API/Structures/*.swift", "OneSky/API/Manager/ResponseTransformers/*.swift", "OneSky/API/Controller/*.swift", "OneSky/API/Controller/SelectCell/*.swift"


end