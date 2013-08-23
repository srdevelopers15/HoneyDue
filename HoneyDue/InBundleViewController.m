//
//  InBundleViewController.m
//  HoneyDue
//
//  Created by Harry Wang on 7/16/13.
//  Copyright (c) 2013 com.mitch. All rights reserved.
//

#import "InBundleViewController.h"
#import "InBoundAssetCell.h"
#import <EventKit/EventKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface InBundleViewController ()

@property (strong, nonatomic) NSMutableArray *tableDataSourceArray;
@property (strong, nonatomic) NSMutableArray *acceptedStateArray;

@end

@implementation InBundleViewController
@synthesize bundle;
@synthesize titleLabel;
@synthesize nameLabel;
@synthesize timeLabel;
@synthesize msgTextView;
@synthesize tableDataSourceArray;
@synthesize assetsTableView;
@synthesize acceptedStateArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initTableDataSource
{
    tableDataSourceArray = [[NSMutableArray alloc] init];
    NSDictionary *dueDateDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:bundle.dueDate, @"name", @"dueDate", @"type", nil];
    [tableDataSourceArray addObject:dueDateDictionary];
    if (bundle.reminders) {
        [tableDataSourceArray addObjectsFromArray:bundle.reminders];
    }
    if (bundle.notes) {
        [tableDataSourceArray addObjectsFromArray:bundle.notes];
    }
    if (bundle.contacts) {
        [tableDataSourceArray addObjectsFromArray:bundle.contacts];
    }
    [assetsTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    nameLabel.text = bundle.ownerName;
    timeLabel.text = bundle.time;
    msgTextView.text = bundle.msg;
    [self initTableDataSource];
    acceptedStateArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [tableDataSourceArray count]; i++) {
        [acceptedStateArray addObject:[NSNumber numberWithBool:NO]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{}];
}

- (IBAction)saveToPhone:(id)sender {
    // Check each switch's state
    if ([acceptedStateArray indexOfObject:[NSNumber numberWithBool:YES]] != NSNotFound) {
        // Add reminders
        EKEventStore *reminderStore = [[EKEventStore alloc] init];
        [reminderStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
            if (!granted) { return; }
            for (NSDictionary *dictionary in bundle.reminders) {
                if ([dictionary objectForKey:@"accepted"]) {
                    EKReminder *reminder = [EKReminder reminderWithEventStore:reminderStore];
                    reminder.title = [dictionary objectForKey:@"name"];
                    reminder.calendar = [reminderStore defaultCalendarForNewReminders];
                    NSError *err = nil;
                    [reminderStore saveReminder:reminder commit:YES error:&err];
                }
            }
        }];
//        // Add contacts
        for (NSDictionary *dictionary in bundle.contacts) {
            NSData *vcard = [dictionary objectForKey:@"vcard"];
            CFDataRef vCardData = CFDataCreate(NULL, [vcard bytes], [vcard length]);
            ABAddressBookRef book = ABAddressBookCreate();
            ABRecordRef defaultSource = ABAddressBookCopyDefaultSource(book);
            CFArrayRef vCardPeople = ABPersonCreatePeopleInSourceWithVCardRepresentation(defaultSource, vCardData);
            for (CFIndex index = 0; index < CFArrayGetCount(vCardPeople); index++) {
                ABRecordRef person = CFArrayGetValueAtIndex(vCardPeople, index);
                ABAddressBookAddRecord(book, person, NULL);
                CFRelease(person);
            }
            ABAddressBookSave(book, NULL);
            //CFRelease(vCardPeople);
            //CFRelease(defaultSource);
            //CFRelease(book);
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"All items saved successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"There's no item to save." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)viewDidUnload {
    [self setTitleLabel:nil];
    [self setNameLabel:nil];
    [self setTimeLabel:nil];
    [self setMsgTextView:nil];
    [self setAssetsTableView:nil];
    [super viewDidUnload];
}

#pragma mark - UITableView Delegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableDataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    
    InBoundAssetCell *cell = (InBoundAssetCell *)[tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"InBoundAssetCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    NSDictionary *dictionary = [tableDataSourceArray objectAtIndex:indexPath.row];
    if ([[dictionary valueForKey:@"type"] isEqualToString:@"dueDate"]) {
        UIImage *image = [UIImage imageNamed: @"icon_calendar.png"];
        [cell.assetIconImageView setImage:image];
    } else if ([[dictionary valueForKey:@"type"] isEqualToString:@"reminder"]) {
        UIImage *image = [UIImage imageNamed: @"icon_reminder.png"];
        [cell.assetIconImageView setImage:image];
    } else if ([[dictionary valueForKey:@"type"] isEqualToString:@"note"]) {
        UIImage *image = [UIImage imageNamed: @"icon_note.png"];
        [cell.assetIconImageView setImage:image];
    } else if ([[dictionary valueForKey:@"type"] isEqualToString:@"contact"]) {
        UIImage *image = [UIImage imageNamed: @"icon_contact.png"];
        [cell.assetIconImageView setImage:image];
    }
    cell.assetNameLabel.text = [dictionary valueForKey:@"name"];
    cell.assetSwitch.tag = indexPath.row;
    [cell.assetSwitch addTarget:self action:@selector(handleSwitch:) forControlEvents:UIControlEventValueChanged];
    return cell;
}

- (IBAction) handleSwitch:(id) sender {
    UISwitch *onoff = (UISwitch *) sender;
    [acceptedStateArray replaceObjectAtIndex:onoff.tag withObject:[NSNumber numberWithBool:onoff.on]];
    NSDictionary *originDictionary = [tableDataSourceArray objectAtIndex:onoff.tag];
    if ([@"reminder" isEqualToString:[originDictionary objectForKey:@"type"]]) {
        for (int i = 0; i < bundle.reminders.count; i++) {
            NSDictionary *dictionary = [bundle.reminders objectAtIndex:i];
            if ([originDictionary isEqualToDictionary:dictionary]) {
                if (onoff.on) {
                    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                    [newDict addEntriesFromDictionary:originDictionary];
                    [newDict setObject:[NSNumber numberWithBool:YES] forKey:@"accepted"];
                    [tableDataSourceArray replaceObjectAtIndex:onoff.tag withObject:newDict];
                    [bundle.reminders replaceObjectAtIndex:i withObject:newDict];
                }
            }
        }
    } else if ([@"note" isEqualToString:[originDictionary objectForKey:@"type"]]) {
        for (int i = 0; i < bundle.notes.count; i++) {
            NSDictionary *dictionary = [bundle.notes objectAtIndex:i];
            if ([originDictionary isEqualToDictionary:dictionary]) {
                if (onoff.on) {
                    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                    [newDict addEntriesFromDictionary:originDictionary];
                    [newDict setObject:[NSNumber numberWithBool:YES] forKey:@"accepted"];
                    [tableDataSourceArray replaceObjectAtIndex:onoff.tag withObject:newDict];
                    [bundle.notes replaceObjectAtIndex:i withObject:newDict];
                }
            }
        }
    }  else if ([@"contact" isEqualToString:[originDictionary objectForKey:@"type"]]) {
        for (int i = 0; i < bundle.contacts.count; i++) {
            NSDictionary *dictionary = [bundle.contacts objectAtIndex:i];
            if ([originDictionary isEqualToDictionary:dictionary]) {
                if (onoff.on) {
                    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                    [newDict addEntriesFromDictionary:originDictionary];
                    [newDict setObject:[NSNumber numberWithBool:YES] forKey:@"accepted"];
                    [tableDataSourceArray replaceObjectAtIndex:onoff.tag withObject:newDict];
                    [bundle.contacts replaceObjectAtIndex:i withObject:newDict];
                }
            }
        }
    }
}

@end
