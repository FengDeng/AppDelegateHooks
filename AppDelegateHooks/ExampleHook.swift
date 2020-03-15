//
//  ExampleHook.swift
//  AppHooks
//
//  Created by 邓锋 on 2018/6/21.
//  Copyright © 2018年 xiangzhen. All rights reserved.
//

import Foundation
import UIKit
class ExampleHook1: AppDelegateHook {
    
    required init() {
        super.init()
        self.level = 10
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {
        print("ExampleHook1 didFinishLaunchingWithOptions")
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("ExampleHook1 applicationWillResignActive")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("ExampleHook1 applicationDidBecomeActive")
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        print("ExampleHook1 open url")
        return false
    }
}

class ExampleHook2: AppDelegateHook {
    
    required init() {
        super.init()
        self.level = 5
    }

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {
        print("ExampleHook2 didFinishLaunchingWithOptions")
        return true
    }
    func applicationWillResignActive(_ application: UIApplication) {
        print("ExampleHook2 applicationWillResignActive")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("ExampleHook2 applicationDidBecomeActive")
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        print("ExampleHook2 open url")
        return false
    }
    
}

class ExampleHook3: AppDelegateHook {
    
    required init() {
        super.init()
        self.level = 500
    }

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {
        print("ExampleHook3 didFinishLaunchingWithOptions")
        return true
    }
    func applicationWillResignActive(_ application: UIApplication) {
        print("ExampleHook3 applicationWillResignActive")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("ExampleHook3 applicationDidBecomeActive")
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        print("ExampleHook3 open url")
        return false
    }
    
}

