//
//  AutoListViewController.m
//  HoneyDue
//
//  Created by Harry Wang on 8/20/13.
//  Copyright (c) 2013 com.mitch. All rights reserved.
//

#import "AutoListViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AutoAcceptPersonsViewController.h"

@interface AutoListViewController ()

@property (nonatomic, strong) NSArray *autoListArray;
@end

@implementation AutoListViewController
@synthesize doneBtn;
@synthesize autoListTableView;
@synthesize autoListArray;

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

    autoListArray = [[NSArray alloc] initWithObjects:@"Calendars", @"Reminders", @"Contacts", nil];
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
    AutoAcceptPersonsViewController *sdv = [self.storyboard instantiateViewControllerWithIdentifier:@"AutoAcceptPersonsViewController"];
    switch (path.row) {
        case 0:
            [sdv setTitleString:@"Calendars"];
            break;
        case 1:
            [sdv setTitleString:@"Reminders"];
            break;
        case 2:
            [sdv setTitleString:@"Contacts"];
            break;
        default:
            [sdv setTitleString:@""];
            break;
    }
    [self presentViewController:sdv animated:YES completion:^{}];
}
@end
