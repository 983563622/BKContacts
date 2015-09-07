//
//  ContactsCell.h
//  SearchContacts
//
//  Created by apple on 14/11/12.
//  Copyright (c) 2014年 TJF. All rights reserved.
//  联系人cell

#import <UIKit/UIKit.h>
@class SortContact;

@interface ContactCell : UITableViewCell
/**
 *  头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *imageIcon;
/**
 *  姓名
 */
@property (weak, nonatomic) IBOutlet UILabel *name;

/**
 *  搜索电话姓名
 */
@property (weak, nonatomic) IBOutlet UILabel *phonename;

/**
 *  搜索电话
 */
@property (weak, nonatomic) IBOutlet UILabel *phonenum;

/**
 *  数据模型
 */
@property (nonatomic, strong) SortContact *sortContact;

/**
 *  创建cell
 *
 *  @param tableView 所属视图列表
 *
 *  @return ContactCell对象
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (instancetype)initWithTableView:(UITableView *)tableView;

- (void)drawCircleOfIcon;

@end
