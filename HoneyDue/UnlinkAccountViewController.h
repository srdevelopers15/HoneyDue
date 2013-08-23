//
//  UnlinkAccountViewController.h
//  HoneyDue
//
//  Created by Harry Wang on 8/23/13.
//  Copyright (c) 2013 com.mitch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UnlinkAccountViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UIView *accountView;

- (IBAction)unlinkAccount:(id)sender;
- (IBAction)back:(id)sender;
@end
