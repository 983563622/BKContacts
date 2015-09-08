## BKContacts

联系人相关操作

##Description

本Demo集成了联系人的加载,监听联系人改变,联系人增删查改(CRUD)的功能

##Features

1. 通过delegate和block两种方式来实现(二选一)

2. T9和全键盘两种方式进行搜索,高亮匹配的关键字

3. UISearchBar与tableHeaderView的分离

4. 联系人编辑无需进入详情直接进入编辑界面

5. 不管你的Apple ID在多少个设备登录过,联系人改变只更新一次

##Interface

###联系人加载

```objective-c

// 通过block回调初始化通讯录
[[ContactsHelper shareContactsHelper] contactsLoadedWithResult:^ void (ContactsHelper *helper, NSArray *contactsList)
{
    if ([helper isEmptyOfPartitionedContactsList] == YES)
    {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"无联系人!"];
    }
    
    _dataSource = contactsList;
    
    [_tableView reloadData];
}];

or

ContactsHelper *contactsHelper = [ContactsHelper shareContactsHelper];
    
contactsHelper.delegate = self;

// 通过代理回调初始化通讯录
[contactsHelper contactsLoaded];
```

###联系人改变监听

```objective-c
@interface AppDelegate ()

// 通讯录是否注册监听改变
@property (nonatomic, assign) BOOL hasRegisterAddressBookChanged;

// 通讯录
@property (nonatomic, assign) ABAddressBookRef addressBook;

@end

#pragma mark - life cycle
- (void)dealloc
{
    // 移除注册通讯录监听
    [self unregisterAddressBookChanged];
    
    if (_addressBook)
    {
        CFRelease(_addressBook);
        
        _addressBook = NULL;
    }
}

#pragma mark - UIApplicationDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    _addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    
    _hasRegisterAddressBookChanged = NO;
    
    // 添加通信录变化监听
    [self registerAddressBookChanged];
    
    return YES;
}

#pragma mark - event response
/**
 *  回调函数
 *  如果通讯录发生变化就会调用此方法
 *  @param addressBook 通讯录句柄
 *  @param info        info description
 *  @param context     context description
 */
void AddressBookContactsChangedCallback(ABAddressBookRef addressBook,CFDictionaryRef info,void *context)
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    if (appDelegate.hasRegisterAddressBookChanged == YES)
    {
        [appDelegate unregisterAddressBookChanged]; // or will more than once
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"contactChanged" object:appDelegate userInfo:nil];
}

#pragma mark - public methods
/**
 *  注册回调函数
 */
- (void)registerAddressBookChanged
{
    if (_hasRegisterAddressBookChanged == NO)
    {
        ABAddressBookRegisterExternalChangeCallback(_addressBook, AddressBookContactsChangedCallback, (__bridge void *)(self));
        
        _hasRegisterAddressBookChanged = YES;
    }
}

/**
 *  移除回调函数
 */
- (void)unregisterAddressBookChanged
{
    if (_hasRegisterAddressBookChanged == YES)
    {
        ABAddressBookUnregisterExternalChangeCallback(_addressBook, AddressBookContactsChangedCallback, (__bridge void *)(self));
        
        _hasRegisterAddressBookChanged = NO;
    }
}
```

###联系人操作

```objective-c
// 更新联系人
[[ContactsHelper shareContactsHelper] contactsUpdatedWithResult:^(ContactsHelper *helper, NSArray *contactsList)
{
    if ([helper isEmptyOfPartitionedContactsList] == YES)
    {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"无联系人!"];
    }
    
    _dataSource = contactsList;
    
    [_tableView reloadData];
}];

// 查找联系人
[[ContactsHelper shareContactsHelper] contactsFilterWithKey:[searchText lowercaseString] byType:ContactsFilterTypeQuery withResult:^ void (ContactsHelper *helper, NSArray *contactsList)
{
    _filteredDataSource = contactsList;
    //TODO: 此处无需使用reloadData
}];

// 查找联系人以后对联系人属性复位
[[ContactsHelper shareContactsHelper] contactsResetWithResult:^ void (ContactsHelper *helper, NSArray *contactsList)
{
    if ([helper isEmptyOfPartitionedContactsList] == YES)
    {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"无联系人!"];
    }
    
    _dataSource = contactsList;
    
    [_tableView reloadData];
}];
```

##Vendors

###the third:
[DZNEmptyDataSet](https://github.com/dzenbot/DZNEmptyDataSet)

[TapkuLibrary](https://github.com/devinross/tapkulibrary)

[PinYin4Objc](https://github.com/kimziv/PinYin4Objc)

###ours:
[T9ParseAndMatch for iOS](https://github.com/BossKing/BKContacts)

[T9ParseAndMatch for Android](https://github.com/handsomezhou/PinyinSearchLibrary)

##效果图

<img src="https://github.com/BossKing/BKContacts/blob/master/BKContacts.gif"/>

## Requirements

| BKContacts Version | Minimum iOS Target  | Minimum OS X Target  |                                   Notes                                   |
|:--------------------:|:---------------------------:|:----------------------------:|:-------------------------------------------------------------------------:|
|          1.x         |            iOS 7            |           OS X 10.9          |        |                                                                           |

## Related introduction

[Android Pinyin search contacts analysis and implementation](http://blog.csdn.net/zjqyjg/article/details/41360769)

[Android T9 search contacts analysis and implementation](http://blog.csdn.net/zjqyjg/article/details/41182911)

[Android Qwerty search contacts analysis and implementation](http://blog.csdn.net/zjqyjg/article/details/41318907)

