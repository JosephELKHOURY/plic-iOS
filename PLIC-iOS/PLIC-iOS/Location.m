//
//  Location.m
//  PLIC-iOS
//
//  Created by SEKIMIA on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Location.h"

@implementation Location

@synthesize latitude;
@synthesize longitude;

+ (NSDictionary*)elementToPropertyMappings {
    return [NSDictionary dictionaryWithKeysAndObjects:
            @"latitude", @"latitude",
            @"longitude", @"longitude",
            nil];
}

@end
