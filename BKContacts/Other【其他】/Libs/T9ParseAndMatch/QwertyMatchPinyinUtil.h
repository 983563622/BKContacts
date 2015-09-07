//
//  QwertyMatchPinyinUtil.h
//  CallBar
//
//  Created by apple on 14/12/1.
//  Copyright (c) 2014年 CloudRoom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QwertyMatchPinyinUtil : NSObject

/**
 *  匹配给定字符串
 *
 *  @param pinyinUnits  nickname对应的nikenamePinyinUnits
 *  @param sourceString nickname
 *  @param searchString 搜索的字符串
 *  @param keyword      关键字
 *
 *  @return 是/否
 */
+ (BOOL)matchWithPinyinUnits:(NSMutableArray *)pinyinUnits andSourceString:(NSString *)sourceString andSearchString:(NSString *)searchString andKeyword:(NSMutableString *)keyword;

@end
