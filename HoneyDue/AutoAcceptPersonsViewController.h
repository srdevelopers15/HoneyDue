//
//  AutoAcceptPersonsViewController.h
//  HoneyDue
//
//  Created by Harry Wang on 8/27/13.
//  Copyright (c) 2013 com.mitch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AutoAcceptPersonsViewController : UIViewController
@property (strong, nonatomic) NSString *titleString;

@property (strong, nonatomic) IBOutlet UIButton *editBtn;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *noRecordFoundLabel;
@property (strong, nonatomic) IBOutlet UITableView *personTable;

- (IBAction)back:(id)sender;
- (IBAction)edit:(id)sender;
- (IBAction)addPerson:(id)sender;

@end
