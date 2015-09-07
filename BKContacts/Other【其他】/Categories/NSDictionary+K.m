//
//  NSDictionary+K.m
//  CallBar
//
//  Created by apple on 15/7/13.
//  Copyright (c) 2015年 CloudRoom. All rights reserved.
//

#import "NSDictionary+K.h"

@implementation NSDictionary (K)

+ (BOOL)checkDictionaryIsEmptyOrNil:(NSDictionary *)aDict
{
    if (aDict == nil || [aDict count] == 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
