//
//  ExecTime.h
//  CallBar
//
//  Created by apple on 15/6/10.
//  Copyright (c) 2015年 CloudRoom. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^execTimeBlock)(void);

@interface ExecTime : NSObject

+ (CGFloat)execTimeBlock:(execTimeBlock)block;

@end
