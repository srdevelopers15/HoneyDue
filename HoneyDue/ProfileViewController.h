//
//  ProfileViewController.h
//  HoneyDue
//
//  Created by Harry Wang on 8/23/13.
//  Copyright (c) 2013 com.mitch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *profileTableView;

- (IBAction)back:(id)sender;
@end
