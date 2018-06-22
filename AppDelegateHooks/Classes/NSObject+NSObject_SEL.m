//
//  NSObject+NSObject_SEL.m
//  AppHooks
//
//  Created by 邓锋 on 2018/6/21.
//  Copyright © 2018年 xiangzhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+NSObject_SEL.h"

@implementation NSObject (Sel)

- (id)performSelector:(SEL)aSelector withObjects:(NSArray *)objects{
    NSMethodSignature *methodSignature = [[self class] instanceMethodSignatureForSelector:aSelector];
    if(methodSignature == nil) {
        return nil;
    }else{
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        [invocation setTarget:self];
        [invocation setSelector:aSelector];
        //签名中方法参数的个数，内部包含了self和_cmd，所以参数从第3个开始
        NSInteger signatureParamCount = methodSignature.numberOfArguments - 2;
        NSInteger requireParamCount = objects.count;
        NSInteger resultParamCount = MIN(signatureParamCount, requireParamCount);
        for (NSInteger i = 0; i < resultParamCount; i++) {
            id obj = objects[i]; [invocation setArgument:&obj atIndex:i+2];
        }
        [invocation invoke];
        id callBackObject = nil;
        if(methodSignature.methodReturnLength) {
            [invocation getReturnValue:&callBackObject];
        }
        return callBackObject;
    }
}
@end
