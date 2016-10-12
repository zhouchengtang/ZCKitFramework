//
//  NSObject+ZCKVOBlocks.m
//  ZCKit
//
//  Created by t_zc on 16/1/24.
//  Copyright © 2016年 t_zc. All rights reserved.
//

#import "NSObject+ZCKVOBlocks.h"
#import <objc/runtime.h>

@implementation NSObject(ZCKVOBlocks)

-(void)addObserver:(NSObject *)observer
        forKeyPath:(NSString *)keyPath
           options:(NSKeyValueObservingOptions)options
           context:(void *)context
         withBlock:(KVOBlock)block {
    
    objc_setAssociatedObject(observer, (__bridge const void *)(keyPath), block, OBJC_ASSOCIATION_COPY);
    [self addObserver:observer forKeyPath:keyPath options:options context:context];
}

-(void)removeBlockObserver:(NSObject *)observer
                forKeyPath:(NSString *)keyPath {
    objc_setAssociatedObject(observer, (__bridge const void *)(keyPath), nil, OBJC_ASSOCIATION_COPY);
    [self removeObserver:observer forKeyPath:keyPath];
}

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context {
    
    KVOBlock block = objc_getAssociatedObject(self, (__bridge const void *)(keyPath));
    block(change, context);
}

-(void)addObserverForKeyPath:(NSString *)keyPath
                     options:(NSKeyValueObservingOptions)options
                     context:(void *)context
                   withBlock:(KVOBlock)block {
    
    [self addObserver:self forKeyPath:keyPath options:options context:context withBlock:block];
}

-(void)removeBlockObserverForKeyPath:(NSString *)keyPath {
    [self removeBlockObserver:self forKeyPath:keyPath];
}


@end
