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


-(void)getAllBundles:(void (^)(NSError *, NSArray *))completion{
    PFQuery *query = [PFQuery queryWithClassName:@"stores"];
    query.limit = 1000;
    [query includeKey:@"stores"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *bundles, NSError *pfError) {
        if (!pfError) {
            NSLog(@"Successfully retrieved %d stores.", bundles.count);
            NSMutableArray *storesForReturn = [[NSMutableArray alloc]init];
            for (PFObject *aBundle in bundles) {
                Bundle *bundle = [[Bundle alloc]init];
                [bundle setOwnerName:[aBundle objectForKey:@"ownerName"]];
                [bundle setMsg:[aBundle objectForKey:@"msg"]];
                PFFile *imageFile = [aBundle objectForKey:@"ownerAvatar"];
                [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    if (!error) {
                        UIImage *image = [UIImage imageWithData:data];
                        [bundle setOwnerAvatarImage:image];
                    }
                }];
                [storesForReturn addObject:bundle];
            }
            completion(nil,storesForReturn);
            
        } else {
            NSLog(@"Error: %@ %@", pfError, [pfError userInfo]);
            completion(pfError,nil);
        }
    }];
}

@end
