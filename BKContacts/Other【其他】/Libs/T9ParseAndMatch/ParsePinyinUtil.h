//
//  T9PinyinUtil.h
//  CallBar
//
//  Created by apple on 14/11/29.
//  Copyright (c) 2014年 CloudRoom. All rights reserved.
//  解析工具类

#import <Foundation/Foundation.h>

@interface ParsePinyinUtil : NSObject

/**
 *  字符串转换成数字和字母
 *
 *  @param chineseStirng 传入原始字符串
 *  @param pinyinUnits   拼音字符串(可能含有多音字拼音)
 */
+ (void)chineseString:(NSString *)chineseString translateToPinyinUnit:(NSMutableArray *)pinyinUnits;

@end
