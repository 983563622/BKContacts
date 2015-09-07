//
//  PinyinUnit.m
//  CallBar
//
//  Created by apple on 14/11/25.
//  Copyright (c) 2014年 CloudRoom. All rights reserved.
//  一串字符串中的单个词

#import "PinyinUnit.h"
#import "BasePinyinUnit.h"

@implementation PinyinUnit
#pragma mark - public methods
// 相关初始化
- (void)initWithIsPinyin:(BOOL)isPinyin andStartPosition:(NSInteger)startPosition
{
    self.isPinyin = isPinyin;
    
    self.startPosition = startPosition;
}

- (void)initPinyinUnitWithIsPinyin:(BOOL)isPinyin andPinyinArray:(NSArray *)pinyinArray andStartPosition:(NSInteger)startPosition
{
    NSInteger k;
    
    NSInteger pinyinArrayCount = [pinyinArray count];
    
    [self initWithIsPinyin:isPinyin andStartPosition:startPosition];
    
    BasePinyinUnit *basePinyinUnit = nil;
    
    if (FALSE == isPinyin || pinyinArrayCount <= 1) // 特殊字符或者字母
    {
        for (NSInteger i = 0; i < pinyinArrayCount; i++)
        {
            basePinyinUnit = [[BasePinyinUnit alloc] init];
            
            [basePinyinUnit initBasePinyinUnitWithPinyin:pinyinArray[i]];
            
            [self.basePinyinUnits addObject:basePinyinUnit];
        }
    }
    else // 多音汉字
    {
        basePinyinUnit = [[BasePinyinUnit alloc] init];
        
        [basePinyinUnit initBasePinyinUnitWithPinyin:pinyinArray[0]];
        
        [self.basePinyinUnits addObject:basePinyinUnit];
        
        for (NSInteger j = 1; j < pinyinArrayCount; j++)
        {
            NSInteger curStringIndexLength = self.basePinyinUnits.count;
            
            for (k = 0; k < curStringIndexLength; k++)
            {
                if ([[self.basePinyinUnits[k] pinyin] isEqualToString:pinyinArray[j]])
                {
                    break;
                }
            }
            
            if (k == curStringIndexLength)
            {
                basePinyinUnit = [[BasePinyinUnit alloc] init];
                
                [basePinyinUnit initBasePinyinUnitWithPinyin:pinyinArray[j]];
                
                [self.basePinyinUnits addObject:basePinyinUnit];
            }
        }
    }
}

#pragma mark - getters and setters
- (NSMutableArray *)basePinyinUnits
{
    if (_basePinyinUnits == nil)
    {
        _basePinyinUnits = [[NSMutableArray alloc] init];
    }
    return _basePinyinUnits;
}
@end
