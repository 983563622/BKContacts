//
//  ContactsHelper.m
//  SearchContacts
//
//  Created by apple on 14/11/11.
//  Copyright (c) 2014年 TJF. All rights reserved.
//  通讯录工具类

#import "ContactsHelper.h"
#import "PinYinTool.h"
#import "SortContact.h"
#import "PinyinUnit.h"
#import "BasePinyinUnit.h"
#import "ParsePinyinUtil.h"
#import "T9MatchPinyinUtil.h"
#import "QwertyMatchPinyinUtil.h"
#import "ExecTime.h"
#import "AppDelegate.h"

@interface ContactsHelper ()

@end

@implementation ContactsHelper
#pragma mark - singleton
static ContactsHelper *shareInstance;
+ (instancetype)shareContactsHelper
{
    @synchronized(self)
    {
        if (shareInstance == nil)
        {
            shareInstance = [[self alloc] init];
        }
    }
    
    return shareInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^
    {
        if (shareInstance == nil)
        {
            shareInstance = [super allocWithZone:zone];
        }
    });
    
    return shareInstance;
}

- (void)dealloc
{
    BKLog(@"");
}

#pragma mark - public methods
// load contacts
- (void)contactsLoaded
{
    [self contactsLoadedWithType:ContactsLoadedTypeInitialize andResultBlock:NULL];
}

- (void)contactsLoadedWithResult:(ResultBlock)resultBlock
{
    [self contactsLoadedWithType:ContactsLoadedTypeInitialize andResultBlock:resultBlock];
}

- (void)contactsLoadedWithDelegate:(id<ContactsHelperDelegate>)delegate
{
    self.delegate = delegate;
    
    [self contactsLoaded];
}

// update contacts
- (void)contactsUpdated
{
    [self contactsLoadedWithType:ContactsLoadedTypeUpdate andResultBlock:NULL];
}

- (void)contactsUpdatedWithResult:(ResultBlock)resultBlock
{
    [self contactsLoadedWithType:ContactsLoadedTypeUpdate andResultBlock:resultBlock];
}

// reset contacts
- (void)contactsReset
{
    [self contactsResetWithResultBlock:NULL];
}

- (void)contactsResetWithResult:(ResultBlock)resultBlock
{
    [self contactsResetWithResultBlock:resultBlock];
}

// search contacts
- (void)contactsFilterWithKey:(NSString *)key byType:(ContactsFilterType)filterType
{
    [self contactsFilterWithKey:key byType:filterType andResultBlock:NULL];
}

- (void)contactsFilterWithKey:(NSString *)key byType:(ContactsFilterType)filterType withResult:(ResultBlock)resultBlock
{
    [self contactsFilterWithKey:key byType:filterType andResultBlock:resultBlock];
}

// judge empty of partitionedContactsList
- (BOOL)isEmptyOfPartitionedContactsList
{
    BOOL ret = YES;
    
    for (NSArray *sectionPartitionedContactsList in self.partitionedContactsList)
    {
        if ([NSArray checkArrayIsEmptyOrNil:sectionPartitionedContactsList] == NO)
        {
            ret = NO;
            
            break;
        }
    }
    
    return ret;
}

- (BOOL)checkIsContactWithPhonenum:(NSString *)phonenum andSortContact:(SortContact **)sortContact
{
    for (NSMutableArray *sectionPartitionedContactsList in self.partitionedContactsList)
    {
        for (SortContact *tempSortContact in sectionPartitionedContactsList)
        {
            if ([tempSortContact.phonenum isEqualToString:phonenum] == YES)
            {
                *sortContact = tempSortContact;
                
                return YES;
            }
        }
    }
    
    return NO;
}

#pragma mark - private methods
/**
 *  读取通讯录信息
 *
 *  @param loadedType  加载类型
 *  @param resultBlock 回调block
 */
- (void)contactsLoadedWithType:(ContactsLoadedType)loadedType andResultBlock:(ResultBlock)resultBlock
{
    // 创建子线程,异步操作!!!
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
       if (iOS6_OR_LATER)
       {
           ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
           
           switch (status)
           {
               case kABAuthorizationStatusNotDetermined:
               case kABAuthorizationStatusAuthorized:
               {
                    ABAddressBookRef addressbook = ABAddressBookCreateWithOptions(NULL, NULL);

                    ABAddressBookRequestAccessWithCompletion(addressbook, ^(bool granted, CFErrorRef error)
                    {
                        if (granted == YES)
                        {
                            BKLog(@"authorization of addressbook is success!");

                            [self contactsLoadedWithAddressBookRef:addressbook loadedType:loadedType andResultBlock:resultBlock];
                        }
                        else
                        {
                            BKLog(@"authorization of addressbook is fail!");
                        }

                        if (addressbook)
                        {
                            CFRelease(addressbook);
                        }
                    });

                    break;
               }
               case kABAuthorizationStatusDenied:
               case kABAuthorizationStatusRestricted:
               {
                    // 提示用户通讯录未授权
                    dispatch_async(dispatch_get_main_queue(), ^
                    {
                        [[[UIAlertView alloc] initWithTitle:@"通讯录被禁止访问"
                                                    message:[NSString stringWithFormat:@"请在iPhone的\"设置-隐私-通讯录\"选项中，允许%@访问您的通讯录",NSLocalizedString(@"BKContacts", nil)]
                                                   delegate:nil
                                          cancelButtonTitle:@"知道了"
                                          otherButtonTitles:nil, nil]
                        show];
                    });

                    break;
               }
               default:
                   break;
           }
       }
    });
}

/**
 *  加载所有联系人
 *
 *  @param addressBook 联系人引用
 *  @param loadedType  加载类型
 *  @param resultBlock 回调block
 */
- (void)contactsLoadedWithAddressBookRef:(ABAddressBookRef)addressBook loadedType:(ContactsLoadedType)loadedType andResultBlock:(ResultBlock)resultBlock
{
    NSMutableArray *temptContactsList = [[NSMutableArray alloc] init];
    
    //将通讯录中的信息用数组方式读出
    CFArrayRef peopleRefs = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    // the count of contacts
    CFIndex peopleCount = CFArrayGetCount(peopleRefs); // ABAddressBookGetPersonCount(addressBook)
    
    CGFloat time1 = [ExecTime execTimeBlock:^
    {
        for (CFIndex i = 0; i < peopleCount; i++)
        {
            ABRecordRef personRef = CFArrayGetValueAtIndex(peopleRefs, i);
            
            // 获取对应person的RecordID
            ABRecordID personRecordID = ABRecordGetRecordID(personRef);
            
            // 获取对应person的头像
            NSData *iconData = (__bridge_transfer NSData *)ABPersonCopyImageDataWithFormat(personRef, kABPersonImageFormatThumbnail);
            
            UIImage *image = [UIImage imageWithData:iconData]; // scale:UIScreen.mainScreen.scale
            
            // 获取对应person的姓名
            NSMutableString *combineName = [[NSMutableString alloc] init];
            
            // firstName
            NSString *firstName =(__bridge_transfer NSString *)ABRecordCopyValue(personRef, kABPersonFirstNameProperty);
            
            // lastName
            NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue(personRef, kABPersonLastNameProperty);
            
            // combine the name
            if(lastName != nil)
            {
                [combineName appendString:lastName];
            }
            
            if(firstName != nil)
            {
                [combineName appendString:firstName];
            }
            
            // 读取联系人姓名的第一个汉语拼音，用于排序，调用此方法需要在程序中加载pingyin.h pingyin.c,如有需要请给我联系。
            NSMutableString *sortContactKey = [[NSMutableString alloc] init];
            
            if([NSString checkStringIsEmptyOrNil:combineName] == NO)
            {
                // 拼音转换
                [PinYinTool appendPinYin:combineName andOutStr:sortContactKey];
                
                // 数字或其他字符开头
                if([NSString checkIsStartWithNumberOrOther:sortContactKey])
                {
                    sortContactKey = [NSMutableString stringWithFormat:@"#%@",sortContactKey];
                }
            }
            else
            {
                [sortContactKey appendString:@"#"];
            }
            
            // 获取对应person的电话数组,和emial类似，也分为工作电话，家庭电话，工作传真，家庭传真
            NSArray *phones = [self arrayProperty:kABPersonPhoneProperty fromRecord:personRef];
            
            // 将nickname转化为T9数字
            NSMutableArray *namePinyinUnits = [[NSMutableArray alloc] init];
            
            [ParsePinyinUtil chineseString:combineName translateToPinyinUnit:namePinyinUnits];
            
            // set the model
            NSInteger phonesCount = [phones count];
            
            SortContact * sortContact = [[SortContact alloc] init];
            
            sortContact.image = image;
            
            sortContact.name = combineName;
            
            sortContact.phonenum = [phones firstObject];
            
            sortContact.sortContactKey = sortContactKey;
            
            sortContact.recordID = personRecordID;
            
            sortContact.namePinyinUnits = namePinyinUnits;
            
            sortContact.phones = nil;
            
            if (phonesCount > 1) // multiple numbers
            {
                for (NSInteger i = 1; i < phonesCount; i++)
                {
                    SortContact *subSortContact = [[SortContact alloc] init];
                    
                    subSortContact.image = image;
                    
                    subSortContact.name = combineName;
                    
                    subSortContact.phonenum = [phones objectAtIndex:i];
                    
                    subSortContact.sortContactKey = sortContactKey;
                    
                    subSortContact.recordID = personRecordID;
                    
                    subSortContact.namePinyinUnits = namePinyinUnits;
                    
                    [sortContact.phones addObject:subSortContact];
                }
                
                [temptContactsList addObject:sortContact];
            }
            else // single number
            {
                [temptContactsList addObject:sortContact];
            }
        }
    }];
    
    NSLog(@"%s time1:%f",__func__,time1);
    
    // release
    if (peopleRefs)
    {
        CFRelease(peopleRefs);
    }
    
    // 分别对contactsList,partitionedContactsList赋值
    CGFloat time2 = [ExecTime execTimeBlock:^
    {
        NSArray *contactList = [temptContactsList copy];
        
        self.contactsList = contactList;
    }];
    
    NSLog(@"%s time2:%f",__func__,time2);
    
    CGFloat time3 = [ExecTime execTimeBlock:^
    {
        [self setPartitionedContactsWithContacts:self.contactsList];
    }];
    
    NSLog(@"%s time3:%f",__func__,time3);

    dispatch_async(dispatch_get_main_queue(), ^
    {
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        
        [appDelegate registerAddressBookChanged];
        
        if (loadedType == ContactsLoadedTypeInitialize)
        {
            // callback of block
            if (resultBlock != NULL)
            {
                resultBlock(self, self.partitionedContactsList);
            }
            else
            {
                // callback of delegate
                if ([self.delegate respondsToSelector:@selector(contactsLoaded:)] == YES)
                {
                    [self.delegate contactsLoaded:self.partitionedContactsList];
                }
            }
        }
        else
        {
            // callback of block
            if (resultBlock != NULL)
            {
                resultBlock(self, self.partitionedContactsList);
            }
            else
            {
                // callback of delegate
                if ([self.delegate respondsToSelector:@selector(contactsUpdated:)] == YES)
                {
                    [self.delegate contactsUpdated:self.partitionedContactsList];
                }
            }
        }
    });
}

/**
 *  联系人属性复位
 *
 *  @param ResultBlock 回调block
 */
- (void)contactsResetWithResultBlock:(ResultBlock)ResultBlock
{
    if ([self isEmptyOfPartitionedContactsList] == YES)
    {
        return;
    }
    
    for (NSArray *sectionPartitionedContactsList in self.partitionedContactsList)
    {
        for (SortContact *sortContact in sectionPartitionedContactsList)
        {
            sortContact.searchByType = ContactSearchByNull;
            
            [sortContact.matchKeywords deleteCharactersInRange:NSMakeRange(0, sortContact.matchKeywords.length)];
            
            if ([NSArray checkArrayIsEmptyOrNil:sortContact.phones] == NO) // multiple numbers
            {
                for (SortContact *subSortContact in sortContact.phones)
                {
                    subSortContact.searchByType = ContactSearchByNull;
                    
                    [subSortContact.matchKeywords deleteCharactersInRange:NSMakeRange(0, subSortContact.matchKeywords.length)];
                }
            }
        }
    }
    
    if (ResultBlock != NULL)
    {
        ResultBlock(self, self.partitionedContactsList);
    }
    else
    {
        // callback of delegate
        if ([self.delegate respondsToSelector:@selector(contactsReset:)] == YES)
        {
            [self.delegate contactsReset:self.partitionedContactsList];
        }
    }
}

/**
 *  联系人搜索
 *
 *  @param key         搜索关键字
 *  @param filterType  过滤类型
 *  @param resultBlock 回调block
 */
- (void)contactsFilterWithKey:(NSString *)key byType:(ContactsFilterType)filterType andResultBlock:(ResultBlock)resultBlock
{
    // partitionedContactsList is empty,return
    if ([self isEmptyOfPartitionedContactsList] == YES)
    {
        return;
    }
    
    // clear the searchContactsList
    if ([NSArray checkArrayIsEmptyOrNil:self.searchContactsList] == NO)
    {
        [self.searchContactsList removeAllObjects];
    }
    
    if ([NSString checkStringIsEmptyOrNil:key] == YES) // key is nil or empty,display all the contacts
    {
        // set searchByType,matchKeywords properties
        for (NSArray *sectionPartitionedContactsList in self.partitionedContactsList)
        {
            for (SortContact *sortContact in sectionPartitionedContactsList)
            {
                sortContact.searchByType = ContactSearchByNull;
                
                [sortContact.matchKeywords deleteCharactersInRange:NSMakeRange(0, sortContact.matchKeywords.length)];
                
                [self.searchContactsList addObject:sortContact];
                
                if ([NSArray checkArrayIsEmptyOrNil:sortContact.phones] == NO) // multiple numbers
                {
                    for (SortContact *subSortContact in sortContact.phones)
                    {
                        subSortContact.searchByType = ContactSearchByNull;
                        
                        [subSortContact.matchKeywords deleteCharactersInRange:NSMakeRange(0, subSortContact.matchKeywords.length)];
                        
                        [self.searchContactsList addObject:subSortContact];
                    }
                }
            }
        }
        
        // clear firstNoSearchResultInput
        [self.firstNoSearchResultInput deleteCharactersInRange:NSMakeRange(0, self.firstNoSearchResultInput.length)];
        
        // callback of block
        if (resultBlock != NULL)
        {
            resultBlock(self, [self.searchContactsList copy]);
        }
        else
        {
            // callback of delegate
            if ([self.delegate respondsToSelector:@selector(contactsFilter:)] == YES)
            {
                [self.delegate contactsFilter:[self.searchContactsList copy]];
            }
        }
        
        return;
    }
    
    if ([NSString checkStringIsEmptyOrNil:self.firstNoSearchResultInput] == NO) // 首次未匹配成功的字符串不为空
    {
        if ([key containsWithString:self.firstNoSearchResultInput] == YES) // firstNoSearchResultInput is subSet of key
        {
            BKLog(@"has firstNoSearchResultInput");
            
            // callback of block
            if (resultBlock != NULL)
            {
                resultBlock(self, [self.searchContactsList copy]);
            }
            else
            {
                // callback of delegate
                if ([self.delegate respondsToSelector:@selector(contactsFilter:)] == YES)
                {
                    [self.delegate contactsFilter:[self.searchContactsList copy]];
                }
            }
            
            return;
        }
        else
        {
            [self.firstNoSearchResultInput deleteCharactersInRange:NSMakeRange(0, self.firstNoSearchResultInput.length)];
        }
    }
    
    for (NSArray *sectionPartitionedContactsList in self.partitionedContactsList)
    {
        for (SortContact *sortContact in sectionPartitionedContactsList)
        {
            NSMutableArray *pinyinUnits = [sortContact namePinyinUnits];
            
            NSMutableString *keyword = [[NSMutableString alloc] init];
            
            NSString *name = [sortContact name];
            
            if ((filterType == ContactsFilterTypeQuery ? [QwertyMatchPinyinUtil matchWithPinyinUnits:pinyinUnits andSourceString:name andSearchString:key andKeyword:keyword] : [T9MatchPinyinUtil matchWithPinyinUnits:pinyinUnits andSourceString:name andSearchString:key andKeyword:keyword]) == YES) // search By name
            {
                [sortContact setSearchByType:ContactSearchByName];
                
                [sortContact setMatchKeywords:[NSMutableString stringWithString:keyword]];
                
                [keyword deleteCharactersInRange:NSMakeRange(0, keyword.length)];
                
                [self.searchContactsList addObject:sortContact];
                
                if ([NSArray checkArrayIsEmptyOrNil:sortContact.phones] == NO) // multiple numbers
                {
                    for (SortContact *subSortContact in sortContact.phones)
                    {
                        [subSortContact setSearchByType:ContactSearchByName];
                        
                        [subSortContact setMatchKeywords:sortContact.matchKeywords];
                        
                        [self.searchContactsList addObject:subSortContact];
                    }
                }
            }
            else // search By phoneNumber
            {
                if ([sortContact.phonenum containsWithString:key] == YES)
                {
                    [sortContact setSearchByType:ContactSearchByPhonenum];
                    
                    [sortContact setMatchKeywords:[NSMutableString stringWithString:key]];
                    
                    [self.searchContactsList addObject:sortContact];
                }
                
                if ([NSArray checkArrayIsEmptyOrNil:sortContact.phones] == NO) // multiple numbers
                {
                    for (SortContact *subSortContact in sortContact.phones)
                    {
                        if ([subSortContact.phonenum containsWithString:key] == YES)
                        {
                            [subSortContact setSearchByType:ContactSearchByPhonenum];
                            
                            [subSortContact setMatchKeywords:[NSMutableString stringWithString:key]];
                            
                            [self.searchContactsList addObject:subSortContact];
                        }
                    }
                }
            }
        }
    }
    
    if ([NSArray checkArrayIsEmptyOrNil:self.searchContactsList] == YES &&
        [NSString checkStringIsEmptyOrNil:self.firstNoSearchResultInput] == YES) // search is empty
    {
        [self.firstNoSearchResultInput appendString:key];
    }
    
    // callback of block
    if (resultBlock != NULL)
    {
        resultBlock(self, [self.searchContactsList copy]);
    }
    else
    {
        // callback of delegate
        if ([self.delegate respondsToSelector:@selector(contactsFilter:)] == YES)
        {
            [self.delegate contactsFilter:[self.searchContactsList copy]];
        }
    }
}

/**
 *  联系人分组
 *
 *  @param contacts 未分组的联系人
 */
- (void)setPartitionedContactsWithContacts:(NSArray *)contacts
{
    // get the currentCollation
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    // Provides the list of section titles used to group results (e.g. A-Z,# in US/English)
    NSUInteger sectionCount = [[collation sectionTitles] count]; // 27
    
    //TODO: 每次加载联系人之前先对数组初始化
    NSMutableArray *partitionedContactsList = [NSMutableArray arrayWithCapacity:sectionCount];
    
    for (NSInteger i = 0; i < sectionCount; i++)
    {
        [partitionedContactsList addObject:[[NSMutableArray alloc] init]];
    }
    
    NSMutableArray *hanYuArray = [NSMutableArray array];
    
    NSMutableArray *nonHanYuArray = [NSMutableArray array];
    
    // hanyu and nonhanyu
    for (SortContact *sortContact in contacts)
    {
        if ([PinYinTool isStartWithHanYuPinYin:sortContact.name] == YES)
        {
            [hanYuArray addObject:sortContact];
        }
        else
        {
            [nonHanYuArray addObject:sortContact];
        }
    }
    
    // order
    [hanYuArray sortUsingComparator:^NSComparisonResult(SortContact* obj1, SortContact* obj2)
    {
        return [obj1.sortContactKey compare:obj2.sortContactKey];
    }];
    
    [nonHanYuArray sortUsingComparator:^NSComparisonResult(SortContact* obj1, SortContact* obj2)
    {
        return [obj1.sortContactKey compare:obj2.sortContactKey];
    }];
    
    SortContact *hanYuSortContact = [hanYuArray firstObject];
    
    unichar hanYuCharacter = [hanYuSortContact.sortContactKey characterAtIndex:0];
    
    for (SortContact *sortContact in hanYuArray)
    {
        NSString *currentCharacter = [sortContact.sortContactKey substringToIndex:1];
        
        NSInteger sectionIndex = [ALPHA rangeOfString:currentCharacter].location;
        
        if (hanYuCharacter == [sortContact.sortContactKey characterAtIndex:0])
        {
            [[partitionedContactsList objectAtIndex:sectionIndex] addObject:sortContact];
        }
        else
        {
            hanYuCharacter = [sortContact.sortContactKey characterAtIndex:0];
            
            [[partitionedContactsList objectAtIndex:sectionIndex] addObject:sortContact];
        }
    }
    
    SortContact *nonHanYuSortContact = [nonHanYuArray firstObject];
    
    unichar nonHanYuCharacter = [nonHanYuSortContact.sortContactKey characterAtIndex:0];
    
    for (SortContact *sortContact in nonHanYuArray)
    {
        NSString *currentCharacter = [sortContact.sortContactKey substringToIndex:1];
        
        NSInteger sectionIndex = [ALPHA rangeOfString:currentCharacter].location;
        
        if (nonHanYuCharacter == [sortContact.sortContactKey characterAtIndex:0])
        {
            [[partitionedContactsList objectAtIndex:sectionIndex] addObject:sortContact];
        }
        else
        {
            nonHanYuCharacter = [sortContact.sortContactKey characterAtIndex:0];
            
            [[partitionedContactsList objectAtIndex:sectionIndex] addObject:sortContact];
        }
    }
    
    self.partitionedContactsList = [partitionedContactsList copy];
}

/**
 *  获取联系人电话号码集合
 *
 *  @param property  ABPropertyID
 *  @param recordRef ABRecordRef
 *
 *  @return 电话号码集合
 */
- (NSArray *)arrayProperty:(ABPropertyID)property fromRecord:(ABRecordRef)recordRef
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    [self enumerateMultiValueOfProperty:property fromRecord:recordRef withBlock:^(ABMultiValueRef multiValue, NSUInteger index) {
        NSString *string = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(multiValue, index);
        
        if ([NSString checkStringIsEmptyOrNil:string] == NO)
        {
            // 去除全部特殊字符
            NSMutableString *strippedString = [NSMutableString stringWithCapacity:string.length];
            
            NSScanner *scanner = [NSScanner scannerWithString:string];
            
            NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"+0123456789"];
            
            while ([scanner isAtEnd] == NO)
            {
                NSString *buffer;
                
                if ([scanner scanCharactersFromSet:numbers intoString:&buffer])
                {
                    [strippedString appendString:buffer];
                }
                else
                {
                    [scanner setScanLocation:([scanner scanLocation] + 1)];
                }
            }
            
            string = [NSString stringWithString:strippedString];
            
            [array addObject:string];
        }
    }];
    
    return array.copy;
}

/**
 *  遍历集合
 *
 *  @param property  ABPropertyID
 *  @param recordRef ABRecordRef
 *  @param block     遍历结果block
 */
- (void)enumerateMultiValueOfProperty:(ABPropertyID)property fromRecord:(ABRecordRef)recordRef withBlock:(void (^)(ABMultiValueRef multiValue, NSUInteger index))block
{
    ABMultiValueRef multiValue = ABRecordCopyValue(recordRef, property);
    
    NSUInteger count = (NSUInteger)ABMultiValueGetCount(multiValue);
    
    for (NSUInteger i = 0; i < count; i++)
    {
        block(multiValue, i);
    }
    
    if (multiValue)
    {
        CFRelease(multiValue);
    }
}

#pragma mark - getters and setters
- (NSMutableArray *)searchContactsList
{
    if (_searchContactsList == nil)
    {
        _searchContactsList = [[NSMutableArray alloc] init];
    }
    
    return _searchContactsList;
}

- (NSMutableString *)firstNoSearchResultInput
{
    if (_firstNoSearchResultInput == nil)
    {
        _firstNoSearchResultInput = [[NSMutableString alloc] init];
    }
    
    return _firstNoSearchResultInput;
}

@end
