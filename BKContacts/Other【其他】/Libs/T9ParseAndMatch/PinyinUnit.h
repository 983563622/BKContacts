//
//  PinyinUnit.h
//  CallBar
//
//  Created by apple on 14/11/25.
//  Copyright (c) 2014年 CloudRoom. All rights reserved.
//  一串字符串中的单个词

#import <Foundation/Foundation.h>

@interface PinyinUnit : NSObject

/**
 *  是否是拼音
 */
@property (nonatomic, assign) BOOL isPinyin;

/**
 *  记录在原始字符串中的位置
 */
@property (nonatomic, assign) NSInteger startPosition;

/**
 *  保存拼音(多音字长度大于1,单音字或其他类型字符串长度为1),元素对象:T9PinyinUnit
 */
@property (nonatomic, strong) NSMutableArray *basePinyinUnits;


- (void)initWithIsPinyin:(BOOL)isPinyin andStartPosition:(NSInteger)startPosition;
- (void)initPinyinUnitWithIsPinyin:(BOOL)isPinyin andPinyinArray:(NSArray *)pinyinArray andStartPosition:(NSInteger)startPosition;

@end
