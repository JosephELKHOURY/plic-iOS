//
//  User.m
//  PLIC-iOS
//
//  Created by SEKIMIA on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize UserId;
@synthesize UUID;
@synthesize Description;
@synthesize Username;
@synthesize Latitude;
@synthesize Longitude;
@synthesize Units;
@synthesize Warrior, Knight, Boomerang;
@synthesize warriorAvgLife, knightAvgLife, boomerangAvgLife;

- (id)createPlayer:(int)playerId
{
    self.units = [[NSMutableArray alloc] init];
    
    return self;
}


- (void)addUnit:(Unit *)unit
{
    if (unit != nil)
        [self.Units addObject:unit];
}



@end
