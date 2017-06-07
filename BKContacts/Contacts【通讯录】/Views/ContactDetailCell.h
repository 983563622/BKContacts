//
//  ContactDetailCell.h
//  CallBar
//
//  Created by apple on 15/4/8.
//  Copyright (c) 2015年 CloudRoom. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kContactDetailCellCallBarBtn 301
#define kContactDetailCellCallBtn 302
#define kContactDetailCellMSGBtn 303

@class SortContact;
@interface ContactDetailCell : UITableViewCell
/**
 *  号码
 */
@property (weak, nonatomic) IBOutlet UILabel *phonenum;

/**
 *  归属地
 */
@property (weak, nonatomic) IBOutlet UILabel *location;

/**
 *  传统电话icon
 */
@property (weak, nonatomic) IBOutlet UIButton *callIcon;

/**
 *  第二条分割线
 */
@property (weak, nonatomic) IBOutlet UIImageView *secondLine;

/**
 *  短信icon
 */
@property (weak, nonatomic) IBOutlet UIButton *msgIcon;

/**
 *  数据模型
 */
@property (nonatomic, strong) SortContact *sortContact;

// 创建cell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (instancetype)initWithTableView:(UITableView *)tableView;

// 按钮响应
- (IBAction)btnClick:(UIButton *)sender;


@end
