//
//  PhotoKitManager.swift
//  LiShePlus
//
//  Created by lishe on 2019/5/9.
//  Copyright © 2019 lishe. All rights reserved.
//

import UIKit
import TZImagePickerController

public typealias PhotoKitClosure = (_ img: UIImage) -> ()

public class PhotoKitManager: NSObject {
    
    public static let shared = PhotoKitManager()
    
    private var parentVC: UIViewController?
    public var resultBlock: PhotoKitClosure?
    public var needCrop: Bool = false
    
    lazy public var imagePiker: UIImagePickerController = {
        let imagePiker: UIImagePickerController  = UIImagePickerController()
        imagePiker.delegate = self
        imagePiker.allowsEditing = true
        imagePiker.sourceType = .camera
        return imagePiker
    }()
    
    
    /// 初始化选择照片
    /// - Parameter parentVC: parentVC
    /// - Parameter needCrop: 是否需要裁剪
    /// - Parameter resultBlock: 返回 UIImage
    public func zl_getPhoto(parentVC :UIViewController , needCrop: Bool , resultBlock: @escaping PhotoKitClosure){
        self.parentVC = parentVC
        self.resultBlock = resultBlock
        self.needCrop = needCrop
        
        let alertSheet = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        alertSheet.addAction(UIAlertAction.init(title: "拍照", style: .default, handler: { (photoAction) in
            self.takePhoto()
        }))
        alertSheet.addAction(UIAlertAction.init(title: "相册", style: .default, handler: { (photoAction) in
            self.assetChoose()
        }))
        alertSheet.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
        parentVC.present(alertSheet, animated: true, completion: nil)
    }
    
    func assetChoose() {
        let vc = TZImagePickerController.init(maxImagesCount: 1, columnNumber: 4, delegate: self, pushPhotoPickerVc: true)!
        vc.allowCrop = true
        vc.allowTakeVideo = false
        vc.allowPickingVideo = false
        vc.allowPickingGif = false
        vc.showSelectBtn = false
        vc.allowTakePicture = false
        if self.needCrop == true {
            vc.cropRect = CGRect.init(x: 0, y: (SCREEN_HEIGHT - SCREEN_WIDTH) / 2 , width: SCREEN_WIDTH, height: SCREEN_WIDTH)
        }else{
            vc.cropRect = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        }
        vc.didFinishPickingPhotosHandle = { ( photos , assets, isSelectOriginalPhoto) in
            if let image = photos?[0] {
                self.resultBlock?(image)
            }
        }
        vc.modalPresentationStyle = .fullScreen
        OperationQueue.main.addOperation({ // 不加这一句 在iOS11 crash
            self.parentVC?.present(vc, animated: true, completion: nil)
        })
    }
    
    func takePhoto() {
        AuthorizeUtils.zl_checkCamera {(granted) in
            if granted {
                OperationQueue.main.addOperation({ // 不加这一句 在iOS11 crash
                    self.parentVC?.present(self.imagePiker, animated: true, completion: nil)
                })
            }
        }
    }
    
    
}

extension PhotoKitManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.parentVC?.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if imagePiker.allowsEditing{
            // 获取选择或者拍摄的照片
            if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                self.resultBlock?(image)
            }
        }else{
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                self.resultBlock?(image)
            }
        }
        
    }
}

extension PhotoKitManager: TZImagePickerControllerDelegate{
    public func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingGifImage animatedImage: UIImage!, sourceAssets asset: PHAsset!) {
           
       }
       
    public func tz_imagePickerControllerDidCancel(_ picker: TZImagePickerController!) {
           
    }
}
