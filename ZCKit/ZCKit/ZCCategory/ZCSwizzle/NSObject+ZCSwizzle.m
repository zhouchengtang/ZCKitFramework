//
//  NSObject+ZCSwizzle.m
//  SinaFinance
//
//  Created by zhangyu on 14-3-13.
//  Copyright (c) 2014年 zhoucheng. All rights reserved.
//

#import "NSObject+ZCSwizzle.h"
#import <objc/runtime.h>

#define SK_TRY_BODY(__target) \
@try {\
{__target}\
}\
@catch (NSException *exception) {\
[exception printStackTrace];\
}\
@finally {\
\
}

@implementation NSObject(ZCSwizzle)

- (void)swizzleMethod:(SEL)origSelector withMethod:(SEL)newSelector class:(Class)class
{
    if (!class) {
        return;
    }
    
    Method originalMethod = class_getInstanceMethod(class, origSelector);
    Method swizzledMethod = class_getInstanceMethod(class, newSelector);
    
    BOOL didAddMethod = class_addMethod(class,
                                        origSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class,
                            newSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

/*
+ (void) load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
#ifdef __OPTIMIZE__
        id obj = [[self alloc] init];
        Class class = [self class];
        [obj swizzleMethod:@selector(performSelector:) withMethod:@selector(tzc_performSelector:) class:class];
        [obj swizzleMethod:@selector(performSelector:withObject:) withMethod:@selector(tzc_performSelector:withObject:) class:class];
        [obj swizzleMethod:@selector(performSelector:withObject:withObject:) withMethod:@selector(tzc_performSelector:withObject:withObject:) class:class];
#endif
    });
}

-(BOOL)isSelectorReturnType:(SEL)aSelector{
    NSMethodSignature *signature = [self methodSignatureForSelector:aSelector];
    if (signature) {
        const char *returnType = signature.methodReturnType;
        if (!strcmp(returnType, @encode(void))){
            return NO;
        }else{
            return YES;
        }
    }
    return NO;
}

- (id)tzc_performSelector:(SEL)aSelector
{
    if ([self respondsToSelector:aSelector]) {
        if ([self isSelectorReturnType:aSelector]) {
            typedef id (*MethodType)(id, SEL);
            MethodType methodToCall = (MethodType)[self methodForSelector:aSelector];
            return methodToCall(self, aSelector);
        }else{
            typedef void (*MethodType)(id, SEL);
            MethodType methodToCall = (MethodType)[self methodForSelector:aSelector];
            methodToCall(self, aSelector);
            return nil;
        }
    }else{
        return nil;
    }
}

-(id)tzc_performSelector:(SEL)aSelector withObject:(id)object
{
    if ([self respondsToSelector:aSelector]) {
        if ([self isSelectorReturnType:aSelector]) {
            typedef id (*MethodType)(id, SEL, id);
            MethodType methodToCall = (MethodType)[self methodForSelector:aSelector];
            return methodToCall(self, aSelector, object);
        }else{
            typedef void (*MethodType)(id, SEL, id);
            MethodType methodToCall = (MethodType)[self methodForSelector:aSelector];
            methodToCall(self, aSelector, object);
            return nil;
        }
    }else{
        return nil;
    }
}

-(id)tzc_performSelector:(SEL)aSelector withObject:(id)object1 withObject:(id)object2
{
    if ([self respondsToSelector:aSelector]) {
        if ([self isSelectorReturnType:aSelector]) {
            typedef id (*MethodType)(id, SEL, id, id);
            MethodType methodToCall = (MethodType)[self methodForSelector:aSelector];
            return methodToCall(self, aSelector, object1, object2);
        }else{
            typedef void (*MethodType)(id, SEL, id, id);
            MethodType methodToCall = (MethodType)[self methodForSelector:aSelector];
            methodToCall(self, aSelector, object1, object2);
            return nil;
        }
    }else{
        return nil;
    }
}
*/
@end
