//
//  ContactsViewController.m
//  HoneyDue
//
//  Created by Harry Wang on 7/26/13.
//  Copyright (c) 2013 com.mitch. All rights reserved.
//

#import "ContactsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AddressBook/AddressBook.h>
#import "Person.h"

@interface ContactsViewController ()
// A list to save persons
@property (nonatomic, strong) NSMutableArray *tableData;
// A list of all indexes
@property (nonatomic, strong) NSMutableArray *arrayOfCharacters;
// A dictionary
@property (nonatomic, strong) NSMutableDictionary *objectsForCharacters;

@end

@implementation ContactsViewController
@synthesize cancelBtn;
@synthesize doneBtn;

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
    [self initBtns];
    
    self.tableData = [[NSMutableArray alloc] init];
    [self getPersonOutOfAddressBook];
    self.arrayOfCharacters = [[NSMutableArray alloc]init];
    self.objectsForCharacters = [[NSMutableDictionary alloc]init];
    
    for(char c ='A'; c <= 'Z';  c++)
    {
        [self.arrayOfCharacters addObject:[NSString stringWithFormat:@"%c",c]];
        [self.objectsForCharacters setObject:self.tableData forKey:[NSString stringWithFormat:@"%c",c]];
    }
}

- (void)initBtns {
    [[cancelBtn layer] setBorderWidth:2.0f];
    [[cancelBtn layer] setBorderColor:[UIColor colorWithRed:203.0f green:241.0f blue:236.0f alpha:0.5f].CGColor];
    cancelBtn.layer.cornerRadius = 5;
    cancelBtn.layer.masksToBounds = YES;
    
    [[doneBtn layer] setBorderWidth:2.0f];
    [[doneBtn layer] setBorderColor:[UIColor colorWithRed:203.0f green:241.0f blue:236.0f alpha:0.5f].CGColor];
    doneBtn.layer.cornerRadius = 5;
    doneBtn.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCancelBtn:nil];
    [self setDoneBtn:nil];
    [super viewDidUnload];
}
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{}];
}

- (IBAction)done:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{}];
}

- (void)getPersonOutOfAddressBook
{
    //1
    CFErrorRef error = NULL;
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    if (addressBook != nil)
    {
        NSLog(@"Succesful.");
        //2
        NSArray *allContacts = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
        
        //3
        NSUInteger i = 0;
        for (i = 0; i < [allContacts count]; i++)
        {
            Person *person = [[Person alloc] init];
            
            ABRecordRef contactPerson = (__bridge ABRecordRef)allContacts[i];
            
            //4
            NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
            NSString *lastName =  (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
            NSString *fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
            
            person.firstName = firstName;
            person.lastName = lastName;
            person.fullName = fullName;
            
            //email
            //5
            ABMultiValueRef emails = ABRecordCopyValue(contactPerson, kABPersonEmailProperty);
            
            //6
            NSUInteger j = 0;
            for (j = 0; j < ABMultiValueGetCount(emails); j++)
            {
                NSString *email = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(emails, j);
                if (j == 0)
                {
                    person.homeEmail = email;
                    NSLog(@"person.homeEmail = %@ ", person.homeEmail);
                }
                
                else if (j==1)
                    person.workEmail = email;
            }
            
            //7
            [self.tableData addObject:person];
        }
        
        //8
        CFRelease(addressBook);
    }
    else
    {
        //9
        NSLog(@"Error reading Address Book");
    }
}

#pragma mark - TableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    Person *person = [self.tableData objectAtIndex:indexPath.row];
    cell.textLabel.text = person.fullName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *sectionedArray = [[NSMutableArray alloc]init];
    for(char c ='A' ; c <= 'Z' ;  c++)
    {
        [sectionedArray addObject:[NSString stringWithFormat:@"%c",c]];
    }
    return sectionedArray;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSInteger count = 0;
    for(NSString *character in self.arrayOfCharacters)
    {
        if([character isEqualToString:title])
        {
            return count;
        }
        count ++;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}
@end
