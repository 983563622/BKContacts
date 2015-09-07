//
//  QwertyMatchPinyinUtil.m
//  CallBar
//
//  Created by apple on 14/12/1.
//  Copyright (c) 2014年 CloudRoom. All rights reserved.
//

#import "QwertyMatchPinyinUtil.h"
#import "PinyinUnit.h"
#import "BasePinyinUnit.h"

@implementation QwertyMatchPinyinUtil
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
    
    if ([sourceString containsWithString:search] == YES) // search is subset of sourceString
    {
        [keyword appendString:search];
        
        return TRUE;
    }
    
    NSInteger pinyinUnitsCount = [pinyinUnits count];
    
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
        
        // clear keyword and searchBuffer
        [keyword deleteCharactersInRange:NSMakeRange(0, [keyword length])];
        
        [searchBuffer deleteCharactersInRange:NSMakeRange(0, [searchBuffer length])];
        
        [searchBuffer appendString:search];
        
        BOOL isFound = [self findWithPinyinUnits:pinyinUnits andPinyinUnitIndex:i andQwertyPinyinUnitIndex:j andSourceString:sourceString andSearchBuffer:searchBuffer andKeyword:keyword];
        
        if (TRUE == isFound)
        {
            return TRUE;
        }
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
+ (BOOL)findWithPinyinUnits:(NSMutableArray *)pinyinUnits andPinyinUnitIndex:(NSInteger)pinyinUnitIndex andQwertyPinyinUnitIndex:(NSInteger)qwertyPinyinUnitIndex andSourceString:(NSString *)sourceString andSearchBuffer:(NSMutableString *)searchBuffer andKeyword:(NSMutableString *)keyword
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
    
    if (pinyinUnitIndex >= [pinyinUnits count])
    {
        return FALSE;
    }
    
    PinyinUnit *pinyinUnit = pinyinUnits[pinyinUnitIndex];
    
    if (qwertyPinyinUnitIndex >= [pinyinUnit.basePinyinUnits count])
    {
        return FALSE;
    }
    
    BasePinyinUnit *basePinyinUnit = pinyinUnit.basePinyinUnits[qwertyPinyinUnitIndex];
    
    /*
     田进峰:
     pinyinUnits = @[(isPinyin,startPosition,basePinyinUnits)]
     basePinyinUnits = @[(pinyin,number)];
     
     pinyinUnits[0]:
     (1,0,(tian,8426))
     
     pinyinUnits[1]:
     (1,1,(jin,546))
     
     pinyinUnits[2]:
     (1,2,(feng,3364))
     */
    
    if (pinyinUnit.isPinyin == YES)  // pure pinyin
    {
        if ([search hasPrefix:[basePinyinUnit.pinyin substringWithRange:NSMakeRange(0, 1)]] == YES) // match pinyin first character
        {
            [searchBuffer deleteCharactersInRange:NSMakeRange(0, 1)];// delete the match character
            
            [keyword appendString:[sourceString substringWithRange:NSMakeRange(pinyinUnit.startPosition, 1)]];
            
            BOOL isFound = [self findWithPinyinUnits:pinyinUnits andPinyinUnitIndex:pinyinUnitIndex + 1 andQwertyPinyinUnitIndex:0 andSourceString:sourceString andSearchBuffer:searchBuffer andKeyword:keyword];
            
            if (TRUE == isFound)
            {
                return TRUE;
            }
            else
            {
                [searchBuffer insertString:[basePinyinUnit.pinyin substringWithRange:NSMakeRange(0, 1)] atIndex:0];
                
                [keyword deleteCharactersInRange:NSMakeRange(keyword.length - 1, 1)];
            }
        }
        
        if ([basePinyinUnit.pinyin hasPrefix:search] == YES)
        {
            [keyword appendString:[sourceString substringWithRange:NSMakeRange(pinyinUnit.startPosition, 1)]];
            
            [searchBuffer deleteCharactersInRange:NSMakeRange(0, searchBuffer.length)];
            
            return TRUE;
        }
        else if ([search hasPrefix:basePinyinUnit.pinyin] == YES) // match quanPinyin success
        {
            [searchBuffer deleteCharactersInRange:NSMakeRange(0, basePinyinUnit.pinyin.length)];
            
            [keyword appendString:[sourceString substringWithRange:NSMakeRange(pinyinUnit.startPosition, 1)]];
            
            BOOL isFound = [self findWithPinyinUnits:pinyinUnits andPinyinUnitIndex:pinyinUnitIndex + 1 andQwertyPinyinUnitIndex:0 andSourceString:sourceString andSearchBuffer:searchBuffer andKeyword:keyword];
            
            if (TRUE == isFound)
            {
                return TRUE;
            }
            else
            {
                [searchBuffer insertString:basePinyinUnit.pinyin atIndex:0];
                
                [keyword deleteCharactersInRange:NSMakeRange(keyword.length - 1, 1)];
            }
        }
        else // mismatch
        {
            BOOL isFound = [self findWithPinyinUnits:pinyinUnits andPinyinUnitIndex:pinyinUnitIndex andQwertyPinyinUnitIndex:qwertyPinyinUnitIndex + 1 andSourceString:sourceString andSearchBuffer:searchBuffer andKeyword:keyword];
            
            if (TRUE == isFound)
            {
                return TRUE;
            }
        }
    }
    else // non-pure pinyin
    {
        if ([basePinyinUnit.pinyin hasPrefix:search] == YES) // The searchBuffer is a subset of t9PinyinUnit.number
        {
            NSInteger startIndex = 0;
            
            [keyword appendString:[sourceString substringWithRange:NSMakeRange(startIndex +pinyinUnit.startPosition, search.length)]];
            
            [searchBuffer deleteCharactersInRange:NSMakeRange(0, searchBuffer.length)];
            
            return TRUE;
        }
        else if ([search hasPrefix:basePinyinUnit.pinyin] == YES) // The t9PinyinUnit.number is a subset of searchBuffer
        {
            NSInteger startIndex = 0;
            
            [searchBuffer deleteCharactersInRange:NSMakeRange(0, basePinyinUnit.pinyin.length)];
            
            [keyword appendString:[sourceString substringWithRange:NSMakeRange(startIndex + pinyinUnit.startPosition, basePinyinUnit.pinyin.length)]];
            
            BOOL isFound = [self findWithPinyinUnits:pinyinUnits andPinyinUnitIndex:pinyinUnitIndex + 1 andQwertyPinyinUnitIndex:0 andSourceString:sourceString andSearchBuffer:searchBuffer andKeyword:keyword];
            
            if (TRUE == isFound)
            {
                return TRUE;
            }
            else
            {
                [searchBuffer insertString:basePinyinUnit.pinyin atIndex:0];
                
                [keyword deleteCharactersInRange:NSMakeRange(keyword.length - basePinyinUnit.pinyin.length, basePinyinUnit.pinyin.length)];
            }
        }
        else if ([NSString checkStringIsEmptyOrNil:keyword] == YES)
        {
            if ([basePinyinUnit.pinyin containsWithString:search] == YES)
            {
                NSInteger index = [basePinyinUnit.pinyin rangeOfString:search].location;
                
                [keyword appendString:[sourceString substringWithRange:NSMakeRange(index + pinyinUnit.startPosition, search.length)]];
                
                [searchBuffer deleteCharactersInRange:NSMakeRange(0, searchBuffer.length)];
                
                return TRUE;
            }
            else
            {
                NSInteger numLength = basePinyinUnit.pinyin.length;
                
                for (NSInteger i = 0; i < numLength; i++)
                {
                    NSString *subStr = [basePinyinUnit.pinyin substringFromIndex:i];
                    
                    if ([search hasPrefix:subStr] == YES)
                    {
                        [searchBuffer deleteCharactersInRange:NSMakeRange(0, subStr.length)];
                        
                        [keyword appendString:[sourceString substringWithRange:NSMakeRange(i + pinyinUnit.startPosition, subStr.length)]];
                        
                        BOOL isFound = [self findWithPinyinUnits:pinyinUnits andPinyinUnitIndex:pinyinUnitIndex + 1 andQwertyPinyinUnitIndex:0 andSourceString:sourceString andSearchBuffer:searchBuffer andKeyword:keyword];
                        
                        if (TRUE == isFound)
                        {
                            return TRUE;
                        }
                        else
                        {
                            [searchBuffer insertString:[basePinyinUnit.pinyin substringFromIndex:i] atIndex:0];
                            
                            [keyword deleteCharactersInRange:NSMakeRange(keyword.length - subStr.length, subStr.length)];
                        }
                    }
                }
                
                BOOL isFound = [self findWithPinyinUnits:pinyinUnits andPinyinUnitIndex:pinyinUnitIndex andQwertyPinyinUnitIndex:qwertyPinyinUnitIndex + 1 andSourceString:sourceString andSearchBuffer:searchBuffer andKeyword:keyword];
                
                if (TRUE == isFound)
                {
                    return TRUE;
                }
            }
        }
        else
        {
            BOOL isFound = [self findWithPinyinUnits:pinyinUnits andPinyinUnitIndex:pinyinUnitIndex andQwertyPinyinUnitIndex:qwertyPinyinUnitIndex + 1 andSourceString:sourceString andSearchBuffer:searchBuffer andKeyword:keyword];
            
            if (TRUE == isFound)
            {
                return TRUE;
            }
        }
    }
    
    return FALSE;
}

@end
