//
//  InBoundAssetCell.h
//  HoneyDue
//
//  Created by Harry Wang on 8/6/13.
//  Copyright (c) 2013 com.mitch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InBoundAssetCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *assetIconImageView;
@property (strong, nonatomic) IBOutlet UILabel *assetNameLabel;
@property (strong, nonatomic) IBOutlet UISwitch *assetSwitch;

@end
