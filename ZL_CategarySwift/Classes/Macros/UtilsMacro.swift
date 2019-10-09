//
//  UtilsMacro.swift
//  TodayNew_Swift
//
//  Created by LiuLei on 2018/10/8.
//  Copyright © 2018年 LiuLei. All rights reserved.
//

import Foundation
import UIKit

/// RGBA的颜色设置
public func RGBAColor(r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
}

/// 随机色
public func ZLRandomColor() -> UIColor{
    let red = CGFloat(arc4random_uniform(255))/CGFloat(255.0)
    let green = CGFloat( arc4random_uniform(255))/CGFloat(255.0)
    let blue = CGFloat(arc4random_uniform(255))/CGFloat(255.0)
    return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
}

/**
 *  16进制 转 RGB
 */
public func HexColor(rgb:Int) -> UIColor {
    return UIColor(red: ((CGFloat)((rgb & 0xFF0000) >> 16)) / 255.0,
                   green: ((CGFloat)((rgb & 0xFF00) >> 8)) / 255.0,
                   blue: ((CGFloat)(rgb & 0xFF)) / 255.0,
                   alpha: 1.0)
}

///由角度转换弧度 (M_PI * (x) / 180.0)
public func DegreesToRadian(degree : Double) -> Double {
    return Double.pi * degree / 180.0
}

///由弧度转换角度  (radian * 180.0) / (M_PI)
public func RadianToDegrees(radian : Double) -> Double {
    return radian * 180.0 / Double.pi
}

// MARK: ========= 字体适配 ==========
///适配后的普通字体(系统)
public func AdaptedSystomFont(size : Float) -> UIFont {
    return UIFont.systemFont(ofSize: CGFloat(AdaptedWidth(w: size)))
}
///适配后的粗字体(系统)
public func AdaptedSystomBlodFont(size : Float) -> UIFont {
    return UIFont.boldSystemFont(ofSize: CGFloat(AdaptedWidth(w: size)))
}

///字体名
public let  CHINESE_FONT_NAME : String = "PingFangSC-Light"
public let  CHINESE_BLODFONT_NAME : String = "PingFangSC-Regular"

///适配后的普通字体
public func AdaptedCustomFont(size : Float) -> UIFont {
    if let font = UIFont.init(name: CHINESE_FONT_NAME, size: CGFloat(AdaptedWidth(w: size))) {
        return font
    }
    return UIFont.systemFont(ofSize: CGFloat(size))
    
}

///适配后的粗字体
public func AdaptedCustomBlodFont(size : Float) -> UIFont {
    if let font = UIFont.init(name: CHINESE_BLODFONT_NAME, size: CGFloat(AdaptedWidth(w: size))) {
        return font
    }
    return UIFont.boldSystemFont(ofSize: CGFloat(size))
}
