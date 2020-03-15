//
//  UIApplication+Load.m
//  Yizhitong
//
//  Created by 邓锋 on 2020/3/12.
//  Copyright © 2020 Hangzhou Yizhitong Network Technology Co., Ltd. All rights reserved.
//
#import <UIKit/UIKit.h>

@implementation UIApplication (Load)

+ (void)load{
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wundeclared-selector"
    Class app = NSClassFromString(@"UIApplication");
    [app performSelector:@selector(runInLoad)];
    #pragma clang diagnostic pop
}

@end
