//
//  NSObject+ZCizzle.h
//  SinaFinance
//
//  Created by zhoucheng on 14-3-13.
//  Copyright (c) 2014年 zhoucheng. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * This category adds methods to the NSObject.
 */
@interface NSObject(ZCSwizzle)

/*
 * To swizzle two selector from self class to target class.
 * @param srcSel source selector
 * @param tarClassName target class name string
 * @param tarSel target selector
 */
- (void)swizzleMethod:(SEL)origSelector withMethod:(SEL)newSelector class:(Class)class;

@end
