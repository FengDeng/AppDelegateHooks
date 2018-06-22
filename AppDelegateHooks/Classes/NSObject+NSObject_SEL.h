//
//  NSObject+NSObject_SEL.h
//  AppHooks
//
//  Created by 邓锋 on 2018/6/21.
//  Copyright © 2018年 xiangzhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Sel)
- (id)performSelector:(SEL)aSelector withObjects:(NSArray *)objects;
@end




