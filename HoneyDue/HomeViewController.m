//
//  HoneyDueViewController.m
//  HoneyDue
//
//  Created by Harry Wang on 7/1/13.
//  Copyright (c) 2013 com.mitch. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController () <UIScrollViewDelegate>

@end

@implementation HomeViewController
@synthesize boundScrollView;
@synthesize boundPageControl;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self initScrollView];
}

- (void)initScrollView {
    boundScrollView.delegate = self;
    CGSize scrollableSize = CGSizeMake(240, [boundScrollView bounds].size.height);
    [boundScrollView setContentSize:scrollableSize];
    int x=0;
    NSMutableArray *languageArray=[[NSMutableArray alloc]initWithObjects:@"Inbound",@"Outbound",nil];
    for(int i=0;i<[languageArray count];i++)
    {
        UILabel *boundLabel=[[UILabel alloc]initWithFrame:CGRectMake(x, 0,120,40 )];
        boundLabel.text=[languageArray objectAtIndex:i];
        boundLabel.font = [UIFont boldSystemFontOfSize:17];
        boundLabel.backgroundColor = [UIColor clearColor];
        boundLabel.textColor = [UIColor whiteColor];
        boundLabel.textAlignment = NSTextAlignmentCenter;
        [boundScrollView addSubview:boundLabel];
        x+=boundLabel.frame.size.width;
    }
}

- (IBAction)createNewBundle:(id)sender {
    [self performSegueWithIdentifier:@"CreateNewBundle" sender:self];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = boundScrollView.frame.size.width;
    int page = floor((boundScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    boundPageControl.currentPage = page;
}
@end
