//
//  UITabBarController+HideTabBar.h
//  CustomSearch
//
//  Created by apple on 15/7/4.
//  Copyright (c) 2015年 CloudRoom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarController (HideTabBar)

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated;

- (void)hideTabBarAnimated:(BOOL)animated;

- (void)showTabBarAnimated:(BOOL)animated;

@end
