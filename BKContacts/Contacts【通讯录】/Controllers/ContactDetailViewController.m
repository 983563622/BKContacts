//
//  ContactDetailViewController.m
//  BKContacts
//
//  Created by apple on 15/7/29.
//  Copyright (c) 2015年 CloudRoom. All rights reserved.
//

#import "ContactDetailViewController.h"
#import "SortContact.h"
#import "ContactDetailCell.h"
#import <AddressBookUI/AddressBookUI.h>
#import "ContactsHelper.h"
#import "UIBarButtonItem+K.h"

static CGFloat const imageHeight = 350;
static CGFloat const iconBorderWidth = 0.5;
static CGFloat const iconBorderCornerRadius = 0.5;

#define kIconBorderColor [UIColor whiteColor].CGColor

typedef NS_ENUM(NSInteger, ActionSheetType)
{
    ActionSheetTypeEdit = 0,
    ActionSheetTypeDelete
};

@interface ContactDetailViewController () < UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, ABNewPersonViewControllerDelegate >

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UIImageView *expandZoomImageView;

@property (nonatomic, strong) UIView *expandZoomView;

@property (nonatomic, assign) ABAddressBookRef addressBookRef;

@property (nonatomic, strong) UIImageView *imageIcon;

@property (nonatomic, strong) UILabel *name;

@end

@implementation ContactDetailViewController
#pragma mark - life cycle
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        if (iOS6_OR_LATER)
        {
            CFErrorRef error;
            
            _addressBookRef = ABAddressBookCreateWithOptions(NULL, &error);
        }
        
        self.navigationItem.title = NSLocalizedString(@"Contact Detail", nil);
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
    // Do any additional setup after loading the view from its nib.
    
    // setup UI Screen
    [self setupUIScreenForContactDetailViewController];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // set the navigationBarHidden of navigationController
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // set the center of expandZoomView
    self.expandZoomView.center = CGPointMake(self.expandZoomImageView.bounds.size.width * 0.5, self.expandZoomImageView.bounds.size.height * 0.5);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    if (_addressBookRef != NULL)
    {
        CFRelease(_addressBookRef);
        
        _addressBookRef = NULL;
    }
    
    self.expandZoomImageView = nil;
    
    self.expandZoomView = nil;
    
    self.imageIcon = nil;
    
    self.name = nil;
    
    self.sortContact = nil;
    
    // remove notification
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"contactChanged" object:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1 + self.sortContact.phones.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // create cell
    ContactDetailCell *cell = [ContactDetailCell cellWithTableView:tableView];
    
    // set properties of cell
    cell.sortContact = self.sortContact;
    
    if (indexPath.row == 0)
    {
        // set phonenum
        [cell.phonenum setText:self.sortContact.phonenum];
        
        // set location
        [cell.location setText:@"本地号码"];
    }
    else // multiple numbers
    {
        SortContact *sortContact = [self.sortContact.phones objectAtIndex:(indexPath.row - 1)];
        
        // set phonenum
        [cell.phonenum setText:sortContact.phonenum];
        
        // set location
        [cell.location setText:@"本地号码"];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)] == YES)
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)] == YES)
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffset = scrollView.contentOffset.y;
    
    if (yOffset <= - imageHeight)
    {
        CGRect f = self.expandZoomImageView.frame;
        
        f.origin.y = yOffset;
        
        f.size.height =  - yOffset;
        
        self.expandZoomImageView.frame = f;
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == ActionSheetTypeEdit) // edit
    {
        if (iOS6_OR_LATER)
        {
            ABRecordID personId = (ABRecordID)self.sortContact.recordID;
            
            ABNewPersonViewController *editPersonViewController = [[ABNewPersonViewController alloc] init];
            
            editPersonViewController.newPersonViewDelegate = self;
            
            editPersonViewController.displayedPerson = ABAddressBookGetPersonWithRecordID(_addressBookRef, personId);
            
            editPersonViewController.navigationItem.title = NSLocalizedString(@"Edit Contact", nil);
            
            BaseNavigationController *newPersonNavigationCntroller = [[BaseNavigationController alloc] initWithRootViewController:editPersonViewController];
            
            [self.navigationController presentViewController:newPersonNavigationCntroller animated:YES completion:nil];
        }
    }
    else if (buttonIndex == ActionSheetTypeDelete) // delete
    {
        if (iOS6_OR_LATER)
        {
            ABRecordID personId = (ABRecordID)self.sortContact.recordID;
            
            ABRecordRef personRef = ABAddressBookGetPersonWithRecordID(self.addressBookRef, personId);
            
            CFErrorRef *error = nil;
            
            BOOL result = ABAddressBookRemoveRecord(self.addressBookRef, personRef, error);
            
            if (result == YES && error == nil)
            {
                // 同步
                ABAddressBookSave(_addressBookRef, NULL);
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}

#pragma mark - ABPersonViewControllerDelegate
- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return YES;
}

#pragma mark - ABNewPersonViewControllerDelegate
- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person
{
    if (person != NULL)
    {
        [self updateTheEditPerson:person];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - event response
- (void)clickToMoreForContactDetailViewController
{
    // create alert
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                               destructiveButtonTitle:NSLocalizedString(@"Edit Contact", nil)
                                                    otherButtonTitles:NSLocalizedString(@"Delete Contact", nil), nil];
    
    // set the index of red btn
    actionSheet.destructiveButtonIndex = 1;
    
    [actionSheet showInView:self.view];
}

#pragma mark - private methods
- (void)setupUIScreenForContactDetailViewController
{
    // set tableView
    self.tableView.contentInset = UIEdgeInsetsMake(imageHeight, 0, 0, 0);
    
    // set expandZoomImageView
    self.expandZoomImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"details_bg.jpg"]];
    
    self.expandZoomImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.expandZoomImageView.frame = CGRectMake(0, - imageHeight, self.view.bounds.size.width, imageHeight);
    
    // set expandZoomView
    self.expandZoomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    
    // set imageIcon
    UIImageView *imageIcon = [[UIImageView alloc] initWithFrame:CGRectMake(25, 0, 100, 100)];
    
    [imageIcon setImage:self.sortContact.image ? self.sortContact.image : [UIImage imageNamed:@"contact_icon_1"]];
    
    // 设置layer圆角
    imageIcon.layer.masksToBounds = YES;
    
    imageIcon.layer.cornerRadius = CGRectGetWidth(imageIcon.bounds) * iconBorderCornerRadius;
    
    imageIcon.layer.borderWidth = iconBorderWidth;
    
    imageIcon.layer.borderColor = kIconBorderColor;
    
    [self.expandZoomView addSubview:imageIcon];
    
    self.imageIcon = imageIcon;
    
    // set name
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 150, 40)];
    
    [name setText:[NSString checkStringIsEmptyOrNil:self.sortContact.name] == YES ? self.sortContact.phonenum : self.sortContact.name];
    
    [name setTextAlignment:NSTextAlignmentCenter];
    
    [self.expandZoomView addSubview:name];
    
    self.name = name;
    
    [self.expandZoomImageView addSubview:self.expandZoomView];
    
    [self.tableView addSubview:self.expandZoomImageView];
    
    // clear unused cell
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    // more
    self.navigationItem.rightBarButtonItems = [UIBarButtonItem barButtonItemWithTarget:self action:@selector(clickToMoreForContactDetailViewController) normalImageName:@"navigationbar_calllog_more_icon_n" highlightedImageName:@"navigationbar_calllog_more_icon_h" fixedSpaceBarButtonItemWidth:-13.0f];
}

- (void)updateTheEditPerson:(ABRecordRef)person
{
    // 获取对应person的RecordID
    ABRecordID personRecordID = ABRecordGetRecordID(person);
    
    // 获取对应person的姓名
    NSMutableString *combineName = [[NSMutableString alloc] init];
    
    // firstName
    NSString *firstName =(__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    
    // lastName
    NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    
    // combine the name
    if(lastName != nil)
    {
        [combineName appendString:lastName];
    }
    
    if(firstName != nil)
    {
        [combineName appendString:firstName];
    }
    
    // 获取对应person的头像
    NSData *iconData = (__bridge_transfer NSData *)ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail);
    
    UIImage *image = [UIImage imageWithData:iconData];
    
    // 获取对应person的电话数组,和emial类似，也分为工作电话，家庭电话，工作传真，家庭传真
    NSArray *phones = [[ContactsHelper shareContactsHelper] arrayProperty:kABPersonPhoneProperty fromRecord:person];
    
    // set the model
    NSInteger phonesCount = [phones count];
    
    SortContact * sortContact = [[SortContact alloc] init];
    
    sortContact.image = image;
    
    sortContact.name = combineName;
    
    sortContact.phonenum = [phones firstObject];
    
    sortContact.recordID = personRecordID;
    
    sortContact.phones = nil;
    
    if (phonesCount > 1) // multiple numbers
    {
        for (NSInteger i = 1; i < phonesCount; i++)
        {
            SortContact *subSortContact = [[SortContact alloc] init];
            
            subSortContact.image = image;
            
            subSortContact.name = combineName;
            
            subSortContact.phonenum = [phones objectAtIndex:i];
            
            subSortContact.recordID = personRecordID;
            
            [sortContact.phones addObject:subSortContact];
        }
    }
    
    self.sortContact = sortContact;
    
    [self.imageIcon setImage:self.sortContact.image ? self.sortContact.image : [UIImage imageNamed:@"contact_icon_1"]];
    
    [self.name setText:[NSString checkStringIsEmptyOrNil:self.sortContact.name] == YES ? self.sortContact.phonenum : self.sortContact.name];
    
    [self.tableView reloadData];
}

@end
