#
#  Be sure to run `pod spec lint ZL_CategarySwift.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

    s.name         = "ZL_CategarySwift"
    s.version      = "0.0.43"
    s.summary      = "ZL_CategarySwift"
    s.description  = <<-DESC
                        常用的swift 方法 分类 功能封装
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
    # s.source_files  = "ZL_CategarySwift/Classes/**/*"
    
    # 是否包含静态库框架（注意：不能写在subspec子模块中）
    s.static_framework = true

    #  Macros
    s.subspec 'Macros' do |macros|
        macros.source_files = "ZL_CategarySwift/Classes/Macros/*"
    end

    #  Extension （常用的扩展）
    s.subspec 'Extension' do |extension|
        extension.source_files = "ZL_CategarySwift/Classes/Extension/*"
        extension.dependency "MBProgressHUD"
        extension.dependency "Kingfisher", "~>4.10.1"
    end
    
    #  ConmonUtils （授权、正则）
    # 并且要添加依赖（注意写法）'ZL_CategarySwift/Extension'
    s.subspec 'ConmonUtils' do |conmonUtils|
        conmonUtils.source_files = "ZL_CategarySwift/Classes/ConmonUtils/*"
        conmonUtils.dependency 'ZL_CategarySwift/Extension'
        conmonUtils.framework = 'CoreTelephony'
    end
    
    
    #  ZL_SysFunc
    s.subspec 'ZL_SysFunc' do |funcs|
        funcs.subspec 'AddressBook' do |ss|
           ss.source_files = "ZL_CategarySwift/Classes/ZL_SysFunc/AddressBook/*"
           ss.dependency 'ZL_CategarySwift/ConmonUtils'
        end
        
        funcs.subspec 'Location' do |ss|
           ss.source_files = "ZL_CategarySwift/Classes/ZL_SysFunc/Location/*"
           ss.dependency 'ZL_CategarySwift/ConmonUtils'
        end
        
        funcs.subspec 'Health' do |ss|
           ss.source_files = "ZL_CategarySwift/Classes/ZL_SysFunc/Health/*"
           ss.dependency 'ZL_CategarySwift/ConmonUtils'
        end
        
        funcs.subspec 'PhotoKit' do |ss|
           ss.source_files = "ZL_CategarySwift/Classes/ZL_SysFunc/PhotoKit/*"
           ss.dependency 'ZL_CategarySwift/ConmonUtils'
           ss.dependency 'ZL_CategarySwift/Macros'
           ss.dependency 'TZImagePickerController'
        end
        
        funcs.subspec 'QRCode' do |ss|
           ss.source_files = "ZL_CategarySwift/Classes/ZL_SysFunc/QRCode/Classes/*"
           ss.dependency 'ZL_CategarySwift/ConmonUtils'
           ss.dependency 'ZL_CategarySwift/Extension'
           ss.dependency 'ZL_CategarySwift/Macros'
           ss.resources = "ZL_CategarySwift/Classes/ZL_SysFunc/QRCode/QRCode.bundle"
        end
        
    end
    
    s.framework = 'QuartzCore', 'CoreText'  , 'CoreGraphics', 'UIKit', 'Foundation', 'CFNetwork', 'CoreMotion'
    s.library = 'c++', 'z',"sqlite3.0"
end
