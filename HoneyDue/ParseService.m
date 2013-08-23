//
//  ParseService.m
//  HoneyDue
//
//  Created by Harry Wang on 7/7/13.
//  Copyright (c) 2013 com.mitch. All rights reserved.
//

#import "ParseService.h"
#import <Parse/Parse.h>
#import "Bundle.h"

@implementation ParseService
+(ParseService *)sharedParseService{
    static ParseService *glgGmaeServiceInstance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        glgGmaeServiceInstance = [[ParseService alloc] init];
        
    });
    
    return glgGmaeServiceInstance;
}


-(void)getAllBundlesByOwnerName:(NSString *)name completion:(void (^)(NSError *, NSArray *))completion{
    NSLog(@"start to retrieve bundles.");
    PFQuery *query = [PFQuery queryWithClassName:@"bundle"];
    query.limit = 1000;
    //[query includeKey:name];
    [query whereKey:@"ownerName" equalTo:name];
    [query findObjectsInBackgroundWithBlock:^(NSArray *bundles, NSError *pfError) {
        if (!pfError && bundles.count > 0) {
            NSLog(@"Successfully retrieved %d bundles.", bundles.count);
            NSMutableArray *bundlesForReturn = [[NSMutableArray alloc]init];
                for (PFObject *aBundle in bundles) {
                    Bundle *bundle = [[Bundle alloc]init];
                    [bundle setObjectId:[aBundle objectId]];
                    [bundle setOwnerName:[aBundle objectForKey:@"ownerName"]];
                    [bundle setMsg:[aBundle objectForKey:@"msg"]];
                    [bundle setAvatarUrl:[aBundle objectForKey:@"avatarUrl"]];
                    [bundle setDate:[aBundle objectForKey:@"date"]];
                    [bundle setTime:[aBundle objectForKey:@"time"]];
                    [bundle setDueDate:[aBundle objectForKey:@"dueDate"]];
                    [bundle setReminders:[aBundle objectForKey:@"reminders"]];
                    [bundle setNotes:[aBundle objectForKey:@"notes"]];
                    [bundle setContacts:[aBundle objectForKey:@"contacts"]];
                    [bundle setUnformattedDueDate:[aBundle objectForKey:@"unformattedDueDate"]];
                    [bundlesForReturn addObject:bundle];
                }
            completion(nil,bundlesForReturn);
            
        } else {
            NSLog(@"Error: %@ %@", pfError, [pfError userInfo]);
            completion(pfError,nil);
        }
    }];
}

-(void)getAllBundlesByReceiver:(NSString *)name completion:(void (^)(NSError *, NSArray *))completion{
    NSLog(@"start to retrieve bundles.");
    PFQuery *query = [PFQuery queryWithClassName:@"bundle"];
    query.limit = 1000;
    //[query includeKey:name];
    [query whereKey:@"receiver" equalTo:name];
    [query findObjectsInBackgroundWithBlock:^(NSArray *bundles, NSError *pfError) {
        if (!pfError && bundles.count > 0) {
            NSLog(@"Successfully retrieved %d bundles.", bundles.count);
            NSMutableArray *bundlesForReturn = [[NSMutableArray alloc]init];
            for (PFObject *aBundle in bundles) {
                Bundle *bundle = [[Bundle alloc]init];
                [bundle setObjectId:[aBundle objectForKey:@"objectId"]];
                [bundle setOwnerName:[aBundle objectForKey:@"ownerName"]];
                [bundle setMsg:[aBundle objectForKey:@"msg"]];
                [bundle setAvatarUrl:[aBundle objectForKey:@"avatarUrl"]];
                [bundle setDate:[aBundle objectForKey:@"date"]];
                [bundle setTime:[aBundle objectForKey:@"time"]];
                [bundle setDueDate:[aBundle objectForKey:@"dueDate"]];
                [bundle setReminders:[aBundle objectForKey:@"reminders"]];
                [bundle setNotes:[aBundle objectForKey:@"notes"]];
                [bundle setContacts:[aBundle objectForKey:@"contacts"]];
                [bundle setUnformattedDueDate:[aBundle objectForKey:@"unformattedDueDate"]];
                [bundlesForReturn addObject:bundle];
            }
            completion(nil,bundlesForReturn);
            
        } else {
            NSLog(@"Error: %@ %@", pfError, [pfError userInfo]);
            completion(pfError,nil);
        }
    }];
}

@end
