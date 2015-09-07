//
//  NSMutableAttributedString+K.h
//  CallBar
//
//  Created by apple on 14/11/29.
//  Copyright (c) 2014年 CloudRoom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (K)
/**
 *  根据关键字返回标记颜色的字符串
 *
 *  @param content  源串
 *  @param keyWords 关键字
 *
 *  @return 标记颜色的字符串
 */
+ (NSMutableAttributedString *)attributeStringWithContent:(NSString *)content keyWords:(NSString *)keyWords;

@end
