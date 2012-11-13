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
    int UserId;
    NSString *UUID;
    NSString *Description;
    NSString *Username;
    NSString *Latitude;
    NSString *Longitude;
    NSMutableArray *Units;
    int Warrior;
    int Knight;
    int Boomerang;
    float warriorAvgLife;
    float knightAvgLife;
    float boomerangAvgLife;
}

@property (nonatomic, assign) int UserId;
@property (strong, nonatomic) NSString *UUID;
@property (strong, nonatomic) NSString *Description;
@property (strong, nonatomic) NSNumber *id;
@property (strong, nonatomic) NSString *Username;
@property (strong, nonatomic) NSString *Latitude;
@property (strong, nonatomic) NSString *Longitude;
@property (strong, nonatomic) NSMutableArray *Units;
@property (nonatomic, assign) int Warrior;
@property (nonatomic, assign) int Knight;
@property (nonatomic, assign) int Boomerang;
@property (nonatomic, assign) float warriorAvgLife;
@property (nonatomic, assign) float knightAvgLife;
@property (nonatomic, assign) float boomerangAvgLife;

- (id)createPlayer:(int)playerId;
- (void)addUnit:(Unit *)unit;


@end
