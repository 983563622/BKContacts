//
//  T9Util.h
//  CallBar
//
//  Created by apple on 14/11/26.
//  Copyright (c) 2014年 CloudRoom. All rights reserved.
//  字母对应T9数字

#import <Foundation/Foundation.h>

@interface T9Util : NSObject

/**
 *  字母转化为T9数字
 *
 *  @param alphabet 字母
 *
 *  @return 对应数字
 */
+ (unichar)getT9Number:(unichar)alphabet;

@end
