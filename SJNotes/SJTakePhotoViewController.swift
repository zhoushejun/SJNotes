//
//  SJTakePhotoViewController.swift
//  SJNotes
//
//  Created by shejun.zhou on 15/6/16.
//  Copyright (c) 2015年 shejun.zhou. All rights reserved.
//

/**
 @file      SJTakePhotoViewController.swift
 @abstract  拍照
 @author    shejun.zhou
 @version   1.0 2015/6/16 Creation
 */

import UIKit
import AVFoundation

class SJTakePhotoViewController: UIViewController , UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var imagePickerController:UIImagePickerController!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.takePhotoButtonAction()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // mark - UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        imagePickerController.dismissViewControllerAnimated(true, completion:nil)
        self.imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    
    // button action
    
    func takePhotoButtonAction() {
        if isAuth() {
            if nil == imagePickerController{
                imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self;
                imagePickerController.sourceType = .Camera
            }
            presentViewController(imagePickerController, animated: true, completion: nil)
        }
    }
    
    // private func
    
    func isAuth() -> Bool{
        var error:NSError?
        var captureDevice:AVCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        var deviceInput: AnyObject! = AVCaptureDeviceInput.deviceInputWithDevice(captureDevice, error: &error)
        if error != nil {
            var alertView:UIAlertView = UIAlertView(title: "无法使用相机", message: "请在iPhone的”设置-隐私-相机“中允许访问相机", delegate: nil, cancelButtonTitle: "确定")
            alertView.show()
            return false
        }
        return true
    }
}
