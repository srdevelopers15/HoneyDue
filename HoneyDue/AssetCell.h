//
//  AssetCell.h
//  HoneyDue
//
//  Created by Harry Wang on 7/30/13.
//  Copyright (c) 2013 com.mitch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssetCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *stuffsView;
@property (strong, nonatomic) IBOutlet UIImageView *typeImageView;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;
@property (strong, nonatomic) IBOutlet UITextField *cellTextField;

@end
