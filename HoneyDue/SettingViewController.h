//
//  SettingViewController.h
//  HoneyDue
//
//  Created by Harry Wang on 7/12/13.
//  Copyright (c) 2013 com.mitch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *settingsTableView;
- (IBAction)back:(id)sender;

@end
