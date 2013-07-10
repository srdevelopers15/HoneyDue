//
//  Bundle.h
//  HoneyDue
//
//  Created by Harry Wang on 7/7/13.
//  Copyright (c) 2013 com.mitch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bundle : NSObject
@property (strong, nonatomic) UIImage *ownerAvatarImage;
@property (nonatomic, assign) BOOL readThisBundle;
@property (strong, nonatomic) NSString *ownerName;
@property (strong, nonatomic) NSString *msg;
@property (strong, nonatomic) NSString *calendarId;
@property (strong, nonatomic) NSString *contactId;
@property (strong, nonatomic) NSString *reminderId;
@property (strong, nonatomic) NSString *noteId;
@property (strong, nonatomic) NSString *date;

-(Bundle *) initWithOwnerName:(NSString *)ownerName Msg:(NSString *)msg;
@end
