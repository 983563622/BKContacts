//
//  SortContact.m
//  SearchContacts
//
//  Created by apple on 14/11/12.
//  Copyright (c) 2014年 TJF. All rights reserved.
//  排序的联系人模型

#import "SortContact.h"

@implementation SortContact
#pragma mark - getters and setters
- (NSMutableArray *)namePinyinUnits
{
    if (_namePinyinUnits == nil)
    {
        _namePinyinUnits = [[NSMutableArray alloc] init];
    }
    
    return _namePinyinUnits;
}
@end
