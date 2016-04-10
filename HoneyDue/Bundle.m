//
//  Bundle.m
//  HoneyDue
//
//  Created by Harry Wang on 7/7/13.
//  Copyright (c) 2013 com.mitch. All rights reserved.
//

#import "Bundle.h"

@implementation Bundle
@synthesize ownerName;
@synthesize msg;

-(Bundle *) initWithOwnerName:(NSString *)aOwnerName Msg:(NSString *)aMsg {
    self = [super init];
    if (self) {
        ownerName = aOwnerName;
        msg = aMsg;
    }
    return self;
}

@end
