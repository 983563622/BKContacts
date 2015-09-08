//
//  ContactsHelper.h
//  SearchContacts
//
//  Created by apple on 14/11/11.
//  Copyright (c) 2014年 TJF. All rights reserved.
//  通讯录工具类

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

/**
 *  联系人加载类型
 */
typedef NS_ENUM(NSInteger, ContactsLoadedType)
{
    ContactsLoadedTypeInitialize, // 首次加载
    ContactsLoadedTypeUpdate, // 更新
};

/**
 *  联系人搜索键盘类型
 */
typedef NS_ENUM(NSInteger, ContactsFilterType)
{
    ContactsFilterTypeT9, // T9搜索
    ContactsFilterTypeQuery // 全键盘搜索
};

@class SortContact, ContactsHelper;

typedef void (^ResultBlock) (ContactsHelper *helper, NSArray *contactsList);

@protocol ContactsHelperDelegate <NSObject>

@optional
/**
 *  加载联系人
 *
 *  @param contactsList 联系人加载列表
 */
- (void)contactsLoaded:(NSArray *)contactsList;

/**
 *  联系人属性复位
 *
 *  @param contactsList 联系人属性复位列表
 */
- (void)contactsReset:(NSArray *)contactsList;

/**
 *  更新联系人
 *
 *  @param contactsList 联系人更新列表
 */
- (void)contactsUpdated:(NSArray *)contactsList;

/**
 *  搜索联系人
 *
 *  @param contactsList 联系人筛选列表
 */
- (void)contactsFilter:(NSArray *)contactsList;

@end

@interface ContactsHelper : NSObject
/**
 *  代理
 */
@property (nonatomic, assign) id<ContactsHelperDelegate> delegate;

/**
 *  联系人列表
 */
@property (nonatomic, copy) NSArray *contactsList;

/**
 *  联系人分组列表
 *
 *  @param contactsList 联系人分组列表
 */
@property (nonatomic, copy) NSArray *partitionedContactsList;

/**
 *  搜索联系人列表
 */
@property (nonatomic, strong) NSMutableArray *searchContactsList;

/**
 *  记录首次未匹配成功的字符串
 */
@property (nonatomic, strong) NSMutableString *firstNoSearchResultInput;

/**
 *  单例接口
 *
 *  @return 单例对象
 */
+ (instancetype)shareContactsHelper;

/**
 *  加载联系人
 */
- (void)contactsLoaded;
- (void)contactsLoadedWithDelegate:(id<ContactsHelperDelegate>)delegate;
- (void)contactsLoadedWithResult:(ResultBlock)resultBlock;

/**
 *  更新联系人
 */
- (void)contactsUpdated;
- (void)contactsUpdatedWithResult:(ResultBlock)resultBlock;

/**
 *  重置联系人属性
 */
- (void)contactsReset;
- (void)contactsResetWithResult:(ResultBlock)resultBlock;

/**
 *  搜索联系人
 *
 *  @param key        关键字
 *  @param filterType 搜索键盘类型
 */
- (void)contactsFilterWithKey:(NSString *)key byType:(ContactsFilterType)filterType;
- (void)contactsFilterWithKey:(NSString *)key byType:(ContactsFilterType)filterType withResult:(ResultBlock)resultBlock;

/**
 *  联系人列表是否为空
 *
 *  @return YES/NO
 */
- (BOOL)isEmptyOfPartitionedContactsList;

/**
 *  判断是否是联系人并返回号码对象的联系人对象
 *
 *  @param phonenum    源号码
 *  @param sortContact 联系人对象
 *
 *  @return YES/NO
 */
- (BOOL)checkIsContactWithPhonenum:(NSString *)phonenum andSortContact:(SortContact **)sortContact;

/**
 *  获取对应联系人号码集
 *
 *  @param property  号码标签
 *  @param recordRef 联系人记录
 *
 *  @return 号码集
 */
- (NSArray *)arrayProperty:(ABPropertyID)property fromRecord:(ABRecordRef)recordRef;

@end
