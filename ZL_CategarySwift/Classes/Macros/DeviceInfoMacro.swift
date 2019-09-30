//
//  DeviceMacro.swift
//  TodayNew_Swift
//
//  Created by LiuLei on 2018/10/8.
//  Copyright © 2018年 LiuLei. All rights reserved.
//

import Foundation
import UIKit

// MARK: ========= DeviceInfo ==========
/// 屏幕的宽
public let SCREEN_WIDTH = UIScreen.main.bounds.size.width
/// 屏幕的高
public let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

/// iPhone4
public let isIphone4 = SCREEN_HEIGHT  < 568 ? true : false
/// iPhone 5
public let isIphone5 = SCREEN_HEIGHT  == 568 ? true : false
/// iPhone 6
public let isIphone6 = SCREEN_HEIGHT  == 667 ? true : false
/// iphone 6P
public let isIphone6P = SCREEN_HEIGHT == 736 ? true : false
/// iphone X_XS
public let isIphoneX_XS = SCREEN_HEIGHT == 812 ? true : false
/// iphone XR_XSMax
public let isIphoneXR_XSMax = SCREEN_HEIGHT == 896 ? true : false
/// 全面屏
public let isFullScreen = (isIphoneX_XS || isIphoneXR_XSMax)

public let kStatusBarHeight : CGFloat = isFullScreen ? 44 : 20
public let kNavigationBarHeight : CGFloat =  44
public let kStatusBarAndNavigationBarHeight : CGFloat = isFullScreen ? 88 : 64
public let kBottomSafeMargin : CGFloat = isFullScreen ? 34 : 0
public let kTabbarHeight : CGFloat = isFullScreen ? 49 + 34 : 49

// MARK: ========= 屏幕适配 ==========
public let  kScaleX : Float = Float(SCREEN_WIDTH / 375.0)
public let  kScaleY : Float = Float(SCREEN_HEIGHT / 667.0)

///适配后的宽度
public func AdaptedWidth(w : Float) -> Float {
    return ceilf(w * kScaleX)
}
///适配后的高度
public func AdaptedHeight(h : Float) -> Float {
    return ceilf(h * kScaleY)
}

// MARK: ========= app信息 ==========
public struct AppInfo {
    
    public static let infoDictionary = Bundle.main.infoDictionary
    
    /// App 名称
    public static let appDisplayName: String = Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String
    
    /// Bundle Identifier
    public static let bundleIdentifier:String = Bundle.main.bundleIdentifier!
    
    /// App 版本号
    public static let appVersion:String = Bundle.main.infoDictionary! ["CFBundleShortVersionString"] as! String
    
    /// Bulid 版本号
    public static let buildVersion : String = Bundle.main.infoDictionary! ["CFBundleVersion"] as! String
    
    /// iOS系统 版本
    public static let iOSVersion:String = UIDevice.current.systemVersion
    
    /// 设备 udid
    public static let identifierNumber = UIDevice.current.identifierForVendor
    
    /// 系统名称  e.g. @"iOS"
    public static let systemName = UIDevice.current.systemName
    
    /// 设备名称 e.g. @"iPhone", @"iPod touch"
    public static let model = UIDevice.current.model
    
    /// 设备区域化型号
    public static let localizedModel = UIDevice.current.localizedModel
}

public let CurrentLanguage = NSLocale.preferredLanguages[0]

/// 获取启动图
public func getProjectLaunchImage() -> UIImage? {
    let viewSize = UIScreen.main.bounds.size
    var viewOrientation: String = ""
    if UIApplication.shared.statusBarOrientation == .portraitUpsideDown || UIApplication.shared.statusBarOrientation == .portrait {
        viewOrientation = "Portrait"
    } else {
        viewOrientation = "Landscape"
    }
    

    guard let tmpLaunchImages = Bundle.main.infoDictionary!["UILaunchImages"] as? [Any]  else {
        return nil
    }

    var launchImageName = ""
    for dict in tmpLaunchImages {
        if let someDict = dict as? [String: Any] {
            let imageSize = NSCoder.cgSize(for: someDict["UILaunchImageSize"] as! String)
            if __CGSizeEqualToSize(viewSize, imageSize) && viewOrientation == someDict["UILaunchImageOrientation"] as! String {
                launchImageName = someDict["UILaunchImageName"] as! String
            }
        }
    }
    return UIImage(named: launchImageName)!
}
