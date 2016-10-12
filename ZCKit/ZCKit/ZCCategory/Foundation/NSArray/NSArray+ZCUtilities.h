//
//  NSArray+TZCUtilities.h
//  PrivateAccountBook
//
//  Created by 唐周成 on 16/1/10.
//  Copyright © 2016年 JiaPin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSArray(ZCUtilities)

@end

@interface NSMutableArray(ZCUtilities)

- (NSMutableArray *)arrayMoveIndex:(NSInteger)sourceIndex toIndex:(NSInteger)destinationIndex;

@end
