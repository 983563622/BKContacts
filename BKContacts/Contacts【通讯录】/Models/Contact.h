//
//  Contact.h
//  SearchContacts
//
//  Created by apple on 14/11/12.
//  Copyright (c) 2014年 TJF. All rights reserved.
//  联系人模型

#import <Foundation/Foundation.h>

@interface Contact : NSObject
/**
 *  头像数据
 */
@property(nonatomic, strong) UIImage *image;

/**
 *  显示的姓名
 */
@property(nonatomic, copy) NSString *name;

/**
 *  显示的号码
 */
@property(nonatomic, copy) NSString *phonenum;

/**
 *  归属地
 */
@property(nonatomic, copy) NSString *location;

/**
 *  标准格式的号码
 */
@property(nonatomic, copy) NSString *formatPhonenum;

/**
 *  数据库记录ID
 */
@property(nonatomic, assign) NSInteger recordID;

/**
 *  电子邮箱
 */
@property(nonatomic, copy) NSString *email;

/**
 *  手机号码集合
 */
@property(nonatomic, strong) NSMutableArray *phones;

@end
