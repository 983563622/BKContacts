//
//  PinYinTool.h
//  CloudroomPhone
//
//  Created by lake on 13-10-12.
//  Copyright (c) 2013年 wu lake. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PinYinTool : NSObject

+ (unichar)getFirstPinYin:(unichar const)cn;

// 将输入串转换成拼音
+ (void)appendPinYin:(NSString *)str andOutStr:(NSMutableString *)buffer;

+ (BOOL)isStartWithHanYuPinYin:(NSString *)str;

@end
