//
//  HoneyDueViewController.h
//  HoneyDue
//
//  Created by Harry Wang on 7/1/13.
//  Copyright (c) 2013 com.mitch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullTableView.h"

#if USES_IASK_STATIC_LIBRARY
#import "InAppSettingsKit/IASKAppSettingsViewController.h"
#else
#import "IASKAppSettingsViewController.h"
#endif

@interface HomeViewController : UIViewController {
    int currentPageNum;
    NSString *userName;
    IASKAppSettingsViewController *appSettingsViewController;
}
@property (nonatomic, retain) IASKAppSettingsViewController *appSettingsViewController;
@property (strong, nonatomic) IBOutlet UIScrollView *boundScrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *boundPageControl;
@property (strong, nonatomic) IBOutlet PullTableView *pullTableView;

@property (strong, nonatomic) NSArray *currentBundles;

- (IBAction)createNewBundle:(id)sender;
- (IBAction)goToSetting:(id)sender;
@end
