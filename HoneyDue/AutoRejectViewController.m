//
//  AutoRejectViewController.m
//  HoneyDue
//
//  Created by Harry Wang on 9/12/13.
//  Copyright (c) 2013 com.mitch. All rights reserved.
//

#import "AutoRejectViewController.h"
#import <Parse/Parse.h>

@interface AutoRejectViewController ()

@property (nonatomic, strong) PFUser *currentUser;
@property (nonatomic, strong) NSUserDefaults *standardUserDefaults;

@end

@implementation AutoRejectViewController

@synthesize autoRejectIntLabel;
@synthesize autoRejectIntStepper;
@synthesize currentUser;
@synthesize standardUserDefaults;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    autoRejectIntStepper.maximumValue = 7;
    autoRejectIntStepper.minimumValue = 1;
    autoRejectIntStepper.stepValue = 1;
    autoRejectIntStepper.wraps = YES;
    autoRejectIntStepper.continuous = YES;
    
    currentUser = [PFUser currentUser];
    [currentUser fetchIfNeeded];
    
    standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *autoRejectInt = [standardUserDefaults objectForKey:@"auto_reject"];
    if (autoRejectInt) {
        autoRejectIntLabel.text = autoRejectInt;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setAutoRejectIntLabel:nil];
    [self setAutoRejectIntStepper:nil];
    [super viewDidUnload];
}
- (IBAction)autoRejectIntChanged:(UIStepper *)sender {
    double value = [sender value];
        [autoRejectIntLabel setText:[NSString stringWithFormat:@"%d", (int)value]];
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{}];
}

- (IBAction)done:(id)sender {
    NSString *autoRejectInt = autoRejectIntLabel.text;
    [standardUserDefaults setObject:autoRejectInt forKey:@"auto_reject"];
    [standardUserDefaults synchronize];
    [self dismissViewControllerAnimated:NO completion:^{}];
}
@end
