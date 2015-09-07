//
//  T9PinyinUnit.m
//  CallBar
//
//  Created by apple on 14/11/25.
//  Copyright (c) 2014年 CloudRoom. All rights reserved.
//

#import "BasePinyinUnit.h"
#import "T9Util.h"

@implementation BasePinyinUnit

#pragma mark - public methods
- (void)initBasePinyinUnitWithPinyin:(NSString *)pinyin
{
    if ([NSString checkStringIsEmptyOrNil:pinyin] == NO)
    {
        self.pinyin = pinyin;
        
        NSInteger pinyinLength = pinyin.length;
        
        NSMutableString *numBuffer = [[NSMutableString alloc] init];
        
        for (NSInteger i = 0; i < pinyinLength; i++)
        {
            // 对应的字母转数字
            unichar c = [T9Util getT9Number:[pinyin characterAtIndex:i]];
            
            [numBuffer appendString:[NSString stringWithFormat:@"%c",c]];
        }
        
        self.number = numBuffer;
    }
}

@end
