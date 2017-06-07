//
//  ContactsViewController.m
//  BKContacts
//
//  Created by apple on 15/9/6.
//  Copyright (c) 2015年 CloudRoom. All rights reserved.
//

#import "ContactsViewController.h"

@interface ContactsViewController ()

@end

@implementation ContactsViewController
#pragma mark - life cycle
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        if (iOS7_OR_LATER)
        {
            UIImage *normalImage = [UIImage imageNamed:@"tabbar_contact_icon_n"];
            
            UIImage *selectedImage = [UIImage imageNamed:@"tabbar_contact_icon_h"];
            
            self.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            
            self.navigationItem.title = NSLocalizedString(@"Contacts", nil);
        }
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
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *viewController = nil;
    
    switch (indexPath.row)
    {
        case 0:
        {
            viewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"ContactsDelegateViewController"];
            
            break;
        }
        case 1:
        {
            viewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"ContactsBlockViewController"];
            
            break;
        }
        default:
            break;
    }
    
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
