//
//  ViewController.swift
//  AppDelegateHooks
//
//  Created by 邓锋 on 2018/6/22.
//  Copyright © 2018年 xiangzhen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        UIApplication.shared.open(URL.init(string: "www.baidu.com")!, options: [:]) { (com) in
            print("www.baidu.com")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

