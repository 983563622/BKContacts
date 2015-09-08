//
//  SortContact.h
//  SearchContacts
//
//  Created by apple on 14/11/12.
//  Copyright (c) 2014年 TJF. All rights reserved.
//  排序的联系人模型

#import "Contact.h"

// 搜索类型
typedef NS_ENUM(NSInteger, ContactSearchType)
{
    ContactSearchByNull,
    ContactSearchByName,
    ContactSearchByPhonenum
};

@interface SortContact : Contact

/**
 *  昵称 ---> pinyin
 */
@property(nonatomic, strong) NSMutableArray *namePinyinUnits;

/**
 *  搜索类型
 */
@property(nonatomic, assign) ContactSearchType searchByType;

/**
 *  搜索关键字
 */
@property(nonatomic, strong) NSMutableString *matchKeywords;

/**
 *  排序关键字
 */
@property (nonatomic, copy) NSString *sortContactKey;

@end
