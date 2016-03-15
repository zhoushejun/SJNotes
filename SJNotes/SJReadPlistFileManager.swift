//
//  SJReadPlistFileManager.swift
//  SJNotes
//
//  Created by shejun.zhou on 15/7/14.
//  Copyright (c) 2015年 shejun.zhou. All rights reserved.
//

/**
@file      SJReadPlistFileManager.swift
@abstract  读取 InformationPlist 文件内容
@author    shejun.zhou
@version   1.0 2015/7/14 Creation
*/

import UIKit

class SJReadPlistFileManager: NSObject {
    
    class var shareManager : SJReadPlistFileManager {
        struct Static {
            static var onceToken :dispatch_once_t = 0
            static var manager :SJReadPlistFileManager? = nil
        }
        dispatch_once(&Static.onceToken, { () -> Void in
            Static.manager = SJReadPlistFileManager()
        })
        return Static.manager!
    }
    
    override init() {
        print("ooo")
    }
    
    func readPlistFile() -> NSMutableDictionary{
        let plistPath : String = NSBundle.mainBundle().pathForResource("InformationList", ofType: "plist")!
        let dic = NSMutableDictionary(contentsOfFile: plistPath)
        print("\(dic)")
        return dic!
    }
   
}
