//
//  User.m
//  PLIC-iOS
//
//  Created by SEKIMIA on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize UUID;
@synthesize description;
@synthesize id;
@synthesize username;
@synthesize latitude;
@synthesize longitude;
@synthesize units;
@synthesize Warrior, Knight, Boomerang;

- (id)createPlayer:(int)playerId
{
    self.units = [[NSMutableArray alloc] init];
    
    return self;
}


- (void)addUnit:(Unit *)unit
{
    if (unit != nil)
        [self.units addObject:unit];
}


@end
