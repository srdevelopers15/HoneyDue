//
//  LoginViewController.m
//  HoneyDue
//
//  Created by Harry Wang on 7/2/13.
//  Copyright (c) 2013 com.mitch. All rights reserved.
//

#import "LoginViewController.h"
#import "HomeViewController.h"
#import <Parse/Parse.h>
#import <Twitter/Twitter.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    // Do any additional setup after loading the view.
    if ([PFUser currentUser] && // Check if a user is cached
        ([PFFacebookUtils isLinkedWithUser:[PFUser currentUser]] || [PFTwitterUtils isLinkedWithUser:[PFUser currentUser]])) // Check if user is linked to Facebook
    {
        // Push the next view controller without animation
        [self performSegueWithIdentifier:@"GoToHomePage" sender:self];
    }
//    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
//    [standardUserDefaults setObject:@"Harry Wang" forKey:@"user_name"];
//    [standardUserDefaults setObject:@"" forKey:@"user_picture_url"];
//    [self performSegueWithIdentifier:@"GoToHomePage" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signInWithFB:(id)sender {
    NSArray *permissionsArray = @[@"email"];
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
            }
        } else if (user.isNew) {
            NSLog(@"User with facebook signed up and logged in!");
            [self requestAndSaveFBUserInfo];
        } else {
            [self requestAndSaveFBUserInfo];
        }
    }];
}

- (IBAction)signInWithTW:(id)sender {
    [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Twitter login.");
            return;
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in with Twitter!");
            [self requestAndSaveTWUserInfo];
        } else {
            NSLog(@"User logged in with Twitter!");
            [self requestAndSaveTWUserInfo];
        }     
    }];
}

- (IBAction)signInWithLI:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self performSegueWithIdentifier:@"GoToHomePage" sender:self];
}

- (void)requestAndSaveFBUserInfo {
            NSLog(@"start to retrieve facebook info");
        // Create request for user's Facebook data
        FBRequest *request = [FBRequest requestForMe];
        // Send request to Facebook
        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                // result is a dictionary with the user's Facebook data
                NSDictionary *userData = (NSDictionary *)result;
                NSString *facebookID = userData[@"id"];
                NSString *name = userData[@"name"];
                NSString *email = userData[@"email"];
                NSLog(@"facebook name: %@", name);
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
                NSString *urlString = [url absoluteString];
                NSLog(@"facebook avatar url: %@", urlString);
                [[PFUser currentUser] setObject:name forKey:@"displayName"];
                [[PFUser currentUser] setObject:urlString forKey:@"avatarUrl"];
                [[PFUser currentUser] setObject:email forKey:@"email"];
                [[PFUser currentUser] saveInBackground];
                [self registerUserForPushNotification:name];
                [self saveNameToUserDefaults:name pictureURL:urlString];
                [self performSegueWithIdentifier:@"GoToHomePage" sender:self];
            }
        }];

}

- (void)requestAndSaveTWUserInfo {
    NSLog(@"start to retrieve twitter info");
    NSString *name = [PFTwitterUtils twitter].screenName;
    NSLog(@"twitter name: %@", name);
    NSString * strPictureURL = [NSString stringWithFormat:@"https://api.twitter.com/1.1/users/profile_image?screen_name=%@&size=bigger",name];
    NSURL *url = [NSURL URLWithString:@"http://api.twitter.com/1.1/users/show.json"];
    
    NSDictionary *params = [NSDictionary dictionaryWithObject:name
                                                       forKey:@"screen_name"];
    TWRequest *request = [[TWRequest alloc] initWithURL:url
                                             parameters:params
                                          requestMethod:TWRequestMethodGET];
    
    [request performRequestWithHandler:
     ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
         if (responseData) {
             NSLog(@"get response from twitter");
             NSDictionary *user =
             [NSJSONSerialization JSONObjectWithData:responseData
                                             options:NSJSONReadingAllowFragments
                                               error:NULL];
             
             NSString *avatarUrl = [user objectForKey:@"profile_image_url"];
             NSLog(@"avatar url: %@", avatarUrl);
             [[PFUser currentUser] setObject:name forKey:@"displayName"];
             [[PFUser currentUser] setObject:avatarUrl forKey:@"avatarUrl"];
             [[PFUser currentUser] saveInBackground];
             [self registerUserForPushNotification:name];
             [self saveNameToUserDefaults:name pictureURL:avatarUrl];
             [self performSegueWithIdentifier:@"GoToHomePage" sender:self];
        }
     }];
}

-(void)registerUserForPushNotification:(NSString *)name {
    PFUser *user = [PFUser currentUser];
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setObject:user forKey:@"Owner"];
    [currentInstallation setObject:name forKey:@"displayName"];
    [currentInstallation saveInBackground];
}

-(void)saveNameToUserDefaults:(NSString *)name pictureURL:(NSString *)url{
    NSLog(@"save info to defaults");
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
        [standardUserDefaults setObject:name forKey:@"user_name"];
        [standardUserDefaults setObject:url forKey:@"user_picture_url"];
        [standardUserDefaults synchronize];
}
@end
