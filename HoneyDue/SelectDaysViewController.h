//
//  SelectDaysViewController.h
//  HoneyDue
//
//  Created by Harry Wang on 8/20/13.
//  Copyright (c) 2013 com.mitch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectDaysViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *doneBtn;
@property (strong, nonatomic) IBOutlet UITableView *daysTableView;

- (IBAction)back:(id)sender;
- (IBAction)done:(id)sender;
@end
