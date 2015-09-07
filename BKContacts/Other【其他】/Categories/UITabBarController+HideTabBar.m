//
//  UITabBarController+HideTabBar.m
//  CustomSearch
//
//  Created by apple on 15/7/4.
//  Copyright (c) 2015年 CloudRoom. All rights reserved.
//

#import "UITabBarController+HideTabBar.h"

static NSTimeInterval const animationDuration = 3;
static CGFloat const margin = 0;

CGRect tmpRect;

@implementation UITabBarController (HideTabBar)

- (BOOL)isTabBarHidden
{
    CGRect viewFrame = self.view.frame;
    
    CGRect tabBarFrame = self.tabBar.frame;
    
    return tabBarFrame.origin.y >= viewFrame.size.height;
}

- (void)setTabBarFrame
{
    CGRect tabBarFrame = self.tabBar.frame;
    
    tabBarFrame.origin.y = self.view.frame.size.height - tabBarFrame.size.height;
}


- (void)setTabBarHidden:(BOOL)hidden
{
    [self setTabBarHidden:hidden animated:NO];
}


- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated
{
    BOOL isHidden = self.tabBar.hidden;
    
    UIView *transitionView = [[[self.view.subviews reverseObjectEnumerator] allObjects] lastObject];
    
    if(hidden == isHidden)
    {
        transitionView.frame = tmpRect;
        
        return;
    }
    
    if(transitionView == nil)
    {
        NSLog(@"%s could not get the container view!",__func__);
        
        return;
    }
    
    CGRect viewFrame = self.view.frame;
    
    CGRect tabBarFrame = self.tabBar.frame;
    
    CGRect containerFrame = transitionView.frame;
    
    tabBarFrame.origin.y = viewFrame.size.height - (hidden ? 0 : tabBarFrame.size.height);
    
    containerFrame.size.height = viewFrame.size.height - (hidden ? 0 : tabBarFrame.size.height);
    
    tmpRect = containerFrame;
    
    [UIView animateWithDuration:animationDuration
                     animations:^
    {
                         self.tabBar.frame = tabBarFrame;
                         
                         transitionView.frame = containerFrame;
    }];
}

- (void)hideTabBarAnimated:(BOOL)animated
{
    CGRect statusbarFrame = [UIApplication sharedApplication].statusBarFrame;
    
    CGRect tabBarControllerViewFrame = self.view.frame;
    
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    
    if ([[[UIDevice currentDevice] systemName] floatValue] >= 8.0)
    {
        UIView *contentView;
        
        if ([[self.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] == YES)
        {
            contentView = [self.view.subviews objectAtIndex:1];
        }
        else
        {
            contentView = [self.view.subviews objectAtIndex:0];
        }
        
        contentView.frame = CGRectMake(contentView.bounds.origin.x,  contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height + self.tabBar.frame.size.height + margin);
    }
    
    if (statusbarFrame.size.height > 20)
    {
        tabBarControllerViewFrame.size.height =  screenSize.size.height + self.tabBar.frame.size.height - 20.0;
    }
    else
    {
        tabBarControllerViewFrame.size.height = screenSize.size.height + self.tabBar.frame.size.height;
    }
    
    if (animated == YES)
    {
        [UIView animateWithDuration:0.2 animations:^
        {
            [self.view setFrame:tabBarControllerViewFrame];
        }
        completion:^(BOOL finished)
        {
    
        }];
    }
    else
    {
        [self.view setFrame:tabBarControllerViewFrame];
    }
}
/*
 2015-07-05 11:40:35.660 CustomSearch[648:8218] -[UITabBarController(HideTabBar) hideTabBarAnimated:]:
 self.view.subviews = 
 (
 "<UITransitionView: 0x7fcf28f10f30; frame = (0 0; 320 568); clipsToBounds = YES; autoresize = W+H; layer = <CALayer: 0x7fcf28f112d0>>",
 "<UITabBar: 0x7fcf28da33f0; frame = (0 519; 320 49); autoresize = W+TM; layer = <CALayer: 0x7fcf28da2790>>"
 )
 */

- (void)showTabBarAnimated:(BOOL)animated
{
    CGRect statusbarFrame = [UIApplication sharedApplication].statusBarFrame;
    
    CGRect tabBarControllerFrame = self.view.frame;
    
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    
    if ([[[UIDevice currentDevice] systemName] floatValue] >= 8.0)
    {
        UIView *contentView;
        
        if ([[self.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]])
            contentView = [self.view.subviews objectAtIndex:1];
        else
            contentView = [self.view.subviews objectAtIndex:0];
        
        contentView.frame = CGRectMake(contentView.bounds.origin.x, contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height - self.tabBar.frame.size.height - margin);
    }
    
    if (statusbarFrame.size.height > 20)
    {
        tabBarControllerFrame.size.height =  screenSize.size.height - 20.0;
    }
    else
    {
        tabBarControllerFrame.size.height = screenSize.size.height;
    }
    
    if (animated)
    {
        [UIView animateWithDuration:0.2 animations:^
        {
            [self.view setFrame:tabBarControllerFrame];
        }
        completion:^(BOOL finished)
        {
    
        }];
    }
    else
    {
        [self.view setFrame:tabBarControllerFrame];
    }
}

@end
