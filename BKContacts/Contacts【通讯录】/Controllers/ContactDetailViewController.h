//
//  ContactDetailViewController.h
//  BKContacts
//
//  Created by apple on 15/7/29.
//  Copyright (c) 2015年 CloudRoom. All rights reserved.
//

#import "BaseViewController.h"

@class SortContact;

@interface ContactDetailViewController : BaseViewController
/**
 *  模型
 */
@property (nonatomic, strong) SortContact *sortContact;

@end
