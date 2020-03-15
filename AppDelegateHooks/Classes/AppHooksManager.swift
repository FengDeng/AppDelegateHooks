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

//如果hook的方法需要有返回值的话，查看 https://github.com/steipete/Aspects

typealias AspectsBlock = @convention(block) (AspectInfo) -> Void

public class AppHooksManager{
    public static let `default` = AppHooksManager()
    
    //保存所有的hook实例
    var hooks = [AppDelegateHook]()
    var hooksDic = [Selector : [AppDelegateHook]]()
    
    //主工程 实现Delegate的类 一般为 AppDelegate
    var mainProtocolClass : AnyClass?
    
    private init(){}
    
    func setup(){
        /// 获取主工程的代理类，以及其他模块的代理类
        AppHooksManager.registAllApplicationHook()
        guard let application = mainProtocolClass else{return}
        
        /// 获取代理所有的方法
        let methods = self.getUIApplicationDelegateMethods()
        
        
        /// 构建优先级的调用体系  这里注意主工程的最后调用
        for method in methods {
            guard let name = method.name else {continue}
            
            /// 构造 Block
            let wrappedBlock:AspectsBlock = {aspectInfo in
                if let hooks = self.hooksDic[name]{
                    for hook in hooks{
                        if class_getInstanceMethod(hook.classForCoder, name) != nil{
                            hook.perform_hooks(name, with: aspectInfo.arguments())
                        }
                    }
                }
            }
            
            //如果主工程的delegate实现了方法，则所有的hook都需要执行
            if class_getInstanceMethod(application, name) != nil{
                self.hooksDic[name] = self.hooks.filter({ (hook) -> Bool in
                    return class_getInstanceMethod(hook.classForCoder, name) != nil
                })
                _ = try? application.aspect_hook(name, with: AspectOptions.positionBefore, usingBlock: wrappedBlock)
            }else{
                //如果主工程的delegate没有实现方法
                //找到实现了的hook
                var hooks = [AppDelegateHook]()
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
                        _ = try? application.aspect_hook(name, with: AspectOptions.positionBefore, usingBlock: wrappedBlock)
                    }
                }
            }
        }
    }
    
    
    /// 获取 UIApplicationDelegate 协议的所有方法
    fileprivate func getUIApplicationDelegateMethods()->[objc_method_description] {
        var methodCount : UInt32 = 1
        guard let methodList = protocol_copyMethodDescriptionList(UIApplicationDelegate.self,
                                                                  false, true,  UnsafeMutablePointer<UInt32>(&methodCount)) else{return []}
        //奇怪了 这里获取的方法竟然会重复
        var methods = [objc_method_description]()
        for i in 0..<Int(methodCount) {
            let methodDesc = methodList[i];
            methods.append(methodDesc)
        }
        let set = Set<objc_method_description>.init(methods)
        return Array.init(set)
    }
}

extension AppHooksManager{
    
    /// 判断一个类是不是另一个类的子类
    static func isSubclass(_ subclass: AnyClass!, superclass: AnyClass!) -> Bool {
        guard let superclass = superclass else {
            return false
        }
        var eachSubclass: AnyClass! = subclass
        while let eachSuperclass: AnyClass = class_getSuperclass(eachSubclass) {
            if ObjectIdentifier(eachSuperclass) == ObjectIdentifier(superclass) {
                return true
            }
            eachSubclass = eachSuperclass
        }
        return false
    }
    
    /// 获取一个类的所有子类
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
    
    /// 判断一个类是否符合一个协议
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
    
    /// 获取所有符合协议的类
    static func getAllClasses(confirm baseprotocol: Protocol) -> [AnyClass] {
        var proResult = [AnyClass]()
        
        let count: Int32 = objc_getClassList(nil, 0)
        
        guard count > 0 else {
            return proResult
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
            if confirm(someclass, confirm: baseprotocol) {
                proResult.append(someclass)
            }
        }
        return proResult
    }
    
    
    static func registAllApplicationHook() {
        /// 获取所有符合 UIApplicationDelegate 的类
        let classes = AppHooksManager.getAllClasses(confirm: UIApplicationDelegate.self)
        for subclass in classes{
            if let hook = subclass as? AppDelegateHook.Type{
                let instance = hook.init()
                AppHooksManager.default.hooks.append(instance)
            }
            AppHooksManager.default.hooks.sort()
            if !subclass.isSubclass(of: AppDelegateHook.self) && !subclass.isSubclass(of: UIApplication.self){
                AppHooksManager.default.mainProtocolClass = subclass
            }
        }
    }
}

extension objc_method_description : Equatable,Hashable{
    public func hash(into hasher: inout Hasher) {
       hasher.combine(name)
    }
    
    public static func ==(lhs: objc_method_description, rhs: objc_method_description) -> Bool{
        return lhs.name == rhs.name
    }
}

extension NSObject{
    func perform_hooks(_ selector : Selector,with args:[Any]){
        let cls :AnyClass = self.classForCoder
        let method = class_getMethodImplementation(cls, selector)
        if args.count == 0{
            typealias signature = @convention(c)(Any,Selector)->Void
            let function = unsafeBitCast(method,to: signature.self)
            function(self,selector)
        }
        if args.count == 1{
            typealias signature = @convention(c)(Any,Selector,Any?)->Void
            let function = unsafeBitCast(method,to: signature.self)
            function(self,selector,(args[0] is NSNull) ? nil : args[0])
        }
        if args.count == 2{
            typealias signature = @convention(c)(Any,Selector,Any?,Any?)->Void
            let function = unsafeBitCast(method, to: signature.self)
            function(self,selector,(args[0] is NSNull) ? nil : args[0],(args[1] is NSNull) ? nil : args[1])
        }
        if args.count == 3{
            typealias signature = @convention(c)(Any,Selector,Any?,Any?,Any?)->Void
            let function = unsafeBitCast(method, to: signature.self)
            function(self,selector,(args[0] is NSNull) ? nil : args[0],(args[1] is NSNull) ? nil : args[1],(args[2] is NSNull) ? nil : args[2])
        }
        if args.count == 4{
            typealias signature = @convention(c)(Any,Selector,Any?,Any?,Any?,Any?)->Void
            let function = unsafeBitCast(method, to: signature.self)
            function(self,selector,(args[0] is NSNull) ? nil : args[0],(args[1] is NSNull) ? nil : args[1],(args[2] is NSNull) ? nil : args[2],(args[3] is NSNull) ? nil : args[3])
        }
        if args.count == 5{
            typealias signature = @convention(c)(Any,Selector,Any?,Any?,Any?,Any?,Any?)->Void
            let function = unsafeBitCast(method, to: signature.self)
            function(self,selector,(args[0] is NSNull) ? nil : args[0],(args[1] is NSNull) ? nil : args[1],(args[2] is NSNull) ? nil : args[2],(args[3] is NSNull) ? nil : args[3],(args[4] is NSNull) ? nil : args[4])
        }
    }
}

