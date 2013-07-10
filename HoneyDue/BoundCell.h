//
//  BoundCell.h
//  HoneyDue
//
//  Created by Harry Wang on 7/2/13.
//  Copyright (c) 2013 com.mitch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoundCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *priorityImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *msgLabel;
@property (strong, nonatomic) IBOutlet UIImageView *unreadFlagImageView;
@property (strong, nonatomic) IBOutlet UIImageView *calImageView;
@property (strong, nonatomic) IBOutlet UIImageView *reminderImageView;
@property (strong, nonatomic) IBOutlet UIImageView *noteImageView;
@property (strong, nonatomic) IBOutlet UIImageView *contactImageView;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@end
