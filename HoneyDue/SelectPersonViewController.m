//
//  SelectPersonViewController.m
//  HoneyDue
//
//  Created by Harry Wang on 8/30/13.
//  Copyright (c) 2013 com.mitch. All rights reserved.
//

#import "SelectPersonViewController.h"
#import "HoneyDueAppDelegate.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>

@interface SelectPersonViewController ()

@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) NSMutableArray *matchedPersons;
@property (nonatomic, strong) NSMutableArray *selectResults;

@end

@implementation SelectPersonViewController

@synthesize matchedPersons;
@synthesize noRecordLabel;
@synthesize personTableView;
@synthesize doneBtn;
@synthesize selectResults;
@synthesize personsType;

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
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.frame = CGRectMake(0.0, 0.0, 80.0, 80.0);
    [self.spinner setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, [[UIScreen mainScreen] bounds].size.height / 2 - 30)]; // I do this because I'm in landscape mode
    [self.view addSubview:self.spinner];
    
    [[doneBtn layer] setBorderWidth:2.0f];
    [[doneBtn layer] setBorderColor:[UIColor colorWithRed:203.0f green:241.0f blue:236.0f alpha:0.5f].CGColor];
    doneBtn.layer.cornerRadius = 5;
    doneBtn.layer.masksToBounds = YES;
    personTableView.layer.cornerRadius = 5;
    personTableView.layer.masksToBounds = YES;
    [self getMatchedPersons];
}

- (void)getMatchedPersons {
    matchedPersons = [[NSMutableArray alloc] init];
    
    HoneyDueAppDelegate *delegate = (HoneyDueAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSArray *allUsers = delegate.honeyDueUsers;
    
    ABAddressBookRef addressBook = ABAddressBookCreate();
    NSArray *allContacts = (__bridge NSArray *)(ABAddressBookCopyArrayOfAllPeople(addressBook));
    CFErrorRef error;
    for (NSDictionary *userDictionary in allUsers) {
        for (int i =0; i < allContacts.count; i++) {
            ABRecordRef person = (__bridge ABRecordRef)([allContacts objectAtIndex:i]);
            
            if (person != nil) {
                ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
                if (ABMultiValueGetCount(emails) != 0) {
                    ABAddressBookRemoveRecord(addressBook, person, &error);
                    for (CFIndex i = 0; i < ABMultiValueGetCount(emails); i++) {
                        NSString* email = (__bridge_transfer NSString*) ABMultiValueCopyValueAtIndex(emails, i);
                        NSString *userEmail = [userDictionary objectForKey:@"email"];
                        NSLog(@"email: %@, userEmail: %@", email, userEmail);
                        if ([email isEqualToString:userEmail]) {
                            [matchedPersons addObject:userDictionary];
                        }
                    }
                }
            }
        }
    }
    selectResults = [[NSMutableArray alloc] init];
    if (matchedPersons.count > 0) {
        [personTableView setHidden:NO];
        for (int i = 0; i < matchedPersons.count; i++) {
            [selectResults addObject:[NSNumber numberWithBool:NO]];
        }
    } else {
        [noRecordLabel setHidden:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTitleLabel:nil];
    [self setDoneBtn:nil];
    [self setNoRecordLabel:nil];
    [self setPersonTableView:nil];
    [super viewDidUnload];
}
- (IBAction)done:(id)sender {
    int i = 0;
    NSMutableArray *personsToSave = [[NSMutableArray alloc] init];
    for (int j = 0; j < selectResults.count; j++) {
        NSNumber *boolValue = [selectResults objectAtIndex:j];
        if ([boolValue isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            i++;
            NSDictionary *userDictionary = [matchedPersons objectAtIndex:j];
            //[personsToSave addObject:[userDictionary objectForKey:@"objectId"]];
            [personsToSave addObject:userDictionary];
        }
    }
    if (i > 0) {
        [self.spinner startAnimating];
        PFUser *currentUser = [PFUser currentUser];
        if ([personsType isEqualToString:@"Calendars"]) {
            [currentUser setObject:personsToSave forKey:@"autoAcceptCalendars"];
        } else if ([personsType isEqualToString:@"Reminders"]) {
            [currentUser setObject:personsToSave forKey:@"autoAcceptReminders"];   
        } else if ([personsType isEqualToString:@"Contacts"]) {
            [currentUser setObject:personsToSave forKey:@"autoAcceptContacts"];
        }
        [currentUser saveInBackground];
        [self.spinner stopAnimating];
        [self dismissViewControllerAnimated:NO completion:^{}];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"You haven't select any person." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{}];
}

#pragma mark TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [matchedPersons count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *FirstLevelCell= @"FirstLevelCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FirstLevelCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FirstLevelCell];
    }
    //cell.accessoryType = UITableViewCellAccessoryCheckmark;
    cell.accessoryType = UITableViewCellAccessoryNone;
    // return appropriate cell(s) based on section
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [[matchedPersons objectAtIndex:indexPath.row] objectForKey:@"displayName"];
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    [cell.textLabel setTextColor:[UIColor darkGrayColor]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)path {
    UITableViewCell *thisCell = [tableView cellForRowAtIndexPath:path];
    
    
    if (thisCell.accessoryType == UITableViewCellAccessoryNone) {
        thisCell.accessoryType = UITableViewCellAccessoryCheckmark;
        [selectResults replaceObjectAtIndex:path.row withObject:[NSNumber numberWithBool:YES]];
        
    }else{
    	thisCell.accessoryType = UITableViewCellAccessoryNone;
        [selectResults replaceObjectAtIndex:path.row withObject:[NSNumber numberWithBool:NO]];
    }
}
@end
