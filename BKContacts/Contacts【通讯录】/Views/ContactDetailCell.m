//
//  ContactDetailCell.m
//  CallBar
//
//  Created by apple on 15/4/8.
//  Copyright (c) 2015年 CloudRoom. All rights reserved.
//

#import "ContactDetailCell.h"
#import <MessageUI/MessageUI.h>
#import "SortContact.h"
#import "BaseTabBarController.h"
#import "BaseViewController.h"

@interface ContactDetailCell () < MFMessageComposeViewControllerDelegate >

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ContactDetailCell
#pragma mark - life cycle
- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

#pragma mark - MFMessageComposeViewControllerDelegate
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    switch (result)
    {
        case MessageComposeResultCancelled: //click cancel button
        {
            break;
        }
        case MessageComposeResultFailed: // send failed
        {
            break;
        }
        case MessageComposeResultSent: //do something
        {
            break;
        }
        default:
        {
            break;
        }
    }
}

#pragma mark - event response
- (IBAction)btnClick:(UIButton *)sender
{
    NSInteger index = sender.tag;
    
    switch (index)
    {
        case kContactDetailCellCallBarBtn: // callbar
        {
            
            break;
        }
        case kContactDetailCellCallBtn: // call
        {
            if (iOS8_OR_LATER)
            {
                // 法一:在系统中实现
                NSString *urlString = [NSString stringWithFormat:@"tel://%@",self.sortContact.phonenum];
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            }
            else
            {
                // 法二:在应用中实现
                UIWebView *callWebView = [[UIWebView alloc] init];
                
                NSString *urlString = [NSString stringWithFormat:@"tel://%@",_sortContact.phonenum];
                
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
                
                [callWebView loadRequest:request];
            }
            
            break;
        }
        case kContactDetailCellMSGBtn: // msg
        {
            [self showMessageView:self.sortContact.phonenum title:@"新信息" body:nil];
            
            break;
        }
        default:
            break;
    }
}

#pragma mark - public methods
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    return [[self alloc] initWithTableView:tableView];
}

- (instancetype)initWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"ContactDetailCell";
    
    ContactDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ContactDetailCell" owner:self options:nil] firstObject];
        
        cell.tableView = tableView;
    }
    
    return cell;
}

#pragma mark - private methods
-(void)showMessageView:(NSString *)receiver title:(NSString *)title body:(NSString *)body
{
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    
    if (messageClass)
    {
        if([MFMessageComposeViewController canSendText] == YES)
        {
            MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
            
            controller.recipients = [NSArray arrayWithObject:receiver];
            
            controller.body = body;
            
            controller.messageComposeDelegate = self;
            
            if (self.tableView.delegate != nil)
            {
                BaseViewController *contactDetailViewController = (BaseViewController *)self.tableView.delegate;
                
                [contactDetailViewController presentViewController:controller animated:YES completion:nil];
            }
            
            [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"提示信息"
                                        message:@"该设备不支持短信功能"
                                       delegate:nil
                              cancelButtonTitle:@"关闭"
                              otherButtonTitles:nil, nil]
            show];
        }
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"提示信息"
                                    message:@"iOS版本过低,iOS4.0以上才支持程序内发送短信"
                                   delegate:nil
                          cancelButtonTitle:@"关闭"
                          otherButtonTitles:nil, nil]
        show];
    }
}

@end
