//
//  ParseService.h
//  HoneyDue
//
//  Created by Harry Wang on 7/7/13.
//  Copyright (c) 2013 com.mitch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bundle.h"

@interface ParseService : NSObject
+(ParseService *)sharedParseService;
-(void)getAllBundles:(void (^)(NSError *error, NSArray *stores))completion;
@end
