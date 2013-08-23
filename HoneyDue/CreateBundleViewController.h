//
//  CreateBundleViewController.h
//  HoneyDue
//
//  Created by Harry Wang on 7/8/13.
//  Copyright (c) 2013 com.mitch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPlaceHolderTextView.h"
#import "ActionSheetPicker.h"
// Import the two next necessary libraries in the ViewController.h file.
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>

@interface CreateBundleViewController : UIViewController <UIAlertViewDelegate, UITextFieldDelegate, ABPeoplePickerNavigationControllerDelegate, UITableViewDelegate, MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *receiverTextField;
@property (strong, nonatomic) IBOutlet UIPlaceHolderTextView *msgTextView;
@property (strong, nonatomic) IBOutlet UIView *bundleBodyView;
@property (strong, nonatomic) IBOutlet UIImageView *introImageView;
@property (strong, nonatomic) IBOutlet UIButton *contactBtn;
@property (strong, nonatomic) IBOutlet UILabel *contactBtnLabel;
@property (strong, nonatomic) IBOutlet UIButton *noteBtn;
@property (strong, nonatomic) IBOutlet UILabel *noteBtnLabel;
@property (strong, nonatomic) IBOutlet UIView *createBundleView;
@property (strong, nonatomic) IBOutlet UITableView *assetsTableView;
@property (strong, nonatomic) IBOutlet UIButton *dateBtn;
@property (strong, nonatomic) IBOutlet UIView *dueDateView;
@property (strong, nonatomic) IBOutlet UILabel *dueDateLabel;

- (IBAction)back:(id)sender;
- (IBAction)send:(id)sender;
- (IBAction)dateClicked:(id)sender;
- (IBAction)reminderClicked:(id)sender;
- (IBAction)contactClicked:(id)sender;
- (IBAction)noteClicked:(id)sender;

@property (nonatomic, strong) AbstractActionSheetPicker *actionSheetPicker;
@property (nonatomic, strong) NSDate *selectedDate;
// A list to save selected contacts
// The contacts object will allow us to access the device contacts.
@property (nonatomic, retain) ABPeoplePickerNavigationController *contacts;

@end
