//
//  ApplicationHook.swift
//  AppHooks
//
//  Created by 邓锋 on 2018/6/21.
//  Copyright © 2018年 xiangzhen. All rights reserved.
//

import Foundation
import UIKit

@objc open class AppDelegateHook : NSObject, UIApplicationDelegate {
    
    //bigger level called first
    open var level = 0
    required public override init() {}
    
}
extension AppDelegateHook : Comparable{
    public static func < (lhs: AppDelegateHook, rhs: AppDelegateHook) -> Bool {
        return lhs.level > rhs.level
    }
 
}
