//
//  SelectPersonViewController.h
//  HoneyDue
//
//  Created by Harry Wang on 8/30/13.
//  Copyright (c) 2013 com.mitch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectPersonViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *doneBtn;
@property (strong, nonatomic) IBOutlet UILabel *noRecordLabel;
@property (strong, nonatomic) IBOutlet UITableView *personTableView;

- (IBAction)back:(id)sender;
- (IBAction)done:(id)sender;

@property (strong, nonatomic) NSString *titleString;
@property (strong, nonatomic) NSString *personsType;
@end
