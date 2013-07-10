//
//  CreateBundleViewController.m
//  HoneyDue
//
//  Created by Harry Wang on 7/8/13.
//  Copyright (c) 2013 com.mitch. All rights reserved.
//

#import "CreateBundleViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface CreateBundleViewController ()

@end

@implementation CreateBundleViewController
@synthesize bundleBodyView;
@synthesize receiverTextField;
@synthesize msgTextView;

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
    [bundleBodyView.layer setCornerRadius:10.0f];
    [bundleBodyView.layer setMasksToBounds:YES];
    [msgTextView setPlaceholder:@"Add a message"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{}];
}

- (IBAction)send:(id)sender {
}

- (IBAction)dateClicked:(id)sender {
}

- (IBAction)reminderClicked:(id)sender {
}

- (IBAction)contactClicked:(id)sender {
}

- (IBAction)noteClicked:(id)sender {
}
@end
