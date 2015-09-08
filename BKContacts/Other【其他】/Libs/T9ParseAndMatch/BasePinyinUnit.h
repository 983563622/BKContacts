//
//  T9PinyinUnit.h
//  CallBar
//
//  Created by apple on 14/11/25.
//  Copyright (c) 2014年 CloudRoom. All rights reserved.
//  单个词(非汉字保留本身)对应的拼音

#import <Foundation/Foundation.h>

@interface BasePinyinUnit : NSObject

/**
 *  保存拼音串(可以是任意的字符串)
 */
@property (nonatomic, copy) NSString *pinyin;

/**
 *  保存pinyin对应的T9数字
 */
@property (nonatomic, strong) NSMutableString *number;

/**
 *  初始化
 *
 *  @param pinyin 传入的拼音字母
 */
- (void)initBasePinyinUnitWithPinyin:(NSString *)pinyin;

@end
