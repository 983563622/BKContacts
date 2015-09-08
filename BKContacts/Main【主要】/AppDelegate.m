//
//  AppDelegate.m
//  BKContacts
//
//  Created by apple on 15/7/29.
//  Copyright (c) 2015年 CloudRoom. All rights reserved.
//

#import "AppDelegate.h"
#import "ContactsHelper.h"

@interface AppDelegate ()

// 通讯录是否注册监听改变
@property (nonatomic, assign) BOOL hasRegisterAddressBookChanged;

// 通讯录
@property (nonatomic, assign) ABAddressBookRef addressBook;

@end

@implementation AppDelegate
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

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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

@end
