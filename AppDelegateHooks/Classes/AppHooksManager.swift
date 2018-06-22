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
    
    open override var next: UIResponder?{
        UIApplication.registAllApplicationHook
        return super.next
    }
}


public class AppHooksManager{
    public static let `default` = AppHooksManager()
    
    //保存所有的hook实例
    var hooks = [ApplicationHook]()
    
    //
    var hooksDic = [Selector : [ApplicationHook]]()
    func regist(hook:ApplicationHook){
        self.hooks.append(hook)
        self.hooks.sort()
    }

    //如果hook的方法需要有返回值的话，查看 https://github.com/steipete/Aspects
    private init(){
    }
    
    func hook(){
        guard let delegate = UIApplication.shared.delegate,let application = delegate as? NSObject else{return}
        do {
            var methodCount : UInt32 = 1
            if let methodList = protocol_copyMethodDescriptionList(UIApplicationDelegate.self,
                                                                   false, true,  UnsafeMutablePointer<UInt32>(&methodCount)) {
                for i in 0..<Int(methodCount) {
                    let methodDesc = methodList[i];
                    guard let name = methodDesc.name else {continue}
                    //let types = methodDesc.types
                    
                    
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
                    if class_getInstanceMethod(application.classForCoder, name) != nil{
                        print("-----hook \(String(describing: name))")
                        self.hooksDic[name] = self.hooks
                        try application.aspect_hook(name, with: AspectOptions.positionBefore, usingBlock: wrappedBlock)
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
                                print("--dy-add-主工程未实现，动态添加 \(name)")
                                class_addMethod(application.classForCoder, name, method_getImplementation(method), method_getTypeEncoding(method))
                            }
                            
                            if hooks.count > 0{
                                self.hooksDic[name] = hooks
                                try application.aspect_hook(name, with: AspectOptions.positionBefore, usingBlock: wrappedBlock)
                            }
                            print(application.classForCoder.instancesRespond(to: name))
                            print((application as? UIApplicationDelegate)?.responds(to: name))
                            print(application.responds(to: name))
//                            print("手动调用下 \(name)")
//                            application.perform(name, with: nil)
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
    
    static func registAllApplicationHook() {
        let subClasses = AppHooksManager.subclasses(ApplicationHook.self)
        for subclass in subClasses{
            if let hook = subclass as? ApplicationHook.Type{
                let instance = hook.init()
                AppHooksManager.default.regist(hook: instance)
            }
        }
    }
}
