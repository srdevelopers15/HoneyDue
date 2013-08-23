//
//  HoneyDueViewController.m
//  HoneyDue
//
//  Created by Harry Wang on 7/1/13.
//  Copyright (c) 2013 com.mitch. All rights reserved.
//

#import "HomeViewController.h"
#import "PullTableView.h"
#import "ParseService.h"
#import "BoundCell.h"
#import <QuartzCore/QuartzCore.h>
#import "InBundleViewController.h"
#import "OutBundleViewController.h"
#import "UIImageView+WebCache.h"
#import <Parse/Parse.h>

#ifdef USES_IASK_STATIC_LIBRARY
#import "InAppSettingsKit/IASKSettingsReader.h"
#else
#import "IASKSettingsReader.h"
#endif

@interface HomeViewController () <UIScrollViewDelegate, PullTableViewDelegate, UITableViewDataSource>

@end

@implementation HomeViewController
@synthesize boundScrollView;
@synthesize boundPageControl;
@synthesize pullTableView;
@synthesize appSettingsViewController;

- (IASKAppSettingsViewController*)appSettingsViewController {
	if (!appSettingsViewController) {
		appSettingsViewController = [[IASKAppSettingsViewController alloc] init];
		appSettingsViewController.delegate = self;
		BOOL enabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"AutoConnect"];
		appSettingsViewController.hiddenKeys = enabled ? nil : [NSSet setWithObjects:@"AutoConnectLogin", @"AutoConnectPassword", nil];
	}
	return appSettingsViewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self initPullTableView];
    [self initScrollView];
    [self initTableWithInBundles];
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self initTableWithInBundles];
//}

- (void)initPullTableView
{
    pullTableView.pullArrowImage = [UIImage imageNamed:@"blackArrow"];
    pullTableView.pullBackgroundColor = [UIColor whiteColor];
    pullTableView.pullTextColor = [UIColor blackColor];
    pullTableView.pullTableIsRefreshing = YES;
}

- (void)initScrollView {
    boundScrollView.delegate = self;
    CGSize scrollableSize = CGSizeMake(240, [boundScrollView bounds].size.height);
    [boundScrollView setContentSize:scrollableSize];
    int x=0;
    NSMutableArray *languageArray=[[NSMutableArray alloc]initWithObjects:@"Inbound",@"Outbound",nil];
    for(int i=0;i<[languageArray count];i++)
    {
        UILabel *boundLabel=[[UILabel alloc]initWithFrame:CGRectMake(x, 0, 120, 40)];
        boundLabel.text=[languageArray objectAtIndex:i];
        boundLabel.font = [UIFont boldSystemFontOfSize:17];
        boundLabel.backgroundColor = [UIColor clearColor];
        boundLabel.textColor = [UIColor whiteColor];
        boundLabel.textAlignment = NSTextAlignmentCenter;
        [boundScrollView addSubview:boundLabel];
        x += boundLabel.frame.size.width;
    }
}

- (void)initTableWithInBundles {
    userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"];
    NSLog(@"user name from defausts %@", userName);
    if (userName.length > 0) {
        [[ParseService sharedParseService] getAllBundlesByReceiver:userName completion:^(NSError *error, NSArray *bundles) {
            pullTableView.pullTableIsRefreshing = NO;
                self.currentBundles = bundles;
                [pullTableView reloadData];
        }];
    } else {
        pullTableView.pullTableIsRefreshing = NO;
    }
}

- (void)initTableWithOutBundles {
    userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"];
    NSLog(@"user name from defausts %@", userName);
    if (userName) {
        [[ParseService sharedParseService] getAllBundlesByOwnerName:userName completion:^(NSError *error, NSArray *bundles) {
            pullTableView.pullTableIsRefreshing = NO;
                self.currentBundles = bundles;
                [pullTableView reloadData];
        }];
    } else {
        pullTableView.pullTableIsRefreshing = NO;
    }
}

- (void)initTableWithPageNum {
    switch (currentPageNum) {
        case 0:
            [self initTableWithInBundles];
            break;
        case 1:
            [self initTableWithOutBundles];
            break;
        default:
            break;
    }
}

- (IBAction)createNewBundle:(id)sender {
    [self performSegueWithIdentifier:@"CreateNewBundle" sender:self];
}

- (IBAction)goToSetting:(id)sender {
    [self performSegueWithIdentifier:@"GoToSetting" sender:self];
//    UINavigationController *aNavController = [[UINavigationController alloc] initWithRootViewController:self.appSettingsViewController];
//    //[viewController setShowCreditsFooter:NO];   // Uncomment to not display InAppSettingsKit credits for creators.
//    // But we encourage you not to uncomment. Thank you!
//    self.appSettingsViewController.showDoneButton = YES;
//    //self.appSettingsViewController.showCreditsFooter = NO;
//    [self presentModalViewController:aNavController animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = boundScrollView.frame.size.width;
    int page = floor((boundScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    boundPageControl.currentPage = page;
    currentPageNum = page;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    pullTableView.pullTableIsRefreshing = YES;
    [self initTableWithPageNum];
}

#pragma mark - Refresh and load more methods
- (void) refreshTable
{
    /*
     
     Code to actually refresh goes here.
     
     */
    [self initTableWithPageNum];
    self.pullTableView.pullLastRefreshDate = [NSDate date];
    self.pullTableView.pullTableIsRefreshing = NO;
}

- (void) loadMoreDataToTable
{
    /*
     
     Code to actually load more data goes here.
     
     */
    [self initTableWithPageNum];
    self.pullTableView.pullTableIsLoadingMore = NO;
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.currentBundles.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    
    BoundCell *cell = (BoundCell *)[tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"BoundCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.avatarImageView.layer.cornerRadius = 5;
    cell.avatarImageView.layer.masksToBounds = YES;
    Bundle *bundle = [self.currentBundles objectAtIndex:indexPath.row];
    if (bundle.unformattedDueDate) {
        NSInteger diffDays = [self daysBetweenDate:[NSDate date] andDate:bundle.unformattedDueDate];
        UIColor *color = [self getColorByDays:diffDays];
        [cell.priorityImageView setBackgroundColor:color];
    }
    if (!bundle.dueDate) {
        [cell.calImageView setHidden:YES];
    }
    if (!bundle.reminders) {
        [cell.reminderImageView setHidden:YES];
    }
    if (!bundle.notes) {
        [cell.noteImageView setHidden:YES];
    }
    if (!bundle.contacts) {
        [cell.contactImageView setHidden:YES];
    }
    cell.nameLabel.text = bundle.ownerName;
    cell.msgLabel.text = bundle.msg;
    cell.dateLabel.text = bundle.date;
    if (bundle.avatarUrl) {
        //[cell.avatarImageView setImage:bundle.ownerAvatarImage];
        NSLog(@"cell's avatar url: %@", bundle.avatarUrl);
        [cell.avatarImageView setImageWithURL:[NSURL URLWithString:bundle.avatarUrl]
                       placeholderImage:[UIImage imageNamed:@"default_profile_pic.png"]];
    }
    return cell;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

- (NSString *) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"";
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (currentPageNum) {
        case 0:
            [self goToInBundle:indexPath.row];
            break;
        case 1:
            [self goToOutBundle:indexPath.row];
            break;
        default:
            break;
    }
}

- (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

- (UIColor *) getColorByDays:(NSInteger)days {
    if (days) {
        if (days/6 <=  1/3) {
            // Return red color
            UIColor *color = [UIColor colorWithRed:210.0/255.0 green:31.0/255.0 blue:61.0/255.0 alpha:1.0];
            return color;
        } else if (days/6 > 1/3 && days/6 <= 2/3) {
            // Return Amber color
            UIColor *color = [UIColor colorWithRed:255.0/255.0 green:190.0/255.0 blue:89.0/255.0 alpha:1.0];
            return color;
        }
    }
    // Return green color
    UIColor *color = [UIColor colorWithRed:116.0/255.0 green:185.0/255.0 blue:97.0/255.0 alpha:1.0];
    return color;
}

- (void)goToInBundle:(int)index {
    InBundleViewController *sdv = [self.storyboard instantiateViewControllerWithIdentifier:@"InBundleViewController"];
    Bundle *bundle = [self.currentBundles objectAtIndex:index];
    [sdv setBundle:bundle];
    [self presentViewController:sdv animated:YES completion:^{}];
}

- (void)goToOutBundle:(int)index {
    OutBundleViewController *sdv = [self.storyboard instantiateViewControllerWithIdentifier:@"OutBundleViewController"];
    Bundle *bundle = [self.currentBundles objectAtIndex:index];
    [sdv setBundle:bundle];
    [self presentViewController:sdv animated:YES completion:^{}];
}
#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:3.0f];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:3.0f];
}

#pragma mark -
#pragma mark IASKAppSettingsViewControllerDelegate protocol
- (void)settingsViewControllerDidEnd:(IASKAppSettingsViewController*)sender {
    [self dismissModalViewControllerAnimated:YES];
	
	// your code here to reconfigure the app for changed settings
}

// optional delegate method for handling mail sending result
- (void)settingsViewController:(id<IASKViewController>)settingsViewController mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    if ( error != nil ) {
        // handle error here
    }
    
    if ( result == MFMailComposeResultSent ) {
        // your code here to handle this result
    }
    else if ( result == MFMailComposeResultCancelled ) {
        // ...
    }
    else if ( result == MFMailComposeResultSaved ) {
        // ...
    }
    else if ( result == MFMailComposeResultFailed ) {
        // ...
    }
}
- (CGFloat)settingsViewController:(id<IASKViewController>)settingsViewController
                        tableView:(UITableView *)tableView
        heightForHeaderForSection:(NSInteger)section {
    NSString* key = [settingsViewController.settingsReader keyForSection:section];
	if ([key isEqualToString:@"IASKLogo"]) {
		return [UIImage imageNamed:@"Icon.png"].size.height + 25;
	} else if ([key isEqualToString:@"IASKCustomHeaderStyle"]) {
		return 55.f;
    }
	return 0;
}

- (UIView *)settingsViewController:(id<IASKViewController>)settingsViewController
                         tableView:(UITableView *)tableView
           viewForHeaderForSection:(NSInteger)section {
    NSString* key = [settingsViewController.settingsReader keyForSection:section];
	if ([key isEqualToString:@"IASKLogo"]) {
		UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icon.png"]];
		imageView.contentMode = UIViewContentModeCenter;
		return imageView;
	} else if ([key isEqualToString:@"IASKCustomHeaderStyle"]) {
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [UIColor redColor];
        label.shadowColor = [UIColor whiteColor];
        label.shadowOffset = CGSizeMake(0, 1);
        label.numberOfLines = 0;
        label.font = [UIFont boldSystemFontOfSize:16.f];
        
        //figure out the title from settingsbundle
        label.text = [settingsViewController.settingsReader titleForSection:section];
        
        return label;
    }
	return nil;
}

- (CGFloat)tableView:(UITableView*)tableView heightForSpecifier:(IASKSpecifier*)specifier {
	if ([specifier.key isEqualToString:@"customCell"]) {
		return 44*3;
	}
	return 0;
}
@end
