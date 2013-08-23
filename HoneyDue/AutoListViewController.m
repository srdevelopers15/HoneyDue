//
//  AutoListViewController.m
//  HoneyDue
//
//  Created by Harry Wang on 8/20/13.
//  Copyright (c) 2013 com.mitch. All rights reserved.
//

#import "AutoListViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface AutoListViewController ()

@property (nonatomic, strong) NSArray *autoListArray;
@end

@implementation AutoListViewController
@synthesize doneBtn;
@synthesize autoListTableView;
@synthesize autoListArray;
@synthesize contacts;

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
    [[doneBtn layer] setBorderWidth:2.0f];
    [[doneBtn layer] setBorderColor:[UIColor colorWithRed:203.0f green:241.0f blue:236.0f alpha:0.5f].CGColor];
    doneBtn.layer.cornerRadius = 5;
    doneBtn.layer.masksToBounds = YES;
    [autoListTableView.layer setCornerRadius:10.0f];
    [autoListTableView.layer setMasksToBounds:YES];

    autoListArray = [[NSArray alloc] initWithObjects:@"Calendars", @"Tasks", @"Contacts", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{}];
}

- (IBAction)done:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{}];
}

#pragma mark TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [autoListArray count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *FirstLevelCell= @"FirstLevelCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FirstLevelCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FirstLevelCell];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // return appropriate cell(s) based on section
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.text = [autoListArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    [cell.textLabel setTextColor:[UIColor darkGrayColor]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)path {
    // Init the contacts object.
    contacts = [[ABPeoplePickerNavigationController alloc] init];
    
    // Set the delegate.
	[contacts setPeoplePickerDelegate:self];
    
    // Set the e-mail property as the only one that we want to be displayed in the Address Book.
	[contacts setDisplayedProperties:[NSArray arrayWithObject:[NSNumber numberWithInt:kABPersonEmailProperty]]];
    
    /*
     kABPersonBirthdayProperty
     kABPersonCreationDateProperty
     kABPersonDepartmentProperty
     kABPersonFirstNamePhoneticProperty
     kABPersonFirstNameProperty
     kABPersonJobTitleProperty
     kABPersonLastNamePhoneticProperty
     kABPersonLastNameProperty
     kABPersonMiddleNamePhoneticProperty
     kABPersonMiddleNameProperty
     kABPersonModificationDateProperty
     kABPersonNicknameProperty
     kABPersonNoteProperty
     kABPersonOrganizationProperty
     kABPersonPrefixProperty
     kABPersonSuffixProperty
     kABPersonPhoneProperty
     */
    
    // Preparation complete. Display the contacts view controller.
	[self presentModalViewController:contacts animated:YES];
}

#pragma mark - AddressBook Delegate Methods

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    return YES;
}


-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    
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
    
    
    // Get the multivalue e-mail property.
    CFTypeRef multivalue = ABRecordCopyValue(person, property);
    
    // Get the index of the selected e-mail. Remember that the e-mail multi-value property is being returned as an array.
    CFIndex index = ABMultiValueGetIndexForIdentifier(multivalue, identifier);
    
    // Copy the e-mail value into a string.
    NSString *email = (__bridge NSString *)ABMultiValueCopyValueAtIndex(multivalue, index);
    
    // Create a temp array in which we'll add all the desired values.
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    [tempArray addObject:fullName];
    
    // Save the email into the tempArray array.
    [tempArray addObject:email];
    
    
    // Now add the tempArray into the contactsArray.
    // Dismiss the contacts view controller.
    [contacts dismissModalViewControllerAnimated:YES];
	return NO;
}


// Implement this delegate method to make the Cancel button of the Address Book working.
-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
	[contacts dismissModalViewControllerAnimated:YES];
}
@end
