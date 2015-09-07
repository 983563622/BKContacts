//
//  NSString+K.h
//  SearchContacts
//
//  Created by apple on 14/11/11.
//  Copyright (c) 2014年 TJF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (K)

/**
 *  判断指定的字符串对象是否为空
 *
 *  @param astring 指定字符串
 *
 *  @return YES/NO
 */
+ (BOOL)checkStringIsEmptyOrNil:(NSString *)astring;

/**
 *  是否以数字或其他字符(A~Z或者a~z以外的字符)开头
 *
 *  @param astring 指定字符串
 *
 *  @return YES/NO
 */
+ (BOOL)checkIsStartWithNumberOrOther:(NSString *)astring;

/**
 *  字符串转数组
 *
 *  @param astring 指定字符串
 *
 *  @return 转换后的数组
 */
+ (NSArray *)translateToArrayFromString:(NSString *)astring;

/**
 *  是否包含子串
 *
 *  @param astring 指定子串
 *
 *  @return YES/NO
 */
- (BOOL)containsWithString:(NSString *)astring;

@end
