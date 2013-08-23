//
//  InBundleViewController.h
//  HoneyDue
//
//  Created by Harry Wang on 7/16/13.
//  Copyright (c) 2013 com.mitch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bundle.h"

@interface InBundleViewController : UIViewController
@property (strong, nonatomic) Bundle *bundle;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UITextView *msgTextView;
@property (strong, nonatomic) IBOutlet UITableView *assetsTableView;

- (IBAction)back:(id)sender;
- (IBAction)saveToPhone:(id)sender;
@end
