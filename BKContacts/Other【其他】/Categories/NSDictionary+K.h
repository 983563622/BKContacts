//
//  NSDictionary+K.h
//  CallBar
//
//  Created by apple on 15/7/13.
//  Copyright (c) 2015年 CloudRoom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (K)
/**
 *  判断字典为empty或nil
 *
 *  @param aDict 源数组
 *
 *  @return YES/NO
 */
+ (BOOL)checkDictionaryIsEmptyOrNil:(NSDictionary *)aDict;

@end
