//
//  UnlinkAccountViewController.m
//  HoneyDue
//
//  Created by Harry Wang on 8/23/13.
//  Copyright (c) 2013 com.mitch. All rights reserved.
//

#import "UnlinkAccountViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>

@interface UnlinkAccountViewController ()

@end

@implementation UnlinkAccountViewController
@synthesize userNameLabel;
@synthesize emailLabel;
@synthesize accountView;

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
    [accountView.layer setCornerRadius:10.0f];
    [accountView.layer setMasksToBounds:YES];
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"];
    NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
    userNameLabel.text = userName;
    emailLabel.text = email;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)unlinkAccount:(id)sender {
    [PFUser logOut]; // Log out
    // Return to login page
    [self performSegueWithIdentifier:@"LogOut" sender:self];
    //[self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{}];
}
@end
