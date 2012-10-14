//
//  Warrior.h
//  FirstGame
//
//  Created by Epi Mac on 4/20/12.
//  Copyright (c) 2012 EpiMac. All rights reserved.
//

#import <OpenAL/al.h>
#import "cocos2d.h"

typedef enum 
{
    IDLE,
    SELECTED,
    HASMOVED,
    HASATTACKED
} UnitState;

@class Map;

@interface Unit : CCSprite {
    Map *layer;
    int _curHp;
    int _totalHp;
    int _curMoves;
    int attack;
    int distance;
    UnitState state;
    NSString *__weak name;
    NSString *__weak imgFront;
    NSString *__weak imgBack;
    NSString *__weak imgLeft;
    NSString *__weak imgRight;
    CCAnimation *facingForwardAnimation;
    CCAnimation *facingBackAnimation;
    CCAnimation *facingLeftAnimation;
    CCAnimation *facingRightAnimation;
    CCAnimation *_curAnimation;
    CCAnimate *_curAnimate;
    CCAction *currentStepAction;
@private
    NSMutableArray *shortestPath;
    ALuint currentPlayedEffect;
}

@property (nonatomic, retain) Map *layer;
@property (nonatomic, assign) int moves;
@property (nonatomic, assign) int hp;
@property (nonatomic, assign) int totalHp;
@property (nonatomic, assign) int attack;
@property (nonatomic, assign) int distance;
@property (nonatomic, assign) UnitState state;
@property (nonatomic, weak) NSString *name;
@property (nonatomic, weak) NSString *imgFront;
@property (nonatomic, weak) NSString *imgBack;
@property (nonatomic, weak) NSString *imgLeft;
@property (nonatomic, weak) NSString *imgRight;
@property (nonatomic, retain) NSString *imgBigLeft;
@property (nonatomic, retain) NSString *imgBigRight;
@property (nonatomic, retain) NSMutableArray *shortestPath;
@property (nonatomic, retain) CCAction *currentStepAction;
@property (nonatomic, retain) CCAnimation *facingForwardAnimation;
@property (nonatomic, retain) CCAnimation *facingBackAnimation;
@property (nonatomic, retain) CCAnimation *facingLeftAnimation;
@property (nonatomic, retain) CCAnimation *facingRightAnimation;

- (CCAnimation *)createAnimation:(NSString *)animType;
- (void)moveToward:(CGPoint)target;
- (void)popStepAndAnimate;
-(void)setDefaults;

@end

@interface Warrior : Unit {
}

- (id)unitWithLayer:(Map *)layer player:(int)player;
-(void)setDefaults;

@end

@interface Knight : Unit {
}

- (id)unitWithLayer:(Map *)layer player:(int)player;
-(void)setDefaults;

@end

@interface Boomerang : Unit {
}

- (id)unitWithLayer:(Map *)layer player:(int)player;
-(void)setDefaults;

@end