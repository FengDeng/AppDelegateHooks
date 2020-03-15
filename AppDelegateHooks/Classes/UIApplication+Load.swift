//
//  UIApplication+load.swift
//  Yizhitong
//
//  Created by 邓锋 on 2020/3/12.
//  Copyright © 2020 Hangzhou Yizhitong Network Technology Co., Ltd. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication{
    @objc dynamic static func runInLoad() {
        AppHooksManager.default.setup()
    }
}
