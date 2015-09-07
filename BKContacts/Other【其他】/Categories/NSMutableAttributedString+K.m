//
//  NSMutableAttributedString+K.m
//  CallBar
//
//  Created by apple on 14/11/29.
//  Copyright (c) 2014年 CloudRoom. All rights reserved.
//

#import "NSMutableAttributedString+K.h"

@implementation NSMutableAttributedString (K)
#pragma mark - public methods
+ (NSMutableAttributedString *)attributeStringWithContent:(NSString *)content keyWords:(NSString *)keyWords
{
    // 设置关键字颜色
    UIColor *color=[UIColor colorWithRed:0.2471 green:0.4588 blue:1 alpha:1];
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:content];
    
    NSRange range = [content rangeOfString:keyWords];
    
    [attString addAttribute:(NSString*)NSForegroundColorAttributeName value:color range:range];
    
    return attString;
}

@end
