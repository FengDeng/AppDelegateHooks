#
#  Be sure to run `pod spec lint AppDelegateHooks.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|


  s.name         = "AppDelegateHooks"
  s.version      = "0.0.1"
  s.summary      = "Hook AppDelegate"


  s.homepage     = "https://github.com/FengDeng/AppDelegateHooks"

  s.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  s.author             = { "邓锋" => "704292743@qq.com" }

  s.platform     = :ios, "8.0"
  s.ios.deployment_target = '8.0'

  s.source       = { :git => "https://github.com/FengDeng/AppDelegateHooks.git", :tag => "#{s.version}" }

  s.module_name = 'AppDelegateHooks'
  s.swift_version = "5.0"
  s.source_files  = "AppDelegateHooks/Classes", "AppDelegateHooks/Classes/*.{swift,m}"


  s.dependency 'Aspects','~>1.4.1'

end
