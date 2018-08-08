//
//  AppHooksManager.swift
//  AppHooks
//
//  Created by 邓锋 on 2018/6/21.
//  Copyright © 2018年 xiangzhen. All rights reserved.
//

import Foundation
import UIKit
import Aspects

extension UIApplication{
    private static let registAllApplicationHook:Void = {
        AppHooksManager.registAllApplicationHook()
        AppHooksManager.default.hook()
    }()
    
    @objc class func registAllApplicationHookFromOCload(){
        UIApplication.registAllApplicationHook
    }
}


public class AppHooksManager{
    public static let `default` = AppHooksManager()
    
    //保存所有的hook实例
    var hooks = [ApplicationHook]()
    var hooksDic = [Selector : [ApplicationHook]]()
    func regist(hook:ApplicationHook){
        self.hooks.append(hook)
        self.hooks.sort()
    }
    
    //主工程 实现Delegate的类 一般为 AppDelegate
    var mainProtocolClass : AnyClass?

    //如果hook的方法需要有返回值的话，查看 https://github.com/steipete/Aspects
    private init(){
    }
    
    func hook(){
        
        guard let application = mainProtocolClass else{return}
        do {
            var methodCount : UInt32 = 1
            guard let methodList = protocol_copyMethodDescriptionList(UIApplicationDelegate.self,
                                                                      false, true,  UnsafeMutablePointer<UInt32>(&methodCount)) else{return}
                
                
            //奇怪了 这里获取的方法竟然会重复
            var methods = [objc_method_description]()
            for i in 0..<Int(methodCount) {
                let methodDesc = methodList[i];
                methods.append(methodDesc)
            }
            let set = Set<objc_method_description>.init(methods)
            for methodDesc in set {
                guard let name = methodDesc.name else {continue}
                let wrappedBlock:@convention(block) (AspectInfo)-> Void = {aspectInfo in
                    if let hooks = self.hooksDic[name]{
                        for hook in hooks{
                            if class_getInstanceMethod(hook.classForCoder, name) != nil{
                                hook.perform(name, with: aspectInfo.arguments().filter({!($0 is NSNull)}))
                            }
                        }
                    }
                }
                //如果主工程的delegate实现了方法，则所有的hook都需要执行
                if class_getInstanceMethod(application, name) != nil{
                    self.hooksDic[name] = self.hooks.filter({ (hook) -> Bool in
                        return class_getInstanceMethod(hook.classForCoder, name) != nil
                    })
                    _ = try application.aspect_hook(name, with: AspectOptions.positionBefore, usingBlock: wrappedBlock)
                }else{
                    //如果主工程的delegate没有实现方法
                    //找到实现了的hook
                    var hooks = [ApplicationHook]()
                    for hook in self.hooks{
                        if class_getInstanceMethod(hook.classForCoder, name) != nil{
                            hooks.append(hook)
                        }
                    }
                    if hooks.count > 0{
                        //取出最后一个hook 动态添加到AppDelegate（因为我们等会hook的是before，为保证level，这里hook最后一个）
                        let hook = hooks.removeLast()
                        if let method = class_getInstanceMethod(hook.classForCoder, name){
                            class_addMethod(application, name, method_getImplementation(method), method_getTypeEncoding(method))
                        }
                        
                        if hooks.count > 0{
                            self.hooksDic[name] = hooks
                            _ = try application.aspect_hook(name, with: AspectOptions.positionBefore, usingBlock: wrappedBlock)
                        }
                    }
                }
            }
            
        } catch  {
            print(error)
        }
    }
}

extension AppHooksManager{
    /**
     Check whether a class is subclass of another class.
     - parameter subclass:   Inspected subclass.
     - parameter superclass: Superclass which to compare with.
     - returns: true or false.
     */
    static func isSubclass(_ subclass: AnyClass!, superclass: AnyClass!) -> Bool {
        
        guard let superclass = superclass else {
            return false
        }
        
        var eachSubclass: AnyClass! = subclass
        
        while let eachSuperclass: AnyClass = class_getSuperclass(eachSubclass) {
            /* Use ObjectIdentifier instead of `===` to make identity test.
             Because some types cannot respond to `===`, like WKObject in WebKit framework. */
            if ObjectIdentifier(eachSuperclass) == ObjectIdentifier(superclass) {
                return true
            }
            eachSubclass = eachSuperclass
        }
        
        return false
    }
    /**
     Get all subclasses of a base class.
     - parameter baseclass: A base class.
     - returns: All subclasses of given base class.
     */
    static func subclasses(_ baseclass: AnyClass!) -> [AnyClass] {
        var result = [AnyClass]()
        
        guard let baseclass = baseclass else {
            return result
        }
        
        let count: Int32 = objc_getClassList(nil, 0)
        
        guard count > 0 else {
            return result
        }
        
        let classes = UnsafeMutablePointer<AnyClass>.allocate(
            capacity: Int(count)
        )
        
        defer {
            classes.deallocate()
        }
        
        let buffer = AutoreleasingUnsafeMutablePointer<AnyClass>(classes)
        for i in 0..<Int(objc_getClassList(buffer, count)) {
            let someclass: AnyClass = classes[i]
            if isSubclass(someclass, superclass: baseclass) {
                result.append(someclass)
            }
        }
        return result
    }
    
    static func confirm(_ baseclass: AnyClass,confirm baseprotocol: Protocol) ->Bool{
        
        var eachSubclass: AnyClass = baseclass
        if class_conformsToProtocol(baseclass, baseprotocol) {
            return true
        }
        while let eachSuperclass: AnyClass = class_getSuperclass(eachSubclass) {
            /* Use ObjectIdentifier instead of `===` to make identity test.
             Because some types cannot respond to `===`, like WKObject in WebKit framework. */
            if class_conformsToProtocol(eachSuperclass, baseprotocol) {
                return true
            }
            eachSubclass = eachSuperclass
        }
        
        return false
    }
    
    static func subclasses(_ baseclass: AnyClass,confirm baseprotocol: Protocol) -> ([AnyClass],[AnyClass]) {
        var subResult = [AnyClass]()
        var proResult = [AnyClass]()
        
        let count: Int32 = objc_getClassList(nil, 0)
        
        guard count > 0 else {
            return (subResult,proResult)
        }
        
        let classes = UnsafeMutablePointer<AnyClass>.allocate(
            capacity: Int(count)
        )
        
        defer {
            classes.deallocate()
        }
        
        let buffer = AutoreleasingUnsafeMutablePointer<AnyClass>(classes)
        for i in 0..<Int(objc_getClassList(buffer, count)) {
            let someclass: AnyClass = classes[i]
            if isSubclass(someclass, superclass: baseclass) {
                subResult.append(someclass)
            }else{
                if confirm(someclass, confirm: baseprotocol) {
                    proResult.append(someclass)
                }
            }
        }
        return (subResult,proResult)
    }
    
    
    static func registAllApplicationHook() {
        
        let classes = AppHooksManager.subclasses(ApplicationHook.self, confirm: UIApplicationDelegate.self)
        for subclass in classes.0{
            if let hook = subclass as? ApplicationHook.Type{
                let instance = hook.init()
                AppHooksManager.default.regist(hook: instance)
            }
        }
        for subclass in classes.1{
            if !subclass.isSubclass(of: ApplicationHookClass.self){
                AppHooksManager.default.mainProtocolClass = subclass
            }
        }
        
    }
}

extension objc_method_description : Equatable,Hashable{
    public var hashValue: Int {
        return self.name?.hashValue ?? 0
    }
    
    public static func ==(lhs: objc_method_description, rhs: objc_method_description) -> Bool{
        return lhs.name == rhs.name
    }
}
