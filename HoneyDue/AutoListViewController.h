//
//  AutoListViewController.h
//  HoneyDue
//
//  Created by Harry Wang on 8/20/13.
//  Copyright (c) 2013 com.mitch. All rights reserved.
//

#import <UIKit/UIKit.h>
// Import the two next necessary libraries in the ViewController.h file.

@interface AutoListViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *doneBtn;
@property (strong, nonatomic) IBOutlet UITableView *autoListTableView;

- (IBAction)back:(id)sender;
- (IBAction)done:(id)sender;
@end
