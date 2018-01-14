//
//  NSObject+Swizzled.h
//  Estimote Editor
//
//  Created by Sandeep Mistry on 12/21/2013.
//  Copyright (c) 2013 Yoann Gini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBXpcConnection : NSObject

@end

@interface CBXpcConnection (Swizzled)

// original
- (void)handleMsg:(int)arg1 args:(id)arg2;
- (void)sendMsg:(int)arg1 args:(id)arg2;

// swizzled
- (void)handleMsgSwizzled:(int)arg1 args:(id)arg2;
- (void)sendMsgSwizzled:(int)arg1 args:(id)arg2;

@end
