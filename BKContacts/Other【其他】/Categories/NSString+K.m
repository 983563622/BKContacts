//
//  NSString+K.m
//  SearchContacts
//
//  Created by apple on 14/11/11.
//  Copyright (c) 2014年 TJF. All rights reserved.
//

#import "NSString+K.h"

@implementation NSString (K)
#pragma mark - public methods
/**
 *  判断指定的字符串对象是否为空
 *
 *  @param string 指定的字符串对象
 *
 *  @return 是/否
 */
+ (BOOL)checkStringIsEmptyOrNil:(NSString *)aString
{
    if (aString == nil)
    {
        return YES;
    }
    else
    {
        //TODO: 将@"空格"这种情况去掉
//        NSString *trimedString = [aString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
//        if ([trimedString length] == 0) // empty string
        
        if ([aString length] == 0) // empty string
        {
            return YES;
        }
        else // neither empty nor null
        {
            return NO;
        }
    }
}

/**
 *  是否以数字或其他字符(A~Z或者a~z以外的字符)开头
 *
 *  @param astring 字符串
 *
 *  @return TRUE/FALSE
 */
+ (BOOL)checkIsStartWithNumberOrOther:(NSString *)aString
{
    if (![NSString checkStringIsEmptyOrNil:aString])
    {
        unichar ch = [aString characterAtIndex:0];
        
        if ((ch >= 'A' && ch <= 'Z') || (ch >= 'a' && ch <= 'z'))
        {
            return FALSE;
        }
        else
        {
            return TRUE;
        }
    }
    return FALSE;
}

/**
 *  字符串转数组
 *
 *  @param string 待转字符串
 *
 *  @return 数组
 */
+ (NSArray *)translateToArrayFromString:(NSString *)aString
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    NSInteger stringLength = aString.length;
    
    for (NSInteger i = 0; i < stringLength; i++)
    {
        // one:
//        unichar ch = [string characterAtIndex:i];
//        [tempArray addObject:[NSString stringWithFormat:@"%c",ch]];
        
        // two:
        [tempArray addObject:[aString substringWithRange:NSMakeRange(i, 1)]];
    }
    
    return [NSArray arrayWithArray:tempArray];
}

/**
 *  判断是否包含子串
 *
 *  @param astring 子串
 *
 *  @return YES/NO
 */
- (BOOL)containsWithString:(NSString *)aString
{
    if ([[[UIDevice currentDevice] systemName] floatValue] >= 8.0)
    {
        if ([self containsString:aString] == YES)
        {
            return TRUE;
        }
    }
    else
    {
        if ([self rangeOfString:aString].length > 0)
        {
            return TRUE;
        }
    }
    
    return FALSE;
}

@end
