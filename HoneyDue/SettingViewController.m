//
//  SettingViewController.m
//  HoneyDue
//
//  Created by Harry Wang on 7/12/13.
//  Copyright (c) 2013 com.mitch. All rights reserved.
//

#import "SettingViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface SettingViewController ()

@property (strong, nonatomic) NSMutableDictionary *settingItems;
@property (strong, nonatomic) NSArray *section1;
@property (strong, nonatomic) NSArray *section2;
@property (strong, nonatomic) NSArray *section3;

@end

@implementation SettingViewController
@synthesize settingItems;
@synthesize settingsTableView;
@synthesize section1;
@synthesize section2;
@synthesize section3;

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
    settingsTableView.tableFooterView = [[UIView alloc] init];
    [settingsTableView setBackgroundView:nil];
    
    section1 = [[NSArray alloc] initWithObjects:@"Email", @"Auto Accept", @"Auto Reject", nil];
    section2 = [[NSArray alloc] initWithObjects:@"Profile", nil];
    section3 = [[NSArray alloc] initWithObjects:@"Twitter", @"LinkedIn", nil];
	// Do any additional setup after loading the view.
    settingsTableView.delegate = self;
    settingsTableView.dataSource = self;;
    settingItems = [[NSMutableDictionary alloc]init];
    [settingItems setObject:@"Email" forKey:@"Email"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{}];
}
- (void)viewDidUnload {
    [self setSettingsTableView:nil];
    [super viewDidUnload];
}

#pragma mark TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch(section){
        case 0:
            return [section1 count];
            break;
        case 1:
            return [section2 count];
            break;
        case 2:
            return [section3 count];
            break;
        default:
            return 0;
    }
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
    if (indexPath.section == 0) {
        // Return 1 cell
        cell.textLabel.text = [section1 objectAtIndex:indexPath.row];
    } else if (indexPath.section == 1) {
        cell.textLabel.text = [section2 objectAtIndex:indexPath.row];
    } else {
        cell.textLabel.text = [section3 objectAtIndex:indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    [cell.textLabel setTextColor:[UIColor darkGrayColor]];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        // create the parent view that will hold header Label
        UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0,0,300,60)];
        customView.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1];
        // create the label objects
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        headerLabel.font = [UIFont systemFontOfSize:15];
        headerLabel.frame = CGRectMake(10,0,280,60);
        headerLabel.textColor = [UIColor darkGrayColor];
        headerLabel.backgroundColor = [UIColor clearColor];
        if (section == 1) {
            headerLabel.text =  @"Complete your profile for a more automated experience";
            headerLabel.textAlignment = NSTextAlignmentCenter;
            headerLabel.lineBreakMode = NSLineBreakByWordWrapping;
            headerLabel.numberOfLines = 0;
        } else {
            headerLabel.text = @"Linked Accounts";
        }
        
        
        [customView addSubview:headerLabel];
        
        return customView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)path {
    if (path.section == 0) {
        if (path.row == 1) {
            [self performSegueWithIdentifier:@"GoToAutoList" sender:self];
        } else if (path.row == 2) {
            [self performSegueWithIdentifier:@"GoToAutoReject" sender:self];
        }else {
            [self performSegueWithIdentifier:@"UnlinkAccount" sender:self];
        }
    } else if (path.section == 1) {
        [self performSegueWithIdentifier:@"GoToProfile" sender:self];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 60; //play around with this value
}
@end
