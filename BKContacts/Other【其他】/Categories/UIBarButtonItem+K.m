//
//  UIBarButtonItem+K.m
//  BackItemButton
//
//  Created by apple on 15/6/4.
//  Copyright (c) 2015年 CloudRoom. All rights reserved.
//

#import "UIBarButtonItem+K.h"
#import "RightButton.h"
#import "BackButton.h"

@implementation UIBarButtonItem (K)
#pragma mark - public methods
+ (NSArray *)barButtonItemWithTarget:(id)target action:(SEL)action normalImageName:(NSString *)normalImageName highlightedImageName:(NSString *)highlightedImageName fixedSpaceBarButtonItemWidth:(CGFloat)width
{
    RightButton *rightButton = [RightButton buttonWithType:UIButtonTypeCustom];
    
    [rightButton setFrame:CGRectMake(0, 0, 44, 44)];
    
    [rightButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *normalImage = [UIImage imageNamed:normalImageName];
    
    UIImage *highlightedImage = [UIImage imageNamed:highlightedImageName];
    
    if ([[[UIDevice currentDevice] systemName] floatValue] >= 7.0)
    {
        normalImage = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        highlightedImage = [highlightedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    [rightButton setImage:normalImage forState:UIControlStateNormal];
    
    [rightButton setImage:highlightedImage forState:UIControlStateHighlighted];
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil action:nil];
    
    /**
     *  width为负数时，相当于addButtonItem向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
     *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
     */
    negativeSpacer.width = width;
    
    return [NSArray arrayWithObjects:negativeSpacer,rightButtonItem, nil];
}

+ (NSArray *)backBarButtonItemWithTarget:(id)target action:(SEL)action normalImageName:(NSString *)normalImageName highlightedImageName:(NSString *)highlightedImageName fixedSpaceBarButtonItemWidth:(CGFloat)width
{
    BackButton *backButton = [BackButton buttonWithType:UIButtonTypeCustom];
    
    [backButton setFrame:CGRectMake(0, 0, 70, 40)];
    
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *normalImage = [UIImage imageNamed:normalImageName];
    
    UIImage *highlightedImage = [UIImage imageNamed:highlightedImageName];
    
    if ([[[UIDevice currentDevice] systemName] floatValue] >= 7.0)
    {
        normalImage = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        highlightedImage = [highlightedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    [backButton setImage:normalImage forState:UIControlStateNormal];
    
    [backButton setImage:highlightedImage forState:UIControlStateHighlighted];
    
    [backButton setTitle:NSLocalizedString(@"Back", nil) forState:UIControlStateNormal];
    
    [backButton setTitle:NSLocalizedString(@"Back", nil) forState:UIControlStateHighlighted];
    
    [backButton setTitleColor:UIColorFromRGB(0x1FB461) forState:UIControlStateNormal];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    backButtonItem.style = UIBarButtonItemStylePlain;
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil action:nil];
    
    /**
     *  width为负数时，相当于backButtonItem向左移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
     *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
     */
    negativeSpacer.width = width;
    
    return [NSArray arrayWithObjects:negativeSpacer,backButtonItem, nil];
}

@end
