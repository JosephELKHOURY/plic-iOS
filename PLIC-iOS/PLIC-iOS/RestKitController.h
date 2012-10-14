//
//  RestKitController.h
//  PLIC-iOS
//
//  Created by SEKIMIA on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "User.h"
#import "Bonus.h"
#import "Player.h"

@protocol MapControllerDelegate <NSObject>

-(void)addUsers;
-(void)addBonuses;

@end

@protocol MasterControllerDelegate <NSObject>

- (void)setPlayer;

@end

@protocol MapControllerDelegate;

@interface RestKitController : NSObject <RKObjectLoaderDelegate>
{
    id<MapControllerDelegate> mapDelegate;
    id<MasterControllerDelegate> masterDelegate;
}

@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) NSMutableArray *bonuses;
@property (strong, nonatomic) NSMutableArray *armies;
@property (strong, nonatomic) id<MapControllerDelegate> mapDelegate;
@property (strong, nonatomic) id<MasterControllerDelegate> masterDelegate;

+ (RestKitController*)getInstance;
- (void)setupMappingAndRoutes;
- (void)getUsers;
- (void)getArmies;
- (void)getArmiesOfPlayer:(int)playerId;
- (void)createUser:(NSObject *)user;
- (void)updateUser:(NSObject *)user;
- (void)deleteUser:(NSObject *)user;

@end
