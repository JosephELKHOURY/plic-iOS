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
    NSString *UUID;
    NSString *description;
    NSNumber *id;
    NSString *username;
    NSString *latitude;
    NSString *longitude;
    NSMutableArray *units;
    int Warrior;
    int Knight;
    int Boomerang;
    float warriorAvgLife;
    float knightAvgLife;
    float boomerangAvgLife;
}

@property (strong, nonatomic) NSString *UUID;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSNumber *id;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSMutableArray *units;
@property (nonatomic, assign) int Warrior;
@property (nonatomic, assign) int Knight;
@property (nonatomic, assign) int Boomerang;
@property (nonatomic, assign) float warriorAvgLife;
@property (nonatomic, assign) float knightAvgLife;
@property (nonatomic, assign) float boomerangAvgLife;

- (id)createPlayer:(int)playerId;
- (void)addUnit:(Unit *)unit;


@end
