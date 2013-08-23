//
//  ContactsViewController.h
//  HoneyDue
//
//  Created by Harry Wang on 7/26/13.
//  Copyright (c) 2013 com.mitch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) IBOutlet UIButton *doneBtn;
@end
