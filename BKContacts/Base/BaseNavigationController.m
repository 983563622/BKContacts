//
//  BaseNavigationController.m
//  BKContacts
//
//  Created by apple on 15/7/29.
//  Copyright (c) 2015年 CloudRoom. All rights reserved.
//

#import "BaseNavigationController.h"

// 导航栏标题的字体
#define kNavigationTitleColor [UIColor blackColor]
#define kNavigationTitleFont [UIFont boldSystemFontOfSize:20]
#define kNavigationItemTextColor UIColorFromRGB(0x1FB461)
#define kNavigationItemTextFont [UIFont systemFontOfSize:15]

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController
#pragma mark - life cycle
+ (void)initialize
{
    // 设置UINavigationBar的主题
    [self setupUINavigationBarTheme];
    
    // 设置UIBarButtonItem的主题
    [self setupUIBarButtonItemTheme];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUIScreenForBaseNavigationController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods
/**
 *  搭建UI界面
 */
- (void)setupUIScreenForBaseNavigationController
{
    
}

// the theme of UINavigationBar
+ (void)setupUINavigationBarTheme
{
    // 通过appearance对象能修改整个项目中所有UIBarButtonItem的样式
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    
    // set background of UINavigationBar before iOS7
    if (!iOS7_OR_LATER)
    {
        [navigationBarAppearance setBackgroundImage:[UIImage imageNamed:@"navigationbar_background"] forBarMetrics:UIBarMetricsDefault];
    }
    
    navigationBarAppearance.barStyle = UIBarStyleDefault; // UIBarStyleBlack,黑色(默认是白色)
    
    //TODO: 在模拟器(iOS7.1)引起崩溃
    // 半透明
//    [navigationBarAppearance setTranslucent:NO];
    
    NSMutableDictionary *textAttrs = [[NSMutableDictionary alloc] init];
    
    // UITextAttributeTextColor --> NSForegroundColorAttributeName
    textAttrs[NSForegroundColorAttributeName] = kNavigationTitleColor;
    
    // UITextAttributeFont  --> NSFontAttributeName
    textAttrs[NSFontAttributeName] = kNavigationTitleFont;
    
    // UIOffsetZero是结构体, 只要包装成NSValue对象, 才能放进字典\数组中
    NSShadow *shadow = [[NSShadow alloc] init];
    
    // 设置投影效果
    shadow.shadowOffset = CGSizeZero;
    
    // UITextAttributeTextShadowColor --> NSShadowAttributeName
    textAttrs[NSShadowAttributeName] = shadow;
    
    // set title of UINavigationBar
    [navigationBarAppearance setTitleTextAttributes:textAttrs];
}

// the theme of UIBarButtonItem
+ (void)setupUIBarButtonItemTheme
{
    // 通过appearance对象能修改整个项目中所有UIBarButtonItem的样式
    UIBarButtonItem *barButtonItemAppearance = [UIBarButtonItem appearance];
    
    // Takes out title
    //TODO: 解决首次进入二级界面返回会出现残影,以后就不会出现了
    [barButtonItemAppearance setBackButtonTitlePositionAdjustment:UIOffsetMake(0, - 60) forBarMetrics:UIBarMetricsDefault];
    
    // for normal status
    NSMutableDictionary *normaltextAttrs = [[NSMutableDictionary alloc] init];
    
    normaltextAttrs[NSForegroundColorAttributeName] = kNavigationItemTextColor;
    
    normaltextAttrs[NSFontAttributeName] = kNavigationItemTextFont;
    
    NSShadow *normalShadow = [[NSShadow alloc] init];
    
    normalShadow.shadowOffset = CGSizeZero;
    
    normaltextAttrs[NSShadowAttributeName] = normalShadow;
    
    // set the title of UIBarButtonItem for normal
    [barButtonItemAppearance setTitleTextAttributes:normaltextAttrs forState:UIControlStateNormal];
    
    // for highlighted status
    NSMutableDictionary *highTextAttrs = [NSMutableDictionary dictionaryWithDictionary:normaltextAttrs];
    
    NSShadow *highlightedShadow = [[NSShadow alloc] init];
    
    highlightedShadow.shadowOffset = CGSizeZero;
    
    highTextAttrs[NSShadowAttributeName] = highlightedShadow;
    
    // set the title of UIBarButtonItem for highlighted
    [barButtonItemAppearance setTitleTextAttributes:highTextAttrs forState:UIControlStateHighlighted];
    
    // disable status
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionaryWithDictionary:normaltextAttrs];
    
    NSShadow *disableShadow = [[NSShadow alloc] init];
    
    disableShadow.shadowOffset = CGSizeZero;
    
    disableTextAttrs[NSShadowAttributeName] = disableShadow;
    
    // set the title of UIBarButtonItem for disable
    [barButtonItemAppearance setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
    
    // set background of UIBarButtonItem
    // 技巧: 为了让某个按钮的背景消失, 可以设置一张完全透明的背景图片
//    [barButtonItemAppearance setBackgroundImage:[UIImage imageNamed:@"navigationbar_button_background"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
}

#pragma mark - reload methods
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([NSArray checkArrayIsEmptyOrNil:self.viewControllers] == NO)
    {
        // 隐藏UITabBar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}

@end
