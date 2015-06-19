//
//  SJQRCodeViewController.swift
//  SJNotes
//
//  Created by shejun.zhou on 15/6/16.
//  Copyright (c) 2015年 shejun.zhou. All rights reserved.
//

/**
@file      SJQRCodeViewController.swift
@abstract  二维码扫描
@author    shejun.zhou
@version   1.0 2015/6/16 Creation
*/

import UIKit
import AVFoundation

class SJQRCodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate {
    
//    @IBOutlet weak var labTip: UILabel!
//    @IBOutlet weak var btnQRCode: UIButton!
//    
    let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    let session = AVCaptureSession()
    var layer: AVCaptureVideoPreviewLayer?
    var codeView:UIView?
    
    @IBOutlet weak var labMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tappedQRCodeButtonAction()
        labMessage.text = "未检测到二维码/条形码"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    
    // mark: - AVCaptureMetadataOutputObjectsDelegate
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!){
        
        if metadataObjects == nil || metadataObjects.count <= 0{
            labMessage.text = "未检测到二维码/条形码"
            return
        }
        
        var metadataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        var stringValue:String?

        switch metadataObject.type {
            case AVMetadataObjectTypeEAN13Code:
                stringValue = metadataObject.stringValue
            case AVMetadataObjectTypeEAN8Code:
                stringValue = metadataObject.stringValue
            case AVMetadataObjectTypeCode128Code:
                stringValue = metadataObject.stringValue
            case AVMetadataObjectTypeQRCode:
                let barCodeObject = layer?.transformedMetadataObjectForMetadataObject(metadataObject as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
                codeView?.frame = barCodeObject.bounds;
                stringValue = metadataObject.stringValue
            default:
                stringValue = metadataObject.stringValue
        }

        session.stopRunning()
        println("code is \(stringValue)")
        
        var alertView = UIAlertView()
        alertView.delegate=self
        alertView.title = "二维码"
        alertView.message = "扫到的二维码内容为:\(stringValue)"
        alertView.addButtonWithTitle("确认")
        alertView.show()
        labMessage.text = stringValue
    }

    // mark: - UIAlertViewDelegate
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
//        session.startRunning()
    }
    
    // mark: button action
    
    func tappedQRCodeButtonAction() {
        if isAuth() {
            self.setupCamera()
            session.startRunning()
            showCodeView()
        }
    }
    
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
    
    func setupCamera(){
        session.sessionPreset = AVCaptureSessionPresetHigh
        
        var error : NSError?
        let input = AVCaptureDeviceInput(device: device, error: &error)
        if (error != nil) {
            println(error!.description)
            return
        }
        
        if session.canAddInput(input) {
            session.addInput(input)
        }
        
        layer = AVCaptureVideoPreviewLayer(session: session)
        layer!.videoGravity = AVLayerVideoGravityResizeAspectFill
        layer!.frame = self.view.frame;
        self.view.layer.insertSublayer(self.layer, atIndex: 0)
        
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        
        if session.canAddOutput(output) {
            session.addOutput(output)
            output.metadataObjectTypes = [AVMetadataObjectTypeEAN13Code,
                                          AVMetadataObjectTypeEAN8Code,
                                          AVMetadataObjectTypeCode128Code,
                                          AVMetadataObjectTypeQRCode];
        }
        session.startRunning()
    }
    
    //
    
    func showCodeView() {
        if codeView == nil {
            codeView = UIView()
            codeView!.layer.borderColor = UIColor.greenColor().CGColor
            codeView!.layer.borderWidth = 2
            self.view.addSubview(codeView!)
        }
        view.bringSubviewToFront(codeView!)
    }
  }
