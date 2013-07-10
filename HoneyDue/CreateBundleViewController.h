//
//  CreateBundleViewController.h
//  HoneyDue
//
//  Created by Harry Wang on 7/8/13.
//  Copyright (c) 2013 com.mitch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPlaceHolderTextView.h"

@interface CreateBundleViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *receiverTextField;
@property (strong, nonatomic) IBOutlet UIPlaceHolderTextView *msgTextView;
@property (strong, nonatomic) IBOutlet UIView *bundleBodyView;

- (IBAction)back:(id)sender;
- (IBAction)send:(id)sender;
- (IBAction)dateClicked:(id)sender;
- (IBAction)reminderClicked:(id)sender;
- (IBAction)contactClicked:(id)sender;
- (IBAction)noteClicked:(id)sender;

@end
