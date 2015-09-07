//
//  T9MatchPinyinUtil.m
//  CallBar
//
//  Created by apple on 14/11/26.
//  Copyright (c) 2014年 CloudRoom. All rights reserved.
//  T9匹配工具类

#import "T9MatchPinyinUtil.h"
#import "PinyinUnit.h"
#import "BasePinyinUnit.h"

@implementation T9MatchPinyinUtil
#pragma mark - public methods
/**
 *  match pinyinUnits
 *
 *  @param pinyinUnits  pinyinUnits
 *  @param sourceString the original string which be parsed to PinyinUnit
 *  @param searchString search key words
 *  @param keyword      the subString of sourceString
 *
 *  @return YES/NO
 */
+ (BOOL)matchWithPinyinUnits:(NSMutableArray *)pinyinUnits andSourceString:(NSString *)sourceString andSearchString:(NSString *)search andKeyword:(NSMutableString *)keyword
{
    if ((pinyinUnits == nil) || (search == nil) || (keyword == nil))
    {
        return FALSE;
    }
    
    NSInteger pinyinUnitsCount = pinyinUnits.count;
    
    NSMutableString *searchBuffer = [[NSMutableString alloc] init];
    /*
     田进峰:
     (isPinyin,startPosition,(pinyin,number))
     pinyinUnits[0]:
     (1,0,(tian,8426))
     pinyinUnits[1]:
     (1,1,(jin,546))
     pinyinUnits[2]:
     (1,2,(feng,3364))
     */
    
    for (NSInteger i = 0; i < pinyinUnitsCount; i++)
    {
        NSInteger j = 0;
        
        [keyword deleteCharactersInRange:NSMakeRange(0, keyword.length)];
        
        [searchBuffer deleteCharactersInRange:NSMakeRange(0, searchBuffer.length)];
        
        [searchBuffer appendString:search];
        
        BOOL isFound = [self findWithPinyinUnits:pinyinUnits andPinyinUnitIndex:i andT9PinyinUnitIndex:j andSourceString:sourceString andSearchBuffer:searchBuffer andKeyword:keyword];
        
        if (TRUE == isFound)
            return TRUE;
    }
    
    return FALSE;
}
#pragma mark - private methods
/**
 *  match search string with pinyinUnits,if success,save the keywords
 *
 *  @param pinyinUnits       pinyinUnits
 *  @param pinyinUnitIndex   pinyinUnit index
 *  @param t9PinyinUnitIndex t9PinyinUnit index
 *  @param sourceString      name
 *  @param searchBuffer      search string
 *  @param keyword           save the keyword
 *
 *  @return YES/NO
 */
+ (BOOL)findWithPinyinUnits:(NSMutableArray *)pinyinUnits andPinyinUnitIndex:(NSInteger)pinyinUnitIndex andT9PinyinUnitIndex:(NSInteger)t9PinyinUnitIndex andSourceString:(NSString *)sourceString andSearchBuffer:(NSMutableString *)searchBuffer andKeyword:(NSMutableString *)keyword
{
    if ((pinyinUnits == nil) || (sourceString == nil) || (searchBuffer == nil) || (keyword == nil))
    {
        return FALSE;
    }
    
    NSString *search = [NSString stringWithString:searchBuffer];
    
    if ([NSString checkStringIsEmptyOrNil:search] == YES)
    {
        return TRUE;
    }
    
    if (pinyinUnitIndex >= pinyinUnits.count)
    {
        return FALSE;
    }
    
    PinyinUnit *pinyinUnit = pinyinUnits[pinyinUnitIndex];
    
    if (t9PinyinUnitIndex >= pinyinUnit.basePinyinUnits.count)
    {
        return FALSE;
    }
    
    BasePinyinUnit *basePinyinUnit = pinyinUnit.basePinyinUnits[t9PinyinUnitIndex];
    
    /*
     田进峰:
     (isPinyin,startPosition,(pinyin,number))
     pinyinUnits[0]:
     (1,0,(tian,8426))
     pinyinUnits[1]:
     (1,1,(jin,546))
     pinyinUnits[2]:
     (1,2,(feng,3364))
     */
    
    if (pinyinUnit.isPinyin == YES) // pure pinyin
    {
        if ([search hasPrefix:[basePinyinUnit.number substringWithRange:NSMakeRange(0, 1)]] == YES) // match pinyin first character
        {
            [searchBuffer deleteCharactersInRange:NSMakeRange(0, 1)];// delete the match character
            
            [keyword appendString:[sourceString substringWithRange:NSMakeRange(pinyinUnit.startPosition, 1)]];
            
            BOOL isFound = [self findWithPinyinUnits:pinyinUnits andPinyinUnitIndex:pinyinUnitIndex + 1 andT9PinyinUnitIndex:0 andSourceString:sourceString andSearchBuffer:searchBuffer andKeyword:keyword];
            
            if (TRUE == isFound)
            {
                return TRUE;
            }
            else
            {
                [searchBuffer insertString:[basePinyinUnit.number substringWithRange:NSMakeRange(0, 1)] atIndex:0];
                
                [keyword deleteCharactersInRange:NSMakeRange(keyword.length - 1, 1)];
            }
        }
        if ([basePinyinUnit.number hasPrefix:search] == YES)
        {
            [keyword appendString:[sourceString substringWithRange:NSMakeRange(pinyinUnit.startPosition, 1)]];
            
            [searchBuffer deleteCharactersInRange:NSMakeRange(0, searchBuffer.length)];
            
            return TRUE;
        }
        else if ([search hasPrefix:basePinyinUnit.number] == YES) // match quanPinyin success
        {
            [searchBuffer deleteCharactersInRange:NSMakeRange(0, basePinyinUnit.number.length)];
            
            [keyword appendString:[sourceString substringWithRange:NSMakeRange(pinyinUnit.startPosition, 1)]];
            
            BOOL isFound = [self findWithPinyinUnits:pinyinUnits andPinyinUnitIndex:pinyinUnitIndex + 1 andT9PinyinUnitIndex:0 andSourceString:sourceString andSearchBuffer:searchBuffer andKeyword:keyword];
            
            if (TRUE == isFound)
            {
                return TRUE;
            }
            else
            {
                [searchBuffer insertString:basePinyinUnit.number atIndex:0];
                
                [keyword deleteCharactersInRange:NSMakeRange(keyword.length - 1, 1)];
            }
        }
        else // mismatch
        {
            BOOL isFound = [self findWithPinyinUnits:pinyinUnits andPinyinUnitIndex:pinyinUnitIndex andT9PinyinUnitIndex:t9PinyinUnitIndex + 1 andSourceString:sourceString andSearchBuffer:searchBuffer andKeyword:keyword];
            
            if (TRUE == isFound)
                return TRUE;
        }
    }
    else // non-pure pinyin
    {
        if ([basePinyinUnit.number hasPrefix:search] == YES) // The searchBuffer is a subset of t9PinyinUnit.number
        {
            NSInteger startIndex = 0;
            
            [keyword appendString:[sourceString substringWithRange:NSMakeRange(startIndex +pinyinUnit.startPosition, search.length)]];
            
            [searchBuffer deleteCharactersInRange:NSMakeRange(0, searchBuffer.length)];
            
            return TRUE;
        }
        else if ([search hasPrefix:basePinyinUnit.number] == YES) // The t9PinyinUnit.number is a subset of searchBuffer
        {
            NSInteger startIndex = 0;
            
            [searchBuffer deleteCharactersInRange:NSMakeRange(0, basePinyinUnit.number.length)];
            
            [keyword appendString:[sourceString substringWithRange:NSMakeRange(startIndex + pinyinUnit.startPosition, basePinyinUnit.number.length)]];
            
            BOOL isFound = [self findWithPinyinUnits:pinyinUnits andPinyinUnitIndex:pinyinUnitIndex + 1 andT9PinyinUnitIndex:0 andSourceString:sourceString andSearchBuffer:searchBuffer andKeyword:keyword];
            
            if (TRUE == isFound)
            {
                return TRUE;
            }
            else
            {
                [searchBuffer insertString:basePinyinUnit.number atIndex:0];
                
                [keyword deleteCharactersInRange:NSMakeRange(keyword.length - basePinyinUnit.number.length, basePinyinUnit.number.length)];
            }
        }
        else if (keyword.length <= 0)
        {
            if ([basePinyinUnit.number containsWithString:search] == YES)
            {
                NSInteger index = [basePinyinUnit.number rangeOfString:search].location;
                
                [keyword appendString:[sourceString substringWithRange:NSMakeRange(index + pinyinUnit.startPosition, search.length)]];
                
                [searchBuffer deleteCharactersInRange:NSMakeRange(0, searchBuffer.length)];
                
                return TRUE;
            }
            else
            {
                NSInteger numLength = basePinyinUnit.number.length;
                
                for (NSInteger i = 0; i < numLength; i++)
                {
                    NSString *subStr = [basePinyinUnit.number substringFromIndex:i];
                    
                    if ([search hasPrefix:subStr] == YES)
                    {
                        [searchBuffer deleteCharactersInRange:NSMakeRange(0, subStr.length)];
                        
                        [keyword appendString:[sourceString substringWithRange:NSMakeRange(i + pinyinUnit.startPosition, subStr.length)]];
                        
                        BOOL isFound = [self findWithPinyinUnits:pinyinUnits andPinyinUnitIndex:pinyinUnitIndex + 1 andT9PinyinUnitIndex:0 andSourceString:sourceString andSearchBuffer:searchBuffer andKeyword:keyword];
                        
                        if (TRUE == isFound)
                        {
                            return TRUE;
                        }
                        else
                        {
                            [searchBuffer insertString:[basePinyinUnit.number substringFromIndex:i] atIndex:0];
                            
                            [keyword deleteCharactersInRange:NSMakeRange(keyword.length - subStr.length, subStr.length)];
                        }
                    }
                }
                
                BOOL isFound = [self findWithPinyinUnits:pinyinUnits andPinyinUnitIndex:pinyinUnitIndex andT9PinyinUnitIndex:t9PinyinUnitIndex + 1 andSourceString:sourceString andSearchBuffer:searchBuffer andKeyword:keyword];
                
                if (TRUE == isFound)
                    return TRUE;
            }
        }
        else
        {
            BOOL isFound = [self findWithPinyinUnits:pinyinUnits andPinyinUnitIndex:pinyinUnitIndex andT9PinyinUnitIndex:t9PinyinUnitIndex + 1 andSourceString:sourceString andSearchBuffer:searchBuffer andKeyword:keyword];
            
            if (TRUE == isFound)
                return TRUE;
        }
    }
    
    return FALSE;
}

@end
