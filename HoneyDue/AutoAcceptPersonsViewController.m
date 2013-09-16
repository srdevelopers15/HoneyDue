//
//  AutoAcceptPersonsViewController.m
//  HoneyDue
//
//  Created by Harry Wang on 8/27/13.
//  Copyright (c) 2013 com.mitch. All rights reserved.
//

#import "AutoAcceptPersonsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "HoneyDueAppDelegate.h"
#import <Parse/Parse.h>
#import "SelectPersonViewController.h"

@interface AutoAcceptPersonsViewController ()

@property (nonatomic, strong) NSMutableArray *autoAcceptPersons;
@property (nonatomic, strong) PFUser *currentUser;

@end

@implementation AutoAcceptPersonsViewController

@synthesize editBtn;
@synthesize noRecordFoundLabel;
@synthesize titleLabel;
@synthesize personTable;
@synthesize titleString;
@synthesize autoAcceptPersons;
@synthesize currentUser;

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
    titleLabel.text = titleString;
    [[editBtn layer] setBorderWidth:2.0f];
    [[editBtn layer] setBorderColor:[UIColor colorWithRed:203.0f green:241.0f blue:236.0f alpha:0.5f].CGColor];
    editBtn.layer.cornerRadius = 5;
    editBtn.layer.masksToBounds = YES;
    personTable.layer.cornerRadius = 5;
    personTable.layer.masksToBounds = YES;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getAutoAcceptPersons];
}

- (void)getAutoAcceptPersons {
    autoAcceptPersons = [[NSMutableArray alloc] init];
    currentUser = [PFUser currentUser];
    [currentUser fetchIfNeeded];
    if ([titleString isEqualToString:@"Calendars"]) {
        autoAcceptPersons = [currentUser objectForKey:@"autoAcceptCalendars"];
    } else if ([titleString isEqualToString:@"Reminders"]) {
        autoAcceptPersons = [currentUser objectForKey:@"autoAcceptReminders"];
    } else if ([titleString isEqualToString:@"Contacts"]) {
        autoAcceptPersons = [currentUser objectForKey:@"autoAcceptContacts"];
    } else {
        autoAcceptPersons = nil;
    }
    if (autoAcceptPersons.count > 0) {
        [personTable setHidden:NO];
        [noRecordFoundLabel setHidden:YES];
    } else {
        [personTable setHidden:YES];
        [noRecordFoundLabel setHidden:NO];
    }
    [personTable reloadData];
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{}];
}

- (IBAction)edit:(id)sender {
    if ([personTable isEditing]) {
        [editBtn setTitle:@"Edit" forState:UIControlStateNormal];
        [personTable setEditing:NO animated:YES];
    } else {
        [editBtn setTitle:@"Done" forState:UIControlStateNormal];
        [personTable setEditing:YES animated:YES];
    }
}

- (IBAction)addPerson:(id)sender {
    SelectPersonViewController *sdv = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectPerson"];
    sdv.personsType = self.titleString;
    [self presentViewController:sdv animated:YES completion:^{}];
}
- (void)viewDidUnload {
    [self setEditBtn:nil];
    [self setTitleLabel:nil];
    [self setNoRecordFoundLabel:nil];
    [self setPersonTable:nil];
    [super viewDidUnload];
}

#pragma mark TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [autoAcceptPersons count];
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
    cell.textLabel.text = [[autoAcceptPersons objectAtIndex:indexPath.row] objectForKey:@"displayName"];
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    [cell.textLabel setTextColor:[UIColor darkGrayColor]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)path {
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // If row is deleted, remove it from the list.
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [autoAcceptPersons removeObjectAtIndex:indexPath.row];
        [personTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        //[personTable reloadData];
        if ([titleString isEqualToString:@"Calendars"]) {
            [currentUser setObject:autoAcceptPersons forKey:@"autoAcceptCalendars"];
        } else if ([titleString isEqualToString:@"Reminders"]) {
            [currentUser setObject:autoAcceptPersons forKey:@"autoAcceptReminders"];
        } else if ([titleString isEqualToString:@"Contacts"]) {
            [currentUser setObject:autoAcceptPersons forKey:@"autoAcceptContacts"];
        }
        [currentUser saveInBackground];
    }
}

@end
