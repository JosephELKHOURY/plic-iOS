//
//  User.h
//  PLIC-iOS
//
//  Created by SEKIMIA on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "Unit.h"

@interface User : NSObject
{
    NSString *UserId;
    NSString *UUID;
    NSString *Description;
    NSString *Username;
    NSString *Latitude;
    NSString *Longitude;
    NSMutableArray *Units;
    NSNumber *Warrior;
    NSNumber *Knight;
    NSNumber *Boomerang;
    float warriorAvgLife;
    float knightAvgLife;
    float boomerangAvgLife;
}

@property (strong, nonatomic) NSString *UserId;
@property (strong, nonatomic) NSString *UUID;
@property (strong, nonatomic) NSString *Description;
@property (strong, nonatomic) NSNumber *id;
@property (strong, nonatomic) NSString *Username;
@property (strong, nonatomic) NSString *Latitude;
@property (strong, nonatomic) NSString *Longitude;
@property (strong, nonatomic) NSMutableArray *Units;
@property (strong, nonatomic) NSNumber *Warrior;
@property (strong, nonatomic) NSNumber *Knight;
@property (strong, nonatomic) NSNumber *Boomerang;
@property (nonatomic, assign) float warriorAvgLife;
@property (nonatomic, assign) float knightAvgLife;
@property (nonatomic, assign) float boomerangAvgLife;

- (id)createPlayer:(int)playerId;
- (void)addUnit:(Unit *)unit;


@end
