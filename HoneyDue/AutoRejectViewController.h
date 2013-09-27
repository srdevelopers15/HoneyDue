//
//  AutoRejectViewController.h
//  HoneyDue
//
//  Created by Harry Wang on 9/12/13.
//  Copyright (c) 2013 com.mitch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AutoRejectViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *autoRejectIntLabel;
@property (strong, nonatomic) IBOutlet UIStepper *autoRejectIntStepper;

- (IBAction)autoRejectIntChanged:(id)sender;
- (IBAction)back:(id)sender;
- (IBAction)done:(id)sender;
@end
