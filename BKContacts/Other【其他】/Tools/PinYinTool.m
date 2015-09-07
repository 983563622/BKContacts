//
//  PinYinTool.m
//  CloudroomPhone
//
//  Created by lake on 13-10-12.
//  Copyright (c) 2013年 wu lake. All rights reserved.
//

#import "PinYinTool.h"
#import "PinYin4Objc.h"

@interface PinYinTool()

+ (unichar)getSortunichar:(unichar)result;

+ (NSString *)getPinYin:(unichar)cn;

@end

HanyuPinyinOutputFormat *_outputFormat;

@implementation PinYinTool

+ (unichar)getSortunichar:(unichar)result
{
    if(result >= 'a' && result <= 'z')
    {
        return  (result - 'a' + 'A');
    }
    else if(result >= 'A' && result <= 'Z')
    {
        return result;
    }
    else
    {
        return '#';
    }
    
}

+ (NSString *)getPinYin:(unichar)cn
{
    NSArray *pinyins = [PinyinHelper toGwoyeuRomatzyhStringArrayWithChar:cn];
    
    if(pinyins)
    {
        for (NSString *str in pinyins)
        {
            if(str)
            {
                return [str substringToIndex:([str length] - 1)];
            }
        }
    }
    
    return [NSString stringWithFormat:@"%c", cn];
}

+ (unichar)getFirstPinYin:(const unichar)cn
{
    NSString *pinyin = [self getPinYin:cn];
    
    unichar result = cn;
    
    if(pinyin)
    {
        result = [pinyin characterAtIndex:0];
    }
    
    return [self getSortunichar:result];
}

/**
 *  将输入串转换成拼音
 *
 *  @param str    输入串
 *  @param buffer 输出拼音串
 */
+ (void)appendPinYin:(NSString *)str andOutStr:(NSMutableString *)buffer
{
    // 将str全转化为拼音
    NSString *sourceText = str;
    
    if (_outputFormat == nil)
    {
        _outputFormat = [[HanyuPinyinOutputFormat alloc] init];
        
        [_outputFormat setToneType:ToneTypeWithoutTone];
        
        [_outputFormat setVCharType:VCharTypeWithV];
        
        [_outputFormat setCaseType:CaseTypeLowercase];
    }
    
    NSString *outputPinyin=[PinyinHelper toHanyuPinyinStringWithNSString:sourceText withHanyuPinyinOutputFormat:_outputFormat withNSString:@""];
    
    [buffer appendString:[outputPinyin uppercaseString]];
}

+ (BOOL)isStartWithHanYuPinYin:(NSString *)str
{
    if ([NSString checkStringIsEmptyOrNil:str] == YES)
    {
        return NO;
    }
    
    NSString *lowerStr = [str lowercaseString];
    
    unichar ch = [lowerStr characterAtIndex:0];
    
    if (_outputFormat == nil)
    {
        _outputFormat = [[HanyuPinyinOutputFormat alloc] init];
        
        [_outputFormat setToneType:ToneTypeWithoutTone];
        
        [_outputFormat setVCharType:VCharTypeWithV];
        
        [_outputFormat setCaseType:CaseTypeLowercase];
    }
    
    NSArray *resultArray = [PinyinHelper toHanyuPinyinStringArrayWithChar:ch withHanyuPinyinOutputFormat:_outputFormat];
    
    if ([NSArray checkArrayIsEmptyOrNil:resultArray] == NO)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
