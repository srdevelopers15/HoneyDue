//
//  LoginViewController.h
//  HoneyDue
//
//  Created by Harry Wang on 7/2/13.
//  Copyright (c) 2013 com.mitch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuthLoginView.h"
#import "JSONKit.h"
#import "OAConsumer.h"
#import "OAMutableURLRequest.h"
#import "OADataFetcher.h"
#import "OATokenManager.h"

@interface LoginViewController : UIViewController
- (IBAction)signInWithFB:(id)sender;
- (IBAction)signInWithTW:(id)sender;
- (IBAction)signInWithLI:(id)sender;

- (void)profileApiCall;
- (void)networkApiCall;

@property (nonatomic, retain) OAuthLoginView *oAuthLoginView;

@end
