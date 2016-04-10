//
//  BoundCell.m
//  HoneyDue
//
//  Created by Harry Wang on 7/2/13.
//  Copyright (c) 2013 com.mitch. All rights reserved.
//

#import "BoundCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation BoundCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
