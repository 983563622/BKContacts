//
//  UIBarButtonItem+K.h
//  BackItemButton
//
//  Created by apple on 15/6/4.
//  Copyright (c) 2015年 CloudRoom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (K)

+ (NSArray *)barButtonItemWithTarget:(id)target action:(SEL)action normalImageName:(NSString *)normalImageName highlightedImageName:(NSString *)highlightedImageName fixedSpaceBarButtonItemWidth:(CGFloat)width;

+ (NSArray *)backBarButtonItemWithTarget:(id)target action:(SEL)action normalImageName:(NSString *)normalImageName highlightedImageName:(NSString *)highlightedImageName fixedSpaceBarButtonItemWidth:(CGFloat)width;

@end
