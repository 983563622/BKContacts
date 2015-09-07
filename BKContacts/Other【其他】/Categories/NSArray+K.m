//
//  NSArray+K.m
//  CallBar
//
//  Created by apple on 15/7/3.
//  Copyright (c) 2015年 CloudRoom. All rights reserved.
//

#import "NSArray+K.h"

@implementation NSArray (K)
#pragma mark - public methods
+ (BOOL)checkArrayIsEmptyOrNil:(NSArray *)aArray
{
    if (aArray == nil || [aArray count] == 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
