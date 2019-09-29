#
#  Be sure to run `pod spec lint ZL_CategarySwift.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "ZL_CategarySwift"
  s.version      = "0.0.1"
  s.summary      = "ZL_CategarySwift"
  s.description  = <<-DESC
                        ZL_CategarySwift
                   DESC
  s.homepage     = "https://github.com/WhityLL/ZL_CategarySwift"
  s.license      = "MIT"
  s.author             = { "Whity" => "liulei10luojia@163.com" }

  # ――― Platform
  s.platform = :ios
  s.ios.deployment_target = '9.0'
  
  # ――― Build settings
  s.requires_arc = true
  s.swift_version = '5.0'

  s.source  = { :git => "https://github.com/WhityLL/ZL_CategarySwift.git", :tag => "#{s.version}" }


  # ——— File patterns
  s.source_files  = "ZL_CategarySwift/Classes/**/*"

  # 1 ConmonUtils
  s.subspec 'ConmonUtils' do |conmonUtils|
    conmonUtils.source_files = "ZL_CategarySwift/Classes/ConmonUtils/*"
    spec.framework = 'CoreTelephony'
  end
  
  # 2 Extension
  s.subspec 'Extension' do |extension|
    extension.source_files = "ZL_CategarySwift/Classes/Extension/*"
    extension.dependency "MBProgressHUD"
    spec.dependency "Kingfisher", "~>4.10.1"
  end
  
  # 2 Macros
  s.subspec 'Macros' do |macros|
    extension.source_files = "ZL_CategarySwift/Classes/Macros/*"
  end
  
  s.framework = 'QuartzCore', 'CoreText'  , 'CoreGraphics', 'UIKit', 'Foundation', 'CFNetwork', 'CoreMotion'
  s.library = 'c++', 'z',"sqlite3.0"
end
