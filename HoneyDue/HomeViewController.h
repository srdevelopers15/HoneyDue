//
//  HoneyDueViewController.h
//  HoneyDue
//
//  Created by Harry Wang on 7/1/13.
//  Copyright (c) 2013 com.mitch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIScrollView *boundScrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *boundPageControl;

- (IBAction)createNewBundle:(id)sender;

@end
