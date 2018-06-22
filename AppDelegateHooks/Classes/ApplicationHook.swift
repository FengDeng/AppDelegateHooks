//
//  ApplicationHook.swift
//  AppHooks
//
//  Created by 邓锋 on 2018/6/21.
//  Copyright © 2018年 xiangzhen. All rights reserved.
//

import Foundation
import UIKit

open class ApplicationHook : NSObject, UIApplicationDelegate {
    
    //bigger level called first
    open var level = 0
    required public override init() {
        
    }
    
}
extension ApplicationHook : Comparable{
    public static func < (lhs: ApplicationHook, rhs: ApplicationHook) -> Bool {
        return lhs.level > rhs.level
    }
 
}
