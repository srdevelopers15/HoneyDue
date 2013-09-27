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

@synthesize oAuthLoginView;

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
        NSLog(@"twitter email: %@", user.email);
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Twitter login.");
            return;
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in with Twitter!");
            [self requestAndSaveTWUserInfo:user];
        } else {
            NSLog(@"User logged in with Twitter!");
            [self requestAndSaveTWUserInfo:user];
        }     
    }];
}

- (IBAction)signInWithLI:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
//    [self performSegueWithIdentifier:@"GoToHomePage" sender:self];
    oAuthLoginView = [[OAuthLoginView alloc] initWithNibName:nil bundle:nil];
    [oAuthLoginView retain];
    
    // register to be told when the login is finished
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginViewDidFinish:)
                                                 name:@"loginViewDidFinish"
                                               object:oAuthLoginView];
    
    [self presentModalViewController:oAuthLoginView animated:YES];
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
                NSLog(@"email: %@", email);
                NSLog(@"facebook name: %@", name);
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
                NSString *urlString = [url absoluteString];
                [[PFUser currentUser] setObject:name forKey:@"displayName"];
                [[PFUser currentUser] setObject:urlString forKey:@"avatarUrl"];
                [[PFUser currentUser] setObject:email forKey:@"email"];
                [[PFUser currentUser] saveInBackground];
                [self registerUserForPushNotification:name];
                [self saveNameToUserDefaults:name pictureURL:urlString email:email];
                [self performSegueWithIdentifier:@"GoToHomePage" sender:self];
            }
        }];

}

- (void)requestAndSaveTWUserInfo:(PFUser *)user {
    NSLog(@"start to retrieve twitter info");
    NSString *name = [PFTwitterUtils twitter].screenName;
    NSString *userId = [PFTwitterUtils twitter].userId;
    NSLog(@"twitter name: %@", name);
    // TODO find a way to fetch details with Twitter..
    NSString * requestString = [NSString stringWithFormat:@"https://api.twitter.com/1.1/users/show.json?screen_name=%@", user.username];
    
    NSURL *verify = [NSURL URLWithString:requestString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:verify];
    [[PFTwitterUtils twitter] signRequest:request];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    
    if ( error == nil){
        NSDictionary* result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSLog(@"%@",result);
        NSString *avatarUrl = [result objectForKey:@"profile_image_url_https"];
        NSLog(@"avatar url: %@", avatarUrl);
        [[PFUser currentUser] setObject:name forKey:@"displayName"];
        if (avatarUrl) {
            [[PFUser currentUser] setObject:avatarUrl forKey:@"avatarUrl"];
        }
        [[PFUser currentUser] saveInBackground];
        [self registerUserForPushNotification:name];
        [self saveNameToUserDefaults:name pictureURL:avatarUrl email:@""];
        [self performSegueWithIdentifier:@"GoToHomePage" sender:self];
    }
}

-(void)registerUserForPushNotification:(NSString *)name {
    PFUser *user = [PFUser currentUser];
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setObject:user forKey:@"Owner"];
    [currentInstallation setObject:name forKey:@"displayName"];
    [currentInstallation saveInBackground];
}

-(void)saveNameToUserDefaults:(NSString *)name pictureURL:(NSString *)url email:(NSString *)email{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
        [standardUserDefaults setObject:name forKey:@"user_name"];
        [standardUserDefaults setObject:url forKey:@"user_picture_url"];
    [standardUserDefaults setObject:email forKey:@"email"];
        [standardUserDefaults synchronize];
}

#pragma mark LinkedIn OAuth delegate

-(void) loginViewDidFinish:(NSNotification*)notification
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // We're going to do these calls serially just for easy code reading.
    // They can be done asynchronously
    // Get the profile, then the network updates
    [self profileApiCall];
	
}

- (void)profileApiCall
{
    NSURL *url = [NSURL URLWithString:@"http://api.linkedin.com/v1/people/~:(id,first-name,last-name,email-address,picture-url)"];
    OAMutableURLRequest *request =
    [[OAMutableURLRequest alloc] initWithURL:url
                                    consumer:oAuthLoginView.consumer
                                       token:oAuthLoginView.accessToken
                                    callback:nil
                           signatureProvider:nil];
    
    [request setValue:@"json" forHTTPHeaderField:@"x-li-format"];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(profileApiCallResult:didFinish:)
                  didFailSelector:@selector(profileApiCallResult:didFail:)];
    [request release]; 
    
}

- (void)profileApiCallResult:(OAServiceTicket *)ticket didFinish:(NSData *)data
{
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    
    NSDictionary *profile = [responseBody objectFromJSONString];
    [responseBody release];
    
    if ( profile )
    {
//        name.text = [[NSString alloc] initWithFormat:@"%@ %@",
//                     [profile objectForKey:@"firstName"], [profile objectForKey:@"lastName"]];
//        headline.text = [profile objectForKey:@"headline"];
        
        NSString *firstName = [profile objectForKey:@"firstName"];
        NSString *lastName = [profile objectForKey:@"lastName"];
        NSString *picUrl = [profile objectForKey:@"picture-url"];
        NSString *userId = [profile objectForKey:@"id"];
        NSString *email = [profile objectForKey:@"email-address"];
        NSLog(@"linkedin first name: %@, last name: %@, id: %@, url: %@, email: %@", firstName, lastName, userId, picUrl, email);
    }
    
    // The next thing we want to do is call the network updates
    [self networkApiCall];
    
}

- (void)profileApiCallResult:(OAServiceTicket *)ticket didFail:(NSData *)error
{
    NSLog(@"%@",[error description]);
}

- (void)networkApiCall
{
    NSURL *url = [NSURL URLWithString:@"http://api.linkedin.com/v1/people/~/network/updates?scope=self&count=1&type=STAT"];
    OAMutableURLRequest *request =
    [[OAMutableURLRequest alloc] initWithURL:url
                                    consumer:oAuthLoginView.consumer
                                       token:oAuthLoginView.accessToken
                                    callback:nil
                           signatureProvider:nil];
    
    [request setValue:@"json" forHTTPHeaderField:@"x-li-format"];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(networkApiCallResult:didFinish:)
                  didFailSelector:@selector(networkApiCallResult:didFail:)];
    [request release];
    
}

- (void)networkApiCallResult:(OAServiceTicket *)ticket didFinish:(NSData *)data
{
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    
    NSDictionary *person = [[[[[responseBody objectFromJSONString]
                               objectForKey:@"values"]
                              objectAtIndex:0]
                             objectForKey:@"updateContent"]
                            objectForKey:@"person"];
    
    [responseBody release];
    
//    if ( [person objectForKey:@"currentStatus"] )
//    {
//        [postButton setHidden:false];
//        [postButtonLabel setHidden:false];
//        [statusTextView setHidden:false];
//        [updateStatusLabel setHidden:false];
//        status.text = [person objectForKey:@"currentStatus"];
//    } else {
//        [postButton setHidden:false];
//        [postButtonLabel setHidden:false];
//        [statusTextView setHidden:false];
//        [updateStatusLabel setHidden:false];
//        status.text = [[[[person objectForKey:@"personActivities"]
//                         objectForKey:@"values"]
//                        objectAtIndex:0]
//                       objectForKey:@"body"];
//        
//    }
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)networkApiCallResult:(OAServiceTicket *)ticket didFail:(NSData *)error
{
    NSLog(@"%@",[error description]);
}

- (void)postUpdateApiCallResult:(OAServiceTicket *)ticket didFinish:(NSData *)data
{
    // The next thing we want to do is call the network updates
    [self networkApiCall];
    
}

- (void)postUpdateApiCallResult:(OAServiceTicket *)ticket didFail:(NSData *)error
{
    NSLog(@"%@",[error description]);
}
@end
