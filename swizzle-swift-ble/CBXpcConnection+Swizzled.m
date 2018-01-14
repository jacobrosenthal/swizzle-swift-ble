//
//  NSObject+Swizzled.m
//  Estimote Editor
//
//  Created by Sandeep Mistry on 12/21/2013.
//  Copyright (c) 2013 Yoann Gini. All rights reserved.
//

#import <objc/runtime.h>

#import "CBXpcConnection+Swizzled.h"

@implementation CBXpcConnection (Swizzled)

+ (void)load
{
    Method original, swizzled;
    
    original = class_getInstanceMethod(self, @selector(handleMsg:args:));
    swizzled = class_getInstanceMethod(self, @selector(handleMsgSwizzled:args:));
    method_exchangeImplementations(original, swizzled);
    
    original = class_getInstanceMethod(self, @selector(sendMsg:args:));
    swizzled = class_getInstanceMethod(self, @selector(sendMsgSwizzled:args:));
    method_exchangeImplementations(original, swizzled);
}

- (void)handleMsgSwizzled:(int)arg1 args:(id)arg2
{
    NSLog(@"handleMsg: %d, %@", arg1, arg2);
    
    [self handleMsgSwizzled:arg1 args:arg2];
}

- (void)sendMsgSwizzled:(int)arg1 args:(id)arg2
{
    NSLog(@"sendMsg: %d, %@", arg1, arg2);
    
    [self sendMsgSwizzled:arg1 args:arg2];
}

@end
