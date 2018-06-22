//
//  TestDeleagte.swift
//  AppDelegateHooks
//
//  Created by 邓锋 on 2018/6/22.
//  Copyright © 2018年 xiangzhen. All rights reserved.
//

import Foundation
import Aspects

@objc protocol TestPro : NSObjectProtocol {
    @objc optional
    func fly()
}

class TestNoImp: NSObject,TestPro {

}
class TestImp: NSObject,TestPro {
    func fly() {
        print("我会飞")
    }
}

class TestRun : NSObject{
    var delegate : TestNoImp?
    
    override init() {
        super.init()
        
        //获取实现的方法替换到 delegate中
//        let name = T
//        if let method = class_getInstanceMethod(TestImp.classForCoder, name){
//            print("--dy-add-主工程未实现，动态添加 \(name)")
//            class_addMethod(application.classForCoder, name, method_getImplementation(method), method_getTypeEncoding(method))
//        }
    }
    
    func canFly(){
//        if let fly = self.delegate?.fly{
//            fly()
//        }else{
//            print("delegate 未实现 fly")
//        }
    }
}
