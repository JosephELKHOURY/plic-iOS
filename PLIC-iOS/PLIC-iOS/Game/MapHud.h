//
//  MapHudLayer.h
//  Parilinx
//
//  Created by Leo on 10/1/12.
//  Copyright (c) 2012 Leo. All rights reserved.
//

#import "cocos2d.h"
#import "CCMenuAdvanced.h"
#import "UnitStatsLayer.h"
#import "Unit.h"
#import "UnitListLayer.h"

@protocol MapDelegate <NSObject>

-(void)endTurn;
-(NSMutableArray *) getCurrentPlayerUnitList;
-(Unit *)createUnitOfType:(NSString *)type AtPosition:(CGPoint)p forPlayer:(int)player;
-(void)deselectEligibleTiles;
-(void)deselectEligibleTileAtPosition:(CGPoint)pos;

@end

@interface MapHud : CCLayer
{
    CCMenu *radioMenu;
    CCMenu *mainMenu;
    CCMenu *mMenu;
    CCMenu *unitMenu;
    CCMenuItem *endTurnItem;
    CCMenuItem *waitTurnItem;
    CCMenuItem *warriorItem;
    CCMenuItem *knightItem;
    CCMenuItem *boomerangItem;
    UnitStatsLayer *unitStats;
    UnitListLayer *unitListLayer;
    CCLabelTTF *status;
    id<MapDelegate> delegate;
    CGPoint unitPosition;
}

@property (nonatomic, retain) CCMenu *radioMenu;
@property (nonatomic, retain) CCMenu *mainMenu;
@property (nonatomic, retain) CCMenu *unitMenu;
@property (nonatomic, retain) CCMenuItem *endTurnItem;
@property (nonatomic, retain) CCMenuItem *waitTurnItem;
@property (nonatomic, retain) CCMenuItem *warriorItem;
@property (nonatomic, retain) CCMenuItem *knightItem;
@property (nonatomic, retain) CCMenuItem *boomerangItem;
@property (nonatomic, retain) UnitStatsLayer *unitStats;
@property (nonatomic, retain) UnitListLayer *unitListLayer;
@property (nonatomic, retain) CCLabelTTF *status;
@property (nonatomic, retain) id<MapDelegate> delegate;
@property (nonatomic) CGPoint unitPosition;

-(void) showEndTurn;
-(void) showUnitStats:(Unit *)unit;
-(void) hideUnitStats;
-(void) showEndTurn;
-(void) showWaitTurn;
-(void) showMenu;
-(void) goBack;
-(void) goSettings;
-(void) showUnitMenuWithPosition:(CGPoint)p;

@end
