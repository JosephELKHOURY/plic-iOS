//
//  User.m
//  PLIC-iOS
//
//  Created by SEKIMIA on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize UDID;
@synthesize description;
@synthesize id;
@synthesize username;
@synthesize latitude;
@synthesize longitude;

/*+ (NSDictionary*)elementToPropertyMappings {
    return [NSDictionary dictionaryWithKeysAndObjects:
            @"UDID", @"UDID",
            @"description", @"description", 
            @"id", @"id",
            @"latitude", @"latitude",
            @"longitude", @"longitude",
            @"username", @"username",
            nil];
}*/

/*+ (NSDictionary*) elementToRelationshipMappings {
    return [NSDictionary dictionaryWithKeysAndObjects:
            @"location", @"location", 
            nil];
}*/

@end
