//
//  Bundle.h
//  HoneyDue
//
//  Created by Harry Wang on 7/7/13.
//  Copyright (c) 2013 com.mitch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bundle : NSObject
@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) UIImage *ownerAvatarImage;
@property (nonatomic, assign) BOOL readThisBundle;
@property (strong, nonatomic) NSString *ownerName;
@property (strong, nonatomic) NSString *receiver;
@property (strong, nonatomic) NSString *msg;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *avatarUrl;
@property (strong, nonatomic) NSString *dueDate;
@property (strong, nonatomic) NSMutableArray *reminders;
@property (strong, nonatomic) NSMutableArray *notes;
@property (strong, nonatomic) NSMutableArray *contacts;
@property (strong, nonatomic) NSDate *unformattedDueDate;

-(Bundle *) initWithOwnerName:(NSString *)ownerName Msg:(NSString *)msg;
@end
