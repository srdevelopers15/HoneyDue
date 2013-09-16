//
//  CreateBundleViewController.m
//  HoneyDue
//
//  Created by Harry Wang on 7/8/13.
//  Copyright (c) 2013 com.mitch. All rights reserved.
//

#import "CreateBundleViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>
#import "ActionSheetPicker.h"
#import "NSDate+TCUtils.h"
#import "ActionSheetPickerCustomPickerDelegate.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "AssetCell.h"

@interface CreateBundleViewController ()

@property (strong, nonatomic) UIActivityIndicatorView *spinner;
- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element;
@property (strong, nonatomic) NSString *dueDateString;
@property (strong, nonatomic) NSMutableArray *tableDataSourceArray;
@property (strong, nonatomic) NSMutableArray *reminderArray;
@property (strong, nonatomic) NSMutableArray *noteArray;
@property (strong, nonatomic) NSMutableArray *contactArray;
@property (strong, nonatomic) NSDate *unformattedDueDate;
@property (strong, nonatomic) NSString *contactType;
@property (strong, nonatomic) NSMutableArray *receiverEmails;

@end

@implementation CreateBundleViewController
@synthesize bundleBodyView;
@synthesize receiverTextField;
@synthesize msgTextView;
@synthesize actionSheetPicker;
@synthesize selectedDate;
@synthesize introImageView;
@synthesize contactBtn;
@synthesize contactBtnLabel;
@synthesize noteBtn;
@synthesize noteBtnLabel;
@synthesize createBundleView;
@synthesize dueDateString;
@synthesize contacts;
@synthesize assetsTableView;
@synthesize tableDataSourceArray;
@synthesize dateBtn;
@synthesize dueDateView;
@synthesize dueDateLabel;
@synthesize reminderArray;
@synthesize noteArray;
@synthesize unformattedDueDate;
@synthesize contactArray;
@synthesize receiverBtn;
@synthesize contactType;
@synthesize receiverEmails;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    CGContextRef context = UIGraphicsGetCurrentContext(); 
    [bundleBodyView.layer setCornerRadius:10.0f];
    [bundleBodyView.layer setMasksToBounds:YES];
    
    dueDateView.layer.cornerRadius = 10.0f;
    dueDateView.layer.masksToBounds = YES;
    
    assetsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [msgTextView setPlaceholder:@"Add a message"];
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.frame = CGRectMake(0.0, 0.0, 80.0, 80.0);
    [self.spinner setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, [[UIScreen mainScreen] bounds].size.height / 2 - 30)]; // I do this because I'm in landscape mode
    [self.view addSubview:self.spinner];
    self.selectedDate = [NSDate date];
    receiverTextField.delegate = self;
    //Add a toolbar upon the keyboard when editting message
    UIToolbar *boolbar = [UIToolbar new];
    boolbar.barStyle = UIBarStyleDefault;
    [boolbar sizeToFit];
    
    UIBarButtonItem *cancelleftBarButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyboard:)];
    NSArray *array = [NSArray arrayWithObjects:cancelleftBarButton, nil];
    [boolbar setItems:array];
    msgTextView.inputAccessoryView = boolbar;
    
    // Init the contactsArray.
    contactArray = [[NSMutableArray alloc] init];
    tableDataSourceArray = [[NSMutableArray alloc] init];
    reminderArray = [[NSMutableArray alloc] init];
    noteArray = [[NSMutableArray alloc] init];
    receiverEmails = [[NSMutableArray alloc] init];
}

- (void)dismissKeyboard:(id)sender {
    [msgTextView resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{}];
}

- (IBAction)send:(id)sender {
    if (receiverTextField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please select a receiver from your contacts." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else if (msgTextView.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please fill in the message you want to send." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else if ([dueDateView isHidden]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please set a due date." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        [self.spinner startAnimating];
        
        PFQuery *query = [PFUser query];
        query.limit = 1000;
        //[query whereKey:@"displayName" equalTo:receiverTextField.text];
        [query whereKey:@"email" containedIn:receiverEmails];
        [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
            [self.spinner stopAnimating];
            // use the number
            if (!error) {
                if (number > 0) {
                    [self saveBundle];
                    [self performSelector:@selector(showSucceedAlert) withObject:nil afterDelay:0.5];
                    [self sendPushNotificationByReceiverName:receiverTextField.text];
                } else {
                    NSString *alertText = [receiverTextField.text stringByAppendingString:@" is not a HoneyDue user, we'll send a email."];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:alertText delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    alert.tag = 1002;
                    [alert show];
                }
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Can not access server now, please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }];
    }
}

- (IBAction)dateClicked:(id)sender {
    if ([msgTextView isFirstResponder]) {
        [msgTextView resignFirstResponder];
    }
    actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDateAndTime selectedDate:self.selectedDate target:self action:@selector(dateWasSelected:element:) origin:sender];
    [self.actionSheetPicker addCustomButtonWithTitle:@"Today" value:[NSDate date]];
    [self.actionSheetPicker addCustomButtonWithTitle:@"Yesterday" value:[[NSDate date] TC_dateByAddingCalendarUnits:NSDayCalendarUnit amount:-1]];
    self.actionSheetPicker.hideCancel = YES;
    [self.actionSheetPicker showActionSheetPicker];
}

- (IBAction)reminderClicked:(id)sender {
    if ([msgTextView isFirstResponder]) {
        [msgTextView resignFirstResponder];
    }
    if ([assetsTableView isHidden]) {
        [assetsTableView setHidden:NO];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Reminder" message:@"" delegate:self cancelButtonTitle:@"Done" otherButtonTitles:@"Cancel", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 1000;
    [alert show];
}

// Using this action we will allow the user to have access to device contacts.
- (IBAction)contactClicked:(id)sender {
    contactType = @"contact";
    if ([msgTextView isFirstResponder]) {
        [msgTextView resignFirstResponder];
    }
    if ([assetsTableView isHidden]) {
        [assetsTableView setHidden:NO];
    }
        
    // Preparation complete. Display the contacts view controller.
    [self presentViewController:contacts animated:YES completion:^{}];
}

- (IBAction)noteClicked:(id)sender {
    if ([msgTextView isFirstResponder]) {
        [msgTextView resignFirstResponder];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Note" message:@"" delegate:self cancelButtonTitle:@"Done" otherButtonTitles:@"Cancel", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 1001;
    [alert show];
}

- (IBAction)selectReceiver:(id)sender {
    contactType = @"receiver";
    // Init the contacts object.
    contacts = [[ABPeoplePickerNavigationController alloc] init];
    
    // Set the delegate.
	[contacts setPeoplePickerDelegate:self];
    
    // Set the e-mail property as the only one that we want to be displayed in the Address Book.
	//[contacts setDisplayedProperties:[NSArray arrayWithObject:[NSNumber numberWithInt:kABPersonEmailProperty]]];
    NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty],
                               [NSNumber numberWithInt:kABPersonEmailProperty],
                               [NSNumber numberWithInt:kABPersonSocialProfileProperty], nil];
    contacts.displayedProperties = displayedItems;
    // Preparation complete. Display the contacts view controller.
    [self presentViewController:contacts animated:YES completion:^{}];
}

- (void)setContactAndNoteEnable {
    if (![contactBtn isEnabled]) {
        [contactBtn setEnabled:YES];
        contactBtnLabel.textColor = [UIColor darkGrayColor];
    }
    if (![noteBtn isEnabled]) {
        [noteBtn setEnabled:YES];
        noteBtnLabel.textColor = [UIColor darkGrayColor];
    }
}

- (void)setContactAndNoteUnable {
    if ([contactBtn isEnabled]) {
        [contactBtn setEnabled:NO];
        contactBtnLabel.textColor = [UIColor lightGrayColor];
    }
    if ([noteBtn isEnabled]) {
        [noteBtn setEnabled:NO];
        noteBtnLabel.textColor = [UIColor lightGrayColor];
    }
}

- (void)dateWasSelected:(NSDate *)date element:(id)element {
    [self setContactAndNoteEnable];
    if ([dueDateView isHidden]) {
        [introImageView setHidden:YES];
        [dueDateView setHidden:NO];
    }
    self.selectedDate = date;
    unformattedDueDate = date;
    dueDateString = [self dateToString:self.selectedDate];
    dueDateLabel.text = dueDateString;
}

- (NSString *)dateToString:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [formatter stringFromDate:date];
}

- (void)saveBundle {
    PFObject *bundle = [PFObject objectWithClassName:@"bundle"];
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"];
    if (name) {
        [bundle setObject:name forKey:@"ownerName"];
        NSString *avatarUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_picture_url"];
        [bundle setObject:avatarUrl forKey:@"avatarUrl"];
    }
    [bundle setObject:receiverTextField.text forKey:@"receiver"];
    [bundle setObject:msgTextView.text forKey:@"msg"];
    [bundle setObject:[NSNumber numberWithBool:NO] forKey:@"readThisBundle"];
    NSString *currentDateString = [self getCurrentDateString];
    [bundle setObject:currentDateString forKey:@"date"];
    NSString *currentTimeString = [self getCurrentTimeString];
    [bundle setObject:currentTimeString forKey:@"time"];
    [bundle setObject:dueDateString forKey:@"dueDate"];
    [bundle setObject:reminderArray forKey:@"reminders"];
    [bundle setObject:noteArray forKey:@"notes"];
    [bundle setObject:contactArray forKey:@"contacts"];
    [bundle setObject:unformattedDueDate forKey:@"unformattedDueDate"];
    [bundle saveInBackground];
}

- (void)clearContent {
    receiverTextField.text = @"";
    msgTextView.text = @"";
    [receiverBtn setTitle:@"Who is this for?" forState:UIControlStateNormal];
    //[assetsScrollView setHidden:YES];
    [introImageView setHidden:NO];
    [assetsTableView setHidden:YES];
    dueDateString = @"";
    dueDateLabel.text = @"";
    unformattedDueDate = nil;
    [dueDateView setHidden:YES];
    [reminderArray removeAllObjects];
    [noteArray removeAllObjects];
    [contactArray removeAllObjects];
    [tableDataSourceArray removeAllObjects];
    if ([receiverTextField isFirstResponder]) {
        [receiverTextField resignFirstResponder];
    }
    if ([msgTextView isFirstResponder]) {
        [msgTextView resignFirstResponder];
    }
    [self setContactAndNoteUnable];
    [assetsTableView reloadData];
}

//Send Push notification to  friend
- (void)sendPushNotificationByReceiverName:(NSString *)name {
    // get the PFUser object for current user
    PFQuery *userQuery=[PFUser query];
    [userQuery whereKey:@"displayName" equalTo:name];//ClientFBId is my friend's FB id
    // send push notification to the user
    PFQuery *pushQuery = [PFInstallation query];
    [pushQuery whereKey:@"Owner" matchesQuery:userQuery];
    PFPush *push = [PFPush new];
    [push setQuery: pushQuery];
    NSString *message=[[name stringByAppendingString:@" "]stringByAppendingString:@"sent you a new message!"];
    [push setMessage:message];
    [push sendPushInBackground];
}

- (void)showSucceedAlert {
    [self clearContent];
    UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your message send successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [Notpermitted show];
}


- (NSString *)getCurrentDateString {
    NSDate *currentDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate]; // Get necessary date components
    return [NSString stringWithFormat:@"%d/%d/%d", components.day, components.month, components.year];
}

- (NSString *)getCurrentTimeString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    return [formatter stringFromDate:[NSDate date]];
}

- (void)viewDidUnload {
    //[self setAssetsScrollView:nil];
    [self setIntroImageView:nil];
    [self setContactBtn:nil];
    [self setContactBtnLabel:nil];
    [self setNoteBtn:nil];
    [self setNoteBtnLabel:nil];
    [self setCreateBundleView:nil];
    [self setAssetsTableView:nil];
    [self setDateBtn:nil];
    [self setDueDateView:nil];
    [self setDueDateLabel:nil];
    [self setReceiverBtn:nil];
    [super viewDidUnload];
}

- (BOOL)isReminderExist:(NSString *)reminderName {
        for (NSDictionary *reminder in reminderArray) {
            if ([reminderName isEqualToString:[reminder valueForKey:@"name"]]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Reminder already added." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                return YES;
            }
        }
    
    return NO;
}

- (BOOL)isNoteExist:(NSString *)noteName {
        for (NSDictionary *note in noteArray) {
            if ([noteName isEqualToString:[note valueForKey:@"name"]]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Note already added." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                return YES;
            }
        }
    
    return NO;
}

#pragma mark - Email Delegate
-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - AlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    // Handle reminder alertview
    if (alertView.tag == 1000) {
        if (buttonIndex == 0) {
            if ([alertView textFieldAtIndex:0].text.length > 0 && ![self isReminderExist:[alertView textFieldAtIndex:0].text]) {
                [self setContactAndNoteEnable];
                NSDictionary *reminderDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[alertView textFieldAtIndex:0].text, @"name", @"reminder", @"type", [NSNumber numberWithBool:NO], @"accepted", nil];
                [tableDataSourceArray addObject:reminderDictionary];
                [reminderArray addObject:reminderDictionary];
                [assetsTableView reloadData];
            }
        }
    } else if (alertView.tag == 1001) {
        if (buttonIndex == 0) {
            if ([alertView textFieldAtIndex:0].text.length > 0 && ![self isNoteExist:[alertView textFieldAtIndex:0].text]) {
                NSDictionary *noteDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[alertView textFieldAtIndex:0].text, @"name", @"note", @"type", [NSNumber numberWithBool:NO], @"accepted", nil];
                [tableDataSourceArray addObject:noteDictionary];
                [noteArray addObject:noteDictionary];
                [assetsTableView reloadData];
            }
        }
    } else if (alertView.tag == 1002) {
        if (buttonIndex == 0) {
            NSString *msg = self.msgTextView.text;
            MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
            mc.mailComposeDelegate = self;
            NSString *emailTitle = @"";
            [mc setSubject:emailTitle];
            NSMutableString *reminderString = [[NSMutableString alloc] init];
            for (NSDictionary *reminderDictionary in reminderArray) {
                [reminderString appendString:[reminderDictionary objectForKey:@"name"]];
                [reminderString appendString:@"\n"];
            }
            NSString *messageBody = @"";
            messageBody = [NSString stringWithFormat:@"MESSAGE: %@\nDUE DATE: %@\n\n%@", msg, dueDateString, reminderString];
            [mc setMessageBody:messageBody isHTML:NO];
            for (NSDictionary *contactDictionary in contactArray) {
                NSString *name = [[contactDictionary objectForKey:@"name"] stringByAppendingString:@".vcf"];
                [mc addAttachmentData:[contactDictionary objectForKey:@"vcard"] mimeType:@"text/x-vcard" fileName:name];
            }
            // Present mail view controller on screen
            [self presentViewController:mc animated:YES completion:^{}];
            [self clearContent];
        }
    }
}

#pragma mark - TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    switch (textField.tag) {
        case 100:
            [receiverTextField resignFirstResponder];
            break;
        default:
            break;
    }
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField*)textField {
    if (textField.tag == 101) { //first textField tag
        //textField 1
        CGRect viewFrame = [createBundleView frame];
        viewFrame.origin.y = -50;
        createBundleView.frame = viewFrame;
        
        //CGRect scrollFrame = [assetsScrollView frame];
        //scrollFrame.origin.y = 203;
        //assetsScrollView.frame = scrollFrame;
    }
    else {
        //textField 2
    }
    return YES;
}

#pragma mark - AddressBook Delegate Methods

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    // Get the first and the last name. Actually, copy their values using the person object and the appropriate
    // properties into two string variables equivalently.
    // Watch out the ABRecordCopyValue method below. Also, notice that we cast to NSString *.
    NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *lastName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    
    // Compose the full name.
    NSString *fullName = @"";
    // Before adding the first and the last name in the fullName string make sure that these values are filled in.
    if (firstName != nil) {
        fullName = [fullName stringByAppendingString:firstName];
    }
    if (lastName != nil) {
        fullName = [fullName stringByAppendingString:@" "];
        fullName = [fullName stringByAppendingString:lastName];
    }
    NSMutableArray *people = [NSMutableArray arrayWithObject:(__bridge id)(person)];
    if ([contactType isEqualToString:@"contact"]) {
        //Transfer contact into nsdata
        NSData *vCard = (__bridge NSData*)ABPersonCreateVCardRepresentationWithPeople((__bridge CFArrayRef) people);
        NSString *vCardString = [[NSString alloc] initWithData:vCard encoding:NSUTF8StringEncoding];
        NSLog(@"vCard > %@", vCardString);
        NSDictionary *contactDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:fullName, @"name", vCard, @"vcard", vCardString, @"vcardstring", @"contact", @"type", [NSNumber numberWithBool:NO], @"accepted", nil];
        [contactArray addObject:contactDictionary];
        
        NSDictionary *nameDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:fullName, @"name", @"contact", @"type", [NSNumber numberWithBool:NO], @"accepted", nil];
        [tableDataSourceArray addObject:nameDictionary];
        [assetsTableView reloadData];
    } else if ([contactType isEqualToString:@"receiver"]) {
        [receiverBtn setTitle:fullName forState:UIControlStateNormal];
        receiverTextField.text = fullName;
        ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
        if (ABMultiValueGetCount(emails) != 0) {
            for (CFIndex i = 0; i < ABMultiValueGetCount(emails); i++) {
                NSString *email = (__bridge_transfer NSString*) ABMultiValueCopyValueAtIndex(emails, i);
                NSLog(@"email %@", email);
                [receiverEmails addObject:email];
                NSLog(@"ccount %d", receiverEmails.count);
            }
        }
    }
    
    [contacts dismissViewControllerAnimated:YES completion:^{}];
    return NO;
}

// Implement this delegate method to make the Cancel button of the Address Book working.
-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
	[contacts dismissViewControllerAnimated:YES completion:^{}];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    return NO;
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableDataSourceArray.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    
    AssetCell *cell = (AssetCell *)[tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"AssetCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.stuffsView.layer.cornerRadius = 10.0f;
    cell.stuffsView.layer.masksToBounds = YES;
    NSDictionary *dictionary = [tableDataSourceArray objectAtIndex:indexPath.row];
    NSString *type = [dictionary objectForKey:@"type"];
    if ([type isEqualToString:@"reminder"]) {
        UIImage *image = [UIImage imageNamed:@"icon_reminder"];
        [cell.typeImageView setImage:image];
    } else if ([type isEqualToString:@"contact"]) {
        UIImage *image = [UIImage imageNamed:@"icon_contact"];
        [cell.typeImageView setImage:image];
    } else if ([type isEqualToString:@"note"]) {
        UIImage *image = [UIImage imageNamed:@"icon_note"];
        [cell.typeImageView setImage:image];
    }
    NSString *name = [dictionary objectForKey:@"name"];
    cell.cellLabel.text = [@"   " stringByAppendingString:name];
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteAssetByIndex:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void) deleteAssetByIndex:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSDictionary *unknownDictionary = [tableDataSourceArray objectAtIndex:button.tag];
    if ([reminderArray containsObject:unknownDictionary]) {
        [reminderArray removeObject:unknownDictionary];
    }else if ([noteArray containsObject:unknownDictionary]) {
        [noteArray removeObject:unknownDictionary];
    } else if ([contactArray containsObject:unknownDictionary]) {
        [contactArray removeObject:unknownDictionary];
    }
    [tableDataSourceArray removeObjectAtIndex:button.tag];
    [assetsTableView reloadData];
}

@end
