//
//  ContactsCell.m
//  SearchContacts
//
//  Created by apple on 14/11/12.
//  Copyright (c) 2014年 TJF. All rights reserved.
//  联系人cell

#import "ContactCell.h"
#import "SortContact.h"

@interface ContactCell ()

@end

@implementation ContactCell
#pragma mark - life cycle
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        
    }
    
    return self;
}

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

//TODO: 从xib加载时,initWithFrame:和initWithStyle:reuseIdentifier:方法未调用
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        
    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - reload methods
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [self drawCircleOfIcon];
}

#pragma mark - public methods
/**
 *  创建cell
 *
 *  @param tableView tableView
 *
 *  @return UItableViewCell对象
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    return [[self alloc] initWithTableView:tableView];
}

- (instancetype)initWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"ContactCell";
    
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ContactCell" owner:self options:nil] firstObject];
    }
    
    return cell;
}

#pragma mark - private methods
- (void)drawCircleOfIcon
{
//    BKLog(@"%@",NSStringFromCGRect(self.imageIcon.bounds));
    
    // 设置layer圆角
    self.imageIcon.layer.cornerRadius = CGRectGetWidth(self.imageIcon.bounds) * 0.1;
    
    // 遮住它下面所有的layers
    self.imageIcon.layer.masksToBounds = YES;
    
    // 视图渲染内容缓存起来
    self.imageIcon.layer.shouldRasterize = YES;
    
    self.imageIcon.layer.rasterizationScale = [[UIScreen mainScreen] scale];
}

@end

/*
 2015-07-29 18:49:25.750 BKContacts[29772:311649] -[ContactCell drawCircleOfIcon] {{0, 0}, {240, 128}}
 2015-07-29 18:49:25.751 BKContacts[29772:311649] -[ContactCell drawCircleOfIcon] {{0, 0}, {240, 128}}
 2015-07-29 18:49:25.751 BKContacts[29772:311649] -[ContactCell drawCircleOfIcon] {{0, 0}, {240, 128}}
 2015-07-29 18:49:25.751 BKContacts[29772:311649] -[ContactCell drawCircleOfIcon] {{0, 0}, {240, 128}}
 2015-07-29 18:49:25.752 BKContacts[29772:311649] -[ContactCell drawCircleOfIcon] {{0, 0}, {240, 128}}
 2015-07-29 18:49:25.752 BKContacts[29772:311649] -[ContactCell drawCircleOfIcon] {{0, 0}, {240, 128}}
 2015-07-29 18:49:28.316 BKContacts[29772:311649] -[ContactCell drawCircleOfIcon] {{0, 0}, {240, 128}}
 2015-07-29 18:49:28.495 BKContacts[29772:311649] -[ContactCell drawCircleOfIcon] {{0, 0}, {36, 36}}
 2015-07-29 18:49:29.994 BKContacts[29772:311649] -[ContactCell drawCircleOfIcon] {{0, 0}, {36, 36}}
 2015-07-29 18:49:30.112 BKContacts[29772:311649] -[ContactCell drawCircleOfIcon] {{0, 0}, {36, 36}}
 2015-07-29 18:49:30.817 BKContacts[29772:311649] -[ContactCell drawCircleOfIcon] {{0, 0}, {36, 36}}
 2015-07-29 18:49:31.215 BKContacts[29772:311649] -[ContactCell drawCircleOfIcon] {{0, 0}, {36, 36}}
 2015-07-29 18:49:31.249 BKContacts[29772:311649] -[ContactCell drawCircleOfIcon] {{0, 0}, {36, 36}}
 2015-07-29 18:49:31.563 BKContacts[29772:311649] -[ContactCell drawCircleOfIcon] {{0, 0}, {36, 36}}
 2015-07-29 18:49:31.914 BKContacts[29772:311649] -[ContactCell drawCircleOfIcon] {{0, 0}, {36, 36}}
 2015-07-29 18:49:31.918 BKContacts[29772:311649] -[ContactCell drawCircleOfIcon] {{0, 0}, {36, 36}}
 2015-07-29 18:49:31.979 BKContacts[29772:311649] -[ContactCell drawCircleOfIcon] {{0, 0}, {36, 36}}
 2015-07-29 18:49:32.028 BKContacts[29772:311649] -[ContactCell drawCircleOfIcon] {{0, 0}, {36, 36}}
 2015-07-29 18:49:32.733 BKContacts[29772:311649] -[ContactCell drawCircleOfIcon] {{0, 0}, {36, 36}}
 2015-07-29 18:49:33.764 BKContacts[29772:311649] -[ContactCell drawCircleOfIcon] {{0, 0}, {36, 36}}
 2015-07-29 18:49:34.281 BKContacts[29772:311649] -[ContactCell drawCircleOfIcon] {{0, 0}, {36, 36}}
 2015-07-29 18:49:34.731 BKContacts[29772:311649] -[ContactCell drawCircleOfIcon] {{0, 0}, {36, 36}}
 2015-07-29 18:49:34.817 BKContacts[29772:311649] -[ContactCell drawCircleOfIcon] {{0, 0}, {36, 36}}
 2015-07-29 18:49:35.415 BKContacts[29772:311649] -[ContactCell drawCircleOfIcon] {{0, 0}, {36, 36}}
 2015-07-29 18:49:35.417 BKContacts[29772:311649] -[ContactCell drawCircleOfIcon] {{0, 0}, {36, 36}}
 2015-07-29 18:49:35.486 BKContacts[29772:311649] -[ContactCell drawCircleOfIcon] {{0, 0}, {36, 36}}
 2015-07-29 18:49:35.548 BKContacts[29772:311649] -[ContactCell drawCircleOfIcon] {{0, 0}, {36, 36}}
 2015-07-29 18:49:36.269 BKContacts[29772:311649] -[ContactCell drawCircleOfIcon] {{0, 0}, {36, 36}}
 
 重写drawRect:方法以后:
 2015-07-29 20:53:01.909 BKContacts[812:7955] -[ContactCell drawCircleOfIcon] {{0, 0}, {36, 36}}
 2015-07-29 20:53:01.910 BKContacts[812:7955] -[ContactCell drawCircleOfIcon] {{0, 0}, {36, 36}}
 2015-07-29 20:53:01.911 BKContacts[812:7955] -[ContactCell drawCircleOfIcon] {{0, 0}, {36, 36}}
 2015-07-29 20:53:01.911 BKContacts[812:7955] -[ContactCell drawCircleOfIcon] {{0, 0}, {36, 36}}
 2015-07-29 20:53:01.912 BKContacts[812:7955] -[ContactCell drawCircleOfIcon] {{0, 0}, {36, 36}}
 2015-07-29 20:53:01.913 BKContacts[812:7955] -[ContactCell drawCircleOfIcon] {{0, 0}, {36, 36}}
 2015-07-29 20:53:03.091 BKContacts[812:7955] -[ContactCell drawCircleOfIcon] {{0, 0}, {36, 36}}
 
 初始化方法调用顺序:
 2015-07-29 20:55:27.494 BKContacts[991:9976] -[ContactCell initWithCoder:]
 2015-07-29 20:55:27.495 BKContacts[991:9976] -[ContactCell awakeFromNib]
 2015-07-29 20:55:27.498 BKContacts[991:9976] -[ContactCell setSelected:animated:]
 2015-07-29 20:55:27.499 BKContacts[991:9976] -[ContactCell initWithCoder:]
 2015-07-29 20:55:27.500 BKContacts[991:9976] -[ContactCell awakeFromNib]
 2015-07-29 20:55:27.501 BKContacts[991:9976] -[ContactCell setSelected:animated:]
 2015-07-29 20:55:27.502 BKContacts[991:9976] -[ContactCell initWithCoder:]
 2015-07-29 20:55:27.503 BKContacts[991:9976] -[ContactCell awakeFromNib]
 2015-07-29 20:55:27.504 BKContacts[991:9976] -[ContactCell setSelected:animated:]
 2015-07-29 20:55:27.505 BKContacts[991:9976] -[ContactCell initWithCoder:]
 2015-07-29 20:55:27.506 BKContacts[991:9976] -[ContactCell awakeFromNib]
 2015-07-29 20:55:27.507 BKContacts[991:9976] -[ContactCell setSelected:animated:]
 2015-07-29 20:55:27.508 BKContacts[991:9976] -[ContactCell initWithCoder:]
 2015-07-29 20:55:27.509 BKContacts[991:9976] -[ContactCell awakeFromNib]
 2015-07-29 20:55:27.512 BKContacts[991:9976] -[ContactCell setSelected:animated:]
 2015-07-29 20:55:27.513 BKContacts[991:9976] -[ContactCell initWithCoder:]
 2015-07-29 20:55:27.514 BKContacts[991:9976] -[ContactCell awakeFromNib]
 2015-07-29 20:55:27.515 BKContacts[991:9976] -[ContactCell setSelected:animated:]
 2015-07-29 20:55:27.522 BKContacts[991:9976] -[ContactCell layoutSubviews]
 2015-07-29 20:55:27.523 BKContacts[991:9976] -[ContactCell layoutSubviews]
 2015-07-29 20:55:27.523 BKContacts[991:9976] -[ContactCell layoutSubviews]
 2015-07-29 20:55:27.523 BKContacts[991:9976] -[ContactCell layoutSubviews]
 2015-07-29 20:55:27.523 BKContacts[991:9976] -[ContactCell layoutSubviews]
 2015-07-29 20:55:27.524 BKContacts[991:9976] -[ContactCell layoutSubviews]
 2015-07-29 20:55:27.526 BKContacts[991:9976] -[ContactCell drawRect:]
 2015-07-29 20:55:27.526 BKContacts[991:9976] -[ContactCell drawCircleOfIcon] {{0, 0}, {36, 36}}
 2015-07-29 20:55:27.528 BKContacts[991:9976] -[ContactCell drawRect:]
 2015-07-29 20:55:27.528 BKContacts[991:9976] -[ContactCell drawCircleOfIcon] {{0, 0}, {36, 36}}
 2015-07-29 20:55:27.529 BKContacts[991:9976] -[ContactCell drawRect:]
 2015-07-29 20:55:27.529 BKContacts[991:9976] -[ContactCell drawCircleOfIcon] {{0, 0}, {36, 36}}
 2015-07-29 20:55:27.530 BKContacts[991:9976] -[ContactCell drawRect:]
 2015-07-29 20:55:27.530 BKContacts[991:9976] -[ContactCell drawCircleOfIcon] {{0, 0}, {36, 36}}
 2015-07-29 20:55:27.531 BKContacts[991:9976] -[ContactCell drawRect:]
 2015-07-29 20:55:27.531 BKContacts[991:9976] -[ContactCell drawCircleOfIcon] {{0, 0}, {36, 36}}
 2015-07-29 20:55:27.532 BKContacts[991:9976] -[ContactCell drawRect:]
 2015-07-29 20:55:27.533 BKContacts[991:9976] -[ContactCell drawCircleOfIcon] {{0, 0}, {36, 36}}
 */
