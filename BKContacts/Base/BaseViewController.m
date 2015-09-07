//
//  BaseViewController.m
//  BKContacts
//
//  Created by apple on 15/7/29.
//  Copyright (c) 2015年 CloudRoom. All rights reserved.
//

#import "BaseViewController.h"

#define kBaseViewBackgroundColor UIColorFromRGB(0xF5F5F5)

@interface BaseViewController ()

@end

@implementation BaseViewController
#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUIScreenForBaseViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - event response
- (void)popToBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - private methods
- (void)setupUIScreenForBaseViewController
{
    // 除去view布局边缘扩展
    [self configureEdgesForExtendedLayout];
    
    // 设置背景颜色
    [self.view setBackgroundColor:kBaseViewBackgroundColor];
    
    if (self.navigationController.viewControllers.count > 1)
    {
        // set custom backBarButtonItem
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem backBarButtonItemWithTarget:self action:@selector(popToBack) normalImageName:@"navigationbar_return_icon_n" highlightedImageName:@"navigationbar_return_icon_h" fixedSpaceBarButtonItemWidth:- 20.0f];
        
        self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
        
        self.navigationItem.hidesBackButton = YES;
    }
}

/**
 *  iOS7新特性,除去view布局边缘扩展
 */
- (void)configureEdgesForExtendedLayout
{
    // view边缘不拓展
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)] == YES)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

@end
