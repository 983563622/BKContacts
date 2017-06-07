//
//  ContactsViewController.m
//  BKContacts
//
//  Created by apple on 15/7/29.
//  Copyright (c) 2015年 CloudRoom. All rights reserved.
//

#import "ContactsDelegateViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import "ContactsHelper.h"
#import "ContactCell.h"
#import "SortContact.h"
#import "NSMutableAttributedString+K.h"
#import "UITabBarController+HideTabBar.h"
#import "ContactDetailViewController.h"
#import "UIScrollView+EmptyDataSet.h"

@interface ContactsDelegateViewController () < UITableViewDataSource, UITableViewDelegate, ABNewPersonViewControllerDelegate, ContactsHelperDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate >

@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**
 *  通讯录数据集
 */
@property (nonatomic, copy) NSArray *dataSource;

/**
 *  搜索结果数据集
 */
@property (nonatomic, copy) NSArray *filteredDataSource;

/**
 *  TableView右边的IndexTitles数据集
 */
@property (nonatomic, copy) NSArray *sectionIndexTitles;

@end

@implementation ContactsDelegateViewController
#pragma mark - life cycle
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        // ...
    }
    
    return self;
}

- (void)awakeFromNib
{
    // ...
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUIScreenForContactsDelegateViewController];
}

- (void)viewDidLayoutSubviews
{
    
    [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    _dataSource = nil;
    
    _filteredDataSource = nil;
    
    _sectionIndexTitles = nil;
    
    self.searchDisplayController.searchResultsTableView.emptyDataSetSource = nil;
    
    self.searchDisplayController.searchResultsTableView.emptyDataSetDelegate = nil;
    
    // remove notification
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"contactChanged" object:nil];
    
    BKLog(@"");
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([tableView isEqual:_tableView] == YES)
    {
        return [_dataSource count];
    }
    else // searchResultsTableView
    {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_tableView] == YES)
    {
        return (NSInteger)[[_dataSource objectAtIndex:(NSUInteger)section] count];
    }
    else // searchResultsTableView
    {
        return (NSInteger)[_filteredDataSource count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // create cell
    ContactCell * cell = [ContactCell cellWithTableView:tableView];
    
    SortContact *sortContact = nil;
    
    // get sortContact
    if ([tableView isEqual:_tableView] == YES)
    {
        sortContact = [[_dataSource objectAtIndex:(NSUInteger)[indexPath section]] objectAtIndex:(NSUInteger)[indexPath row]];
    }
    else // searchResultsTableView
    {
        sortContact = [_filteredDataSource objectAtIndex:(NSUInteger)[indexPath row]];
    }
    
    // set sortContact
    cell.sortContact = sortContact;
    
    // set accessoryType
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    // set imageIcon
    if (sortContact.image != nil)
    {
        cell.imageIcon.image = sortContact.image;
    }
    else
    {
        cell.imageIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"contact_icon_%zd",(indexPath.section + indexPath.row) % 4 + 1]];
    }
    
    // set name and phonenum
    switch (sortContact.searchByType)
    {
        case ContactSearchByNull: // search by default
        {
            cell.name.hidden = NO;
            
            cell.phonename.hidden = YES;
            
            cell.phonenum.hidden = YES;
            
            if([NSString checkStringIsEmptyOrNil:sortContact.name] == YES ||
               [sortContact.name isEqualToString:sortContact.phonenum] == YES) // name is nil/@"" or name is equal to phonenum
            {
                [self showView:cell.name WithNormalText:sortContact.phonenum];
            }
            else
            {
                [self showView:cell.name WithNormalText:sortContact.name];
            }
            
            break;
        }
        case ContactSearchByName: // search by name
        {
            cell.name.hidden = YES;
            
            cell.phonename.hidden = NO;
            
            cell.phonenum.hidden = NO;
            
            NSMutableAttributedString *attrString = [NSMutableAttributedString attributeStringWithContent:sortContact.name keyWords:sortContact.matchKeywords];
            
            if ([tableView isEqual:_tableView] == NO)
            {
                [self showView:cell.phonename WithHighLightText:attrString];
                
                [self showView:cell.phonenum WithNormalText:sortContact.phonenum];
            }
            
            break;
        }
        case ContactSearchByPhonenum: // search by phonenum
        {
            cell.name.hidden = YES;
            
            cell.phonename.hidden = NO;
            
            cell.phonenum.hidden = NO;
            
            NSMutableAttributedString *attrString = [NSMutableAttributedString attributeStringWithContent:sortContact.phonenum keyWords:sortContact.matchKeywords];
            
            if ([tableView isEqual:_tableView] == NO)
            {
                [self showView:cell.phonenum WithHighLightText:attrString];
                
                [self showView:cell.phonename WithNormalText:[NSString checkStringIsEmptyOrNil:sortContact.name] == YES ? sortContact.phonenum : sortContact.name];
            }
            
            break;
        }
        default:
            break;
    }
    
    return cell;
}

// list of section titles to display in section index view (e.g. "ABCD...Z#")
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if ([tableView isEqual:_tableView] == YES)
    {
        NSMutableArray *indices = [NSMutableArray array];
        
        for (int i = 0; i < 27; i++)
        {
            [indices addObject:[[ALPHA substringFromIndex:i] substringToIndex:1]];
        }
        
        return indices;
    }
    else // searchResultsTableView
    {
        return nil;
    }
}

// table which section corresponds to section title/index (e.g. "B",1))
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [ALPHA rangeOfString:title].location;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:_tableView] == YES)
    {
        if([[_dataSource objectAtIndex:section] count] <= 0)
        {
            return nil;
        }
        else
        {
            return [_sectionIndexTitles objectAtIndex:(NSUInteger)section];
        }
    }
    else // searchResultsTableView
    {
        return nil;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SortContact *sortContact = nil;
    
    if ([tableView isEqual:_tableView] == YES)
    {
        sortContact = [[_dataSource objectAtIndex:(NSUInteger)[indexPath section]] objectAtIndex:(NSUInteger)[indexPath row]];
    }
    else // searchResultsTableView
    {
        sortContact = [_filteredDataSource objectAtIndex:(NSUInteger)[indexPath row]];
    }
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ContactDetailViewController *contactDetailViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"ContactDetailViewController"];
    
    contactDetailViewController.sortContact = sortContact;
    
    [self.navigationController pushViewController:contactDetailViewController animated:YES];
    
}

#pragma mark - ABNewPersonViewControllerDelegate
- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person
{
    // 关闭添加联系人窗口
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UISearchDisplayDelegate
// 一旦searchBar内容发生变化,则执行这个方法,询问要不要重装searchResultTableView的数据
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
     [self.searchDisplayController.searchBar scopeButtonTitles][[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [self.searchDisplayController.searchBar scopeButtonTitles][searchOption]];
    
    return YES;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    if (iOS8_OR_LATER)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    else if (iOS7_OR_LATER)
    {
        //TODO: 对searchResultsTableView的contentInset/scrollIndicatorInsets作特殊处理
        [tableView setContentInset:UIEdgeInsetsMake(0, 0, 49, 0)]; // UIEdgeInsetsZero
        
        [tableView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, 49, 0)]; // UIEdgeInsetsZero
    }
    
    if (iOS7_OR_LATER)
    {
        [self.tabBarController hideTabBarAnimated:NO];
    }
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView
{
    if (iOS7_OR_LATER)
    {
        [self.tabBarController showTabBarAnimated:NO];
    }
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView
{
    if (iOS8_OR_LATER)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [[ContactsHelper shareContactsHelper] contactsReset];
}

#pragma mark - ContactsHelperDelegate
- (void)contactsLoaded:(NSArray *)contactsList
{
    ContactsHelper *contactsHelper = [ContactsHelper shareContactsHelper];
    
    if ([contactsHelper isEmptyOfPartitionedContactsList] == YES)
    {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"无联系人!"];
    }
    
    _dataSource = contactsList;
    
    [_tableView reloadData];
}

- (void)contactsUpdated:(NSArray *)contactsList
{
    ContactsHelper *contactsHelper = [ContactsHelper shareContactsHelper];
    
    if ([contactsHelper isEmptyOfPartitionedContactsList] == YES)
    {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"无联系人!"];
    }
    
    _dataSource = contactsList;
    
    [_tableView reloadData];
}

- (void)contactsReset:(NSArray *)contactsList
{
    ContactsHelper *contactsHelper = [ContactsHelper shareContactsHelper];
    
    if ([contactsHelper isEmptyOfPartitionedContactsList] == YES)
    {
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"无联系人!"];
    }
    
    _dataSource = contactsList;
    
    [_tableView reloadData];
}

- (void)contactsFilter:(NSArray *)contactsList
{
    _filteredDataSource = contactsList;
    //TODO: 此处无需使用reloadData
}

#pragma mark - DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"无联系人";
    
    return [[NSAttributedString alloc] initWithString:text attributes:nil];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    UISearchBar *searchBar = self.searchDisplayController.searchBar;
    
    NSString *text = [NSString stringWithFormat:@"没有搜索到任何关于 \"%@\"的结果", searchBar.text];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
    
    [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17.0] range:[attributedString.string rangeOfString:searchBar.text]];
    
    return attributedString;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    //TODO: 随便填写一个名称,避免控制台打印:CUICatalog: Invalid asset name supplied:
    return [UIImage imageNamed:@"123"];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    return nil;
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor whiteColor];
}

- (CGPoint)offsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return CGPointMake(0, 0);
}


#pragma mark - DZNEmptyDataSetDelegate
- (BOOL)emptyDataSetShouldShow:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView
{
    BKLog(@"");
}

- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView
{
    BKLog(@"");
}

#pragma mark - event response
- (void)clickToAddContract
{
    ABNewPersonViewController *newPersonViewController = [[ABNewPersonViewController alloc] init];
    
    newPersonViewController.newPersonViewDelegate = self;
    
    // 注意ABNewPersonViewController必须包装一层UINavigationController才能使用,否则不会出现取消和完成按钮,无法进行保存等操作
    BaseNavigationController *navNewPersonViewController = [[BaseNavigationController alloc] initWithRootViewController:newPersonViewController];
    
    [self presentViewController:navNewPersonViewController animated:YES completion:nil];
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    CGFloat height = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    UITableView *tableView = [self.searchDisplayController searchResultsTableView];
    
    UIEdgeInsets inset;
    
    //TODO: 对searchResultsTableView的contentInset/scrollIndicatorInsets作特殊处理
    inset = UIEdgeInsetsMake(0, 0, height + 49, 0);
    
    [tableView setContentInset:inset];
    
    [tableView setScrollIndicatorInsets:inset];
}

- (void)contactChanged:(NSNotification *)notification
{
    // 更新通讯录
    [[ContactsHelper shareContactsHelper] contactsUpdated];
}

#pragma mark - private methods
- (void)setupUIScreenForContactsDelegateViewController
{
    _tableView.rowHeight = 60.0f;
    
    [_tableView flashScrollIndicators];
    
    // clear the unused cell
    _tableView.tableFooterView = [[UIView alloc] init];
    
    self.searchDisplayController.searchResultsTableView.rowHeight = 60.0f;
    
    self.searchDisplayController.searchResultsTableView.tableFooterView = [[UIView alloc] init];
    
    self.searchDisplayController.searchResultsTableView.emptyDataSetSource = self;
    
    self.searchDisplayController.searchResultsTableView.emptyDataSetDelegate = self;
    
    // 隐藏系统的"无结果"
    [self.searchDisplayController setValue:@"" forKey:@"noResultsMessage"];
    
    // add contact
    self.navigationItem.rightBarButtonItems = [UIBarButtonItem barButtonItemWithTarget:self action:@selector(clickToAddContract) normalImageName:@"navigationbar_add_icon_n" highlightedImageName:@"navigationbar_add_icon_h" fixedSpaceBarButtonItemWidth:-16.0f];
    
    ContactsHelper *contactsHelper = [ContactsHelper shareContactsHelper];
    
    contactsHelper.delegate = self;
    
    // 初始化通讯录
    [contactsHelper contactsLoaded];
    
    // register notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contactChanged:) name:@"contactChanged" object:nil];
    
    // 加载本地数据
    [self initDataSource];
}

- (void)initDataSource
{
    _sectionIndexTitles = [UILocalizedIndexedCollation.currentCollation sectionIndexTitles];
    
    // 加载通讯录
    ContactsHelper *contactsHelper = [ContactsHelper shareContactsHelper];
    
    if ([contactsHelper isEmptyOfPartitionedContactsList] == NO)
    {
        _dataSource = contactsHelper.partitionedContactsList;
        
        [_tableView reloadData];
    }
}

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    [[ContactsHelper shareContactsHelper] contactsFilterWithKey:[searchText lowercaseString] byType:ContactsFilterTypeQuery];
}

- (void)showView:(UILabel *)label WithNormalText:(NSString *)text
{
    label.text = nil;
    
    [label setText:text];
}

- (void)showView:(UILabel *)label WithHighLightText:(NSAttributedString *)text
{
    label.attributedText = nil;
    
    [label setAttributedText:text];
}

@end
