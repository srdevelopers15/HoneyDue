//
//  OutBundleViewController.m
//  HoneyDue
//
//  Created by Harry Wang on 7/16/13.
//  Copyright (c) 2013 com.mitch. All rights reserved.
//

#import "OutBundleViewController.h"
#import "OutBoundAssetCell.h"
#import <Parse/Parse.h>

@interface OutBundleViewController ()

@property (nonatomic, strong) NSMutableArray *tableDataSourceArray;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;

@end

@implementation OutBundleViewController
@synthesize bundle;
@synthesize titleLabel;
@synthesize nameLabel;
@synthesize timeLabel;
@synthesize msgTextView;
@synthesize tableDataSourceArray;
@synthesize assetsTableView;

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
    nameLabel.text = bundle.ownerName;
    timeLabel.text = bundle.time;
    msgTextView.text = bundle.msg;
    [self initTableDataSource];
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.frame = CGRectMake(0.0, 0.0, 80.0, 80.0);
    [self.spinner setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, [[UIScreen mainScreen] bounds].size.height / 2 - 30)]; // I do this because I'm in landscape mode
    [self.view addSubview:self.spinner];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{}];
}

- (IBAction)autoRemind:(id)sender {
}

- (IBAction)deleteBound:(id)sender {
    [self.spinner startAnimating];
    PFQuery *query = [PFQuery queryWithClassName:@"bundle"];
    [query whereKey:@"objectId" equalTo:bundle.objectId];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        [self.spinner stopAnimating];
        if (!object) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Can not accomplish your request now, please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        } else {
            // The find succeeded.
            [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded && !error) {
                    [self performSegueWithIdentifier:@"BackHome" sender:self];
                    [self dismissViewControllerAnimated:NO completion:^{}];
                } else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Can not accomplish your request now, please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
            }];
        }
    }];
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
    NSLog(@"out cell count: %d", tableDataSourceArray.count);
    return tableDataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    
    OutBoundAssetCell *cell = (OutBoundAssetCell *)[tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"OutBoundAssetCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    NSDictionary *dictionary = [tableDataSourceArray objectAtIndex:indexPath.row];
    if ([[dictionary valueForKey:@"type"] isEqualToString:@"dueDate"]) {
        UIImage *image = [UIImage imageNamed: @"icon_calendar.png"];
        [cell.iconImageView setImage:image];
    } else if ([[dictionary valueForKey:@"type"] isEqualToString:@"reminder"]) {
        UIImage *image = [UIImage imageNamed: @"icon_reminder.png"];
        [cell.iconImageView setImage:image];
    } else if ([[dictionary valueForKey:@"type"] isEqualToString:@"note"]) {
        UIImage *image = [UIImage imageNamed: @"icon_note.png"];
        [cell.iconImageView setImage:image];
    }  else if ([[dictionary valueForKey:@"type"] isEqualToString:@"contact"]) {
        UIImage *image = [UIImage imageNamed: @"icon_contact.png"];
        [cell.iconImageView setImage:image];
    }
    cell.nameLabel.text = [dictionary valueForKey:@"name"];
    if ([[dictionary objectForKey:@"accepted"] boolValue]) {
        UIImage *image = [UIImage imageNamed: @"mark_check.png"];
        [cell.markImageView setImage:image];
    } else {
        UIImage *image = [UIImage imageNamed: @"mark_cross.png"];
        [cell.markImageView setImage:image];
    }
    return cell;
}

@end
