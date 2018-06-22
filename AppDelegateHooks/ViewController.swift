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
       
        //UIApplication.shared.canOpenURL(URL.init(string: "www.baidu.com")!)
        
        
        let btn = UIButton.init()
        btn.setTitle("Hook", for: .normal)
        
        btn.backgroundColor = UIColor.red
        self.view.addSubview(btn)
        btn.frame = CGRect.init(x: 100, y: 100, width: 100, height: 100)
        btn.addTarget(self, action: #selector(clicked), for: UIControlEvents.touchUpInside)
    }
    
    @objc func clicked(){

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

