//
//  MoreViewController.m
//  BKContacts
//
//  Created by apple on 15/7/29.
//  Copyright (c) 2015年 CloudRoom. All rights reserved.
//

#import "MoreViewController.h"

@interface MoreViewController ()

@end

@implementation MoreViewController
#pragma mark - life cycle
//TODO: 此方法不会被调用,从SB加载
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        if (iOS7_OR_LATER)
        {
            UIImage *normalImage = [UIImage imageNamed:@"tabbar_more_icon_n"];
        
            UIImage *selectedImage = [UIImage imageNamed:@"tabbar_more_icon_h"];
            
            self.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        }
        
        self.navigationItem.title = NSLocalizedString(@"More", nil);
    }
    
    return self;
}

- (void)awakeFromNib
{
    // ...
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
