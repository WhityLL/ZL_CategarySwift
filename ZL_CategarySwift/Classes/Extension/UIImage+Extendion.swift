//
//  UIImage+Extendion.swift
//  TodaysNews_Swift4
//
//  Created by LiuLei on 2017/12/19.
//  Copyright © 2017年 LiuLei. All rights reserved.
//

import Foundation
import UIKit

public extension UIImage {
    
    static func zl_getImageFromBunble(imageBundle: Bundle, imgName: String) -> UIImage{
        var name = imgName + "@2x"
        guard let imagePath = imageBundle.path(forResource: name, ofType: "png") else {
            name = name.replacingOccurrences(of: "@2x", with: "")
            return UIImage.init(named: name)!
        }
        return UIImage.init(contentsOfFile: imagePath)!
    }
    
    static func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    /// color 转 image
    static func image(with color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(origin: CGPoint.zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 渐变色转 image
    static func image(with gradientColors: [CGColor], start startPoint: CGPoint, end endPoint: CGPoint) -> UIImage? {
        let size = CGSize(width: max(startPoint.x, endPoint.x), height:  max(startPoint.y, endPoint.y))
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = gradientColors as CFArray
        guard let context = UIGraphicsGetCurrentContext(),
            let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: nil) else {
                UIGraphicsEndImageContext()
                return nil
        }
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: 0))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// UIView 转 UIImage
    static func image(with view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        view.layer.render(in: context)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// UIView 中指定位置取圆角
    /// - parameter view: 视图
    /// - parameter rect: 矩形框
    /// - parameter corner: 是否圆角
    static func image(with view: UIView, rect: CGRect, corner: Bool = false) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.size, true, 0)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        if corner {
            context.addEllipse(in: rect)
        } else {
            let pathRef = CGMutablePath()
            pathRef.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
            pathRef.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            pathRef.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            pathRef.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            context.addPath(pathRef)
        }
        context.clip()
        view.draw(view.bounds)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// 生成二维码
    static func imageQRCode(with url: String, to width: CGFloat) -> UIImage? {
        guard let filter = CIFilter(name: "CIQRCodeGenerator"), let data = url.data(using: .utf8) else { return nil }
        filter.setDefaults()
        filter.setValue(data, forKey: "inputMessage")
        guard let ciImage = filter.outputImage else { return nil }
        // 生成高清的UIImage
        let extent = ciImage.extent.integral
        let scale = min(width/extent.width, width/extent.height)
        let width = Int(extent.width * scale)
        let height = Int(extent.height * scale)
        let cs = CGColorSpaceCreateDeviceGray()
        guard let bitmapRef = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: 0) else { return nil }
        let context = CIContext(options: nil)
        guard let bitmapImage = context.createCGImage(ciImage, from: extent) else { return nil }
        bitmapRef.interpolationQuality = CGInterpolationQuality.none
        bitmapRef.scaleBy(x: scale, y: scale)
        bitmapRef.draw(bitmapImage, in: extent)
        guard let cgImage = bitmapRef.makeImage() else { return nil }
        return UIImage(cgImage: cgImage)
    }
    
    /// 生成圆角图片
    func withCornerRadius(_ cornerRadius: CGFloat, size: CGSize, backgroundColor: UIColor = UIColor.white) -> UIImage? {
        guard cornerRadius > 0 else {
            return self
        }
        let rect = CGRect(origin: CGPoint(), size: size)
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        backgroundColor.setFill()
        UIRectFill(rect)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        path.addClip()
        path.stroke()
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// Creates and returns a image object that has the same image space and component values as the receiver, but has the specified alpha component.
    /// - parameter alpha: The opacity value of the new color object, specified as a value from 0.0 to 1.0. Alpha values below 0.0 are interpreted as 0.0, and values above 1.0 are interpreted as 1.0
    func withAlphaComponent(_ alpha: CGFloat) -> UIImage? {
        guard alpha < 1 else {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0)
        guard let context = UIGraphicsGetCurrentContext(), let cgImage = self.cgImage else {
            UIGraphicsEndImageContext()
            return nil
        }
        let area = CGRect(origin: CGPoint(), size: self.size)
        context.scaleBy(x: 1, y: -1)
        context.translateBy(x: 0, y: -area.size.height)
        context.setBlendMode(CGBlendMode.multiply)
        context.setAlpha(alpha)
        context.draw(cgImage, in: area)
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// 本地图片预解码加载 Downsampling large images for display at smaller size
    static func downsample(imageAt imageURL: URL, to pointSize: CGSize, scale: CGFloat = UIScreen.main.scale) -> UIImage? {
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions) else { return nil }
        let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
        let downsampleOptions = [kCGImageSourceCreateThumbnailFromImageAlways: true,
                                 kCGImageSourceShouldCacheImmediately: true,
                                 kCGImageSourceCreateThumbnailWithTransform: true,
                                 kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels] as CFDictionary
        guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
            return nil
        }
        return UIImage(cgImage: downsampledImage)
    }
    
    /// 图片压缩
    func compress(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        self.draw(in: CGRect(origin: CGPoint(), size: size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    
    /// 压缩比例
    private func resizeImage(originalImg:UIImage) -> UIImage{
        
        //prepare constants
        let width = originalImg.size.width
        let height = originalImg.size.height
        let scale = width/height
        
        var sizeChange = CGSize()
        
        if width <= 1280 && height <= 1280{ //a，图片宽或者高均小于或等于1280时图片尺寸保持不变，不改变图片大小
            return originalImg
        }else if width > 1280 || height > 1280 {//b,宽或者高大于1280，但是图片宽度高度比小于或等于2，则将图片宽或者高取大的等比压缩至1280
            
            if scale <= 2 && scale >= 1 {
                let changedWidth:CGFloat = 1280
                let changedheight:CGFloat = changedWidth / scale
                sizeChange = CGSize(width: changedWidth, height: changedheight)
                
            }else if scale >= 0.5 && scale <= 1 {
                
                let changedheight:CGFloat = 1280
                let changedWidth:CGFloat = changedheight * scale
                sizeChange = CGSize(width: changedWidth, height: changedheight)
                
            }else if width > 1280 && height > 1280 {//宽以及高均大于1280，但是图片宽高比大于2时，则宽或者高取小的等比压缩至1280
                
                if scale > 2 {//高的值比较小
                    
                    let changedheight:CGFloat = 1280
                    let changedWidth:CGFloat = changedheight * scale
                    sizeChange = CGSize(width: changedWidth, height: changedheight)
                    
                }else if scale < 0.5{//宽的值比较小
                    
                    let changedWidth:CGFloat = 1280
                    let changedheight:CGFloat = changedWidth / scale
                    sizeChange = CGSize(width: changedWidth, height: changedheight)
                    
                }
            }else {//d, 宽或者高，只有一个大于1280，并且宽高比超过2，不改变图片大小
                return originalImg
            }
        }
        
        UIGraphicsBeginImageContext(sizeChange)
        
        //draw resized image on Context
        originalImg.draw(in: CGRect.init(x: 0, y: 0, width: sizeChange.width, height: sizeChange.height))
        
        //create UIImage
        let resizedImg = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return resizedImg
        
    }
    
    /// 压缩图片到指定的大小
    ///
    /// - Parameters:
    ///   - image: compressImage
    ///   - maxLength: maxLength
    /// - Returns: return image
    static func compressImageQuality(_ image: UIImage, toByte maxLength: Int) -> UIImage {
        var compression: CGFloat = 1
        guard var data = image.jpegData(compressionQuality: compression),
            data.count > maxLength else { return image }
        print("Before compressing size, image size =", data.count / 1024, "KB")
        
        var max: CGFloat = 1
        var min: CGFloat = 0
        for _ in 0..<6 {
            compression = (max + min) / 2
            data = image.jpegData(compressionQuality: compression)!
            if CGFloat(data.count) < CGFloat(maxLength) * 0.9 {
                min = compression
            } else if data.count > maxLength {
                max = compression
            } else {
                break
            }
             print("In compressing size loop, image size =", data.count / 1024, "KB")
        }
         print("After compressing size loop, image size =", data.count / 1024, "KB")
        return UIImage(data: data)!
    }
}
