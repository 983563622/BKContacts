//
//  Contact.m
//  SearchContacts
//
//  Created by apple on 14/11/12.
//  Copyright (c) 2014年 TJF. All rights reserved.
//  联系人模型

#import "Contact.h"

@implementation Contact
#pragma mark - getters and setters
- (NSMutableArray *)phones
{
    if (_phones == nil)
    {
        _phones = [[NSMutableArray alloc] init];
    }
    
    return _phones;
}

@end
