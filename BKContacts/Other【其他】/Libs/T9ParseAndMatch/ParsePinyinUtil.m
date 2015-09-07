//
//  T9PinyinUtil.m
//  CallBar
//
//  Created by apple on 14/11/29.
//  Copyright (c) 2014年 CloudRoom. All rights reserved.
//  解析工具类

#import "ParsePinyinUtil.h"
#import "PinYin4Objc.h"
#import "PinyinUnit.h"
#import "BasePinyinUnit.h"
#import "T9Util.h"

extern HanyuPinyinOutputFormat *_outputFormat;

@implementation ParsePinyinUtil
#pragma mark - public methods
/**
 *  字符串转换成数字和字母
 *
 *  @param chineseStirng 传入原始字符串
 *  @param pinyinUnits   拼音字符串(可能含有多音字拼音以及英文字母)
 */
+ (void)chineseString:(NSString *)chineseString translateToPinyinUnit:(NSMutableArray *)pinyinUnits
{
    if ([NSString checkStringIsEmptyOrNil:chineseString] == YES) // chineseString为空
    {
        return;
    }
    
    if (_outputFormat == nil)
    {
        _outputFormat = [[HanyuPinyinOutputFormat alloc] init];
        
        [_outputFormat setToneType:ToneTypeWithoutTone];
    }
    
    //TODO: 传入的所有大写字母转换成小写 modefied By king 20141204
    chineseString = [chineseString lowercaseString];
    
    // 比如:5(tian田)
    NSInteger chineseStringCount = [chineseString length];
    
    // 非汉字字符缓冲
    NSMutableString *nonPinyinString = [[NSMutableString alloc] init];
    
    PinyinUnit *pinyinUnit = nil;
    
    // 上一个字符是否是汉字标记
    BOOL isLastChineseCharacter = TRUE;
    
    // 起始位置
    NSInteger startPosition = -1;
    
    // 汉字转pinyin结果集
    NSArray *pinyinArray = nil;
    
    for (NSInteger i = 0; i < chineseStringCount; i++)
    {
        // 从中获取单个词(英文就是一个字符,中文就是一个汉字,t,i,a,n,田)
        unichar c = [chineseString characterAtIndex:i];
        
        // 非汉字(字母,数字或者特殊字符)则返回为空
        pinyinArray = [PinyinHelper toHanyuPinyinStringArrayWithChar:c withHanyuPinyinOutputFormat:_outputFormat];
        
        if ([NSArray checkArrayIsEmptyOrNil:pinyinArray] == YES) // 非汉字
        {
            if (isLastChineseCharacter == YES)
            {
                pinyinUnit = [[PinyinUnit alloc] init];
                
                isLastChineseCharacter = FALSE;
                
                startPosition = i;
            }
            
            [nonPinyinString appendFormat:@"%c",c];
        }
        else // 汉字
        {
            if ( FALSE == isLastChineseCharacter) // "...拼音+汉字...(tian田)"这种状态,对之前的tian做处理
            {
                NSString *nonPinyin = [NSString stringWithString:nonPinyinString];
                
                NSArray *temptArray = [NSArray arrayWithObject:nonPinyin];
                
                BKLog(@"pinyinUnits:%@,pinyinUnit:%@,temptArray:%@,startPosition:%zd",pinyinUnits,pinyinUnit,temptArray,startPosition);
                // 非拼音
                [self addPinyinUnitWithPinyinUnits:pinyinUnits andPinyinUnit:pinyinUnit andIsPinyin:FALSE andPinyinArray:temptArray andStartPosition:startPosition];
                
                // 清除操作,不然所有间断的非汉字字符都会拼接在一起
                [nonPinyinString deleteCharactersInRange:NSMakeRange(0, nonPinyinString.length)];
                
                isLastChineseCharacter = TRUE;
            }
            
            // 去除多音字声调相同的情况
            if ([pinyinArray count] > 1)
            {
                NSMutableSet *differentSet = [NSMutableSet set];
                
                for (NSString *str in pinyinArray)
                {
                    [differentSet addObject:str];
                }
                
                pinyinArray = [differentSet allObjects];
            }
            
            pinyinUnit = [[PinyinUnit alloc] init];
            
            startPosition = i;
            
            // 拼音
            [self addPinyinUnitWithPinyinUnits:pinyinUnits andPinyinUnit:pinyinUnit andIsPinyin:TRUE andPinyinArray:pinyinArray andStartPosition:startPosition];
        }
    }
    
    if (FALSE == isLastChineseCharacter) // "...拼音(田tian)"这种状态,对最后的tian做处理
    {
        NSString *nonPinyin = [NSString stringWithString:nonPinyinString];
        
        NSArray *temptArray = @[nonPinyin];
        
        // 非拼音
        [self addPinyinUnitWithPinyinUnits:pinyinUnits andPinyinUnit:pinyinUnit andIsPinyin:FALSE andPinyinArray:temptArray andStartPosition:startPosition];
        
        isLastChineseCharacter = TRUE;
    }
    
}

+ (void)addPinyinUnitWithPinyinUnits:(NSMutableArray *)pinyinUnits andPinyinUnit:(PinyinUnit *)pinyinUnit andIsPinyin:(BOOL)isPinyin andPinyinArray:(NSArray *)pinyinArray andStartPosition:(NSInteger)startPosition
{
    if (pinyinUnit && [NSArray checkArrayIsEmptyOrNil:pinyinArray] == NO)
    {
        [pinyinUnit initPinyinUnitWithIsPinyin:isPinyin andPinyinArray:pinyinArray andStartPosition:startPosition];
        
        [pinyinUnits addObject:pinyinUnit];
    }
    
}

@end
