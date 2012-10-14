//
//  Warrior.m
//  FirstGame
//
//  Created by Epi Mac on 4/20/12.
//  Copyright (c) 2012 EpiMac. All rights reserved.
//

#import "Unit.h"
#import "MapScene.h"
#import "ShortestPath.h"

static const float kMovingSpeed = 0.4;

//TODO FIX
static const float kAnimationDelay = 500;

@implementation Unit

@synthesize layer;
@synthesize hp = _curHp;
@synthesize moves = _curMoves;
@synthesize distance;
@synthesize state;
@synthesize attack;
@synthesize totalHp;
@synthesize name;
@synthesize imgFront, imgBack, imgLeft, imgRight;
@synthesize imgBigLeft, imgBigRight;
@synthesize shortestPath;
@synthesize currentStepAction;
@synthesize facingForwardAnimation, facingBackAnimation, facingLeftAnimation, facingRightAnimation;

- (CCAnimation *)createAnimation:(NSString *)animType
{    
    NSMutableArray* frames = [NSMutableArray arrayWithCapacity:1];
    CCTexture2D* texture;
    if ([animType isEqualToString:@"forward"])
    {
        texture = [[CCTextureCache sharedTextureCache] addImage:imgFront];
    }
    else if ([animType isEqualToString:@"back"])
    {
        texture = [[CCTextureCache sharedTextureCache] addImage:imgBack];
    }
    else if ([animType isEqualToString:@"left"])
    {
        texture = [[CCTextureCache sharedTextureCache] addImage:imgLeft];
    }
    else
    {
        texture = [[CCTextureCache sharedTextureCache] addImage:imgRight];
    }
    CGSize texSize = [texture contentSize];
    CGRect texRect = CGRectMake(0, 0, texSize.width, texSize.height);
    CCSpriteFrame* frame = [CCSpriteFrame frameWithTexture:texture rect:texRect];
    [frames addObject:frame];
    
    CCAnimation* animation = [[CCAnimation alloc] initWithSpriteFrames:frames delay:kAnimationDelay];
    
    return animation;
}

- (void)runAnimation:(CCAnimation *)animation
{
    if (_curAnimation == animation) return;
        _curAnimation = animation;
    
    _curAnimate = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]];
    [self runAction:_curAnimate];
}


- (void)moveToward:(CGPoint)target
{
    ShortestPath *algorithm = [ShortestPath alloc];
    self.shortestPath = [algorithm moveToward:target unit:self layer:layer];
}

- (void)popStepAndAnimate
{	
    self.currentStepAction = nil;
    
	// Check if there remains path steps to go through
	if ([self.shortestPath count] == 0) {
		self.shortestPath = nil;
		return;
	}
	
	// Get the next step to move to
	ShortestPathStep *s = [self.shortestPath objectAtIndex:0];
	
	CGPoint futurePosition = s.position;
    CGPoint currentPosition = [layer tileCoordForPosition:self.position];
    
	CGPoint diff = ccpSub(futurePosition, currentPosition);
	if (abs(diff.x) > abs(diff.y)) {
		if (diff.x > 0) {
			[self runAnimation:facingRightAnimation];
		}
		else {
			[self runAnimation:facingLeftAnimation];
		}    
	}
	else {
		if (diff.y > 0) {
			[self runAnimation:facingForwardAnimation];
		}
		else {
			[self runAnimation:facingBackAnimation];
		}
	}
	
	// Prepare the action and the callback
	id moveAction = [CCMoveTo actionWithDuration:kMovingSpeed position:[layer positionForTileCoord:s.position]];
	id moveCallback = [CCCallFunc actionWithTarget:self selector:@selector(popStepAndAnimate)]; // set the method itself as the callback
	self.currentStepAction = [CCSequence actions:moveAction, moveCallback, nil];
	
	// Remove the step
	[self.shortestPath removeObjectAtIndex:0];

	// Play actions
	[self runAction:currentStepAction];
}

-(void)setDefaults
{
}


@end

@implementation Warrior

- (id)unitWithLayer:(Map *)map player:(int)player 
{    
    Warrior *unit = nil;
    NSString *color = nil;
    
    if (player == 1)
        color = @"blue";
    else if (player == 2)
        color = @"red";
  
    if ((unit = [super initWithFile:[NSString stringWithFormat:@"fatMittou_front_%@.png", color]])) {
        unit.layer = map;
        unit.totalHp = 20;
        unit.hp = unit.totalHp;
        unit.moves = 3;
        unit.distance = 1;
        unit.attack = 5;
        unit.state = IDLE;
        unit.shortestPath = nil;
        unit.name = @"Warrior";
        unit.imgFront = [NSString stringWithFormat:@"fatMittou_front_%@.png", color];
        unit.imgBack = [NSString stringWithFormat:@"fatMittou_back_%@.png", color];
        unit.imgLeft = [NSString stringWithFormat:@"fatMittou_left_%@.png", color];
        unit.imgRight = [NSString stringWithFormat:@"fatMittou_right_%@.png", color];
        
        unit.imgBigRight = [NSString stringWithFormat:@"big_fatMittou_right_%@.png", color];
        unit.imgBigLeft = [NSString stringWithFormat:@"big_fatMittou_left_%@.png", color];
        
        unit.facingForwardAnimation = [self createAnimation:@"forward"];
        unit.facingBackAnimation = [self createAnimation:@"back"];
        unit.facingLeftAnimation = [self createAnimation:@"left"];
        unit.facingRightAnimation = [self createAnimation:@"right"];
    }
    return unit;    
}

-(void)setDefaults
{
    self.moves = 3;
    self.state = IDLE;
}

@end

@implementation Knight

- (id)unitWithLayer:(Map *)map player:(int)player 
{
    Knight *unit = nil;
    NSString *color = nil;
    
    if (player == 1)
        color = @"blue";
    else if (player == 2)
        color = @"red";
    
    if ((unit = [super initWithFile:[NSString stringWithFormat:@"horseman_front_%@.png", color]])) {
        unit.layer = map;
        unit.totalHp = 16;
        unit.hp = unit.totalHp;
        unit.moves = 5;
        unit.distance = 1;
        unit.attack = 4;
        unit.state = IDLE;
        unit.name = @"Knight";
        unit.imgFront = [NSString stringWithFormat:@"horseman_front_%@.png", color];
        unit.imgBack = [NSString stringWithFormat:@"horseman_back_%@.png", color];
        unit.imgLeft = [NSString stringWithFormat:@"horseman_left_%@.png", color];
        unit.imgRight = [NSString stringWithFormat:@"horseman_right_%@.png", color];
        
        unit.imgBigRight = [NSString stringWithFormat:@"big_horseman_right_%@.png", color];
        unit.imgBigLeft = [NSString stringWithFormat:@"big_horseman_left_%@.png", color];
        
        unit.facingForwardAnimation = [self createAnimation:@"forward"];
        unit.facingBackAnimation = [self createAnimation:@"back"];
        unit.facingLeftAnimation = [self createAnimation:@"left"];
        unit.facingRightAnimation = [self createAnimation:@"right"];
        unit.shortestPath = nil;
    }
    return unit;
}

-(void)setDefaults
{
    self.moves = 5;
    self.state = IDLE;
}

@end

@implementation Boomerang

- (id)unitWithLayer:(Map *)map player:(int)player 
{
    Boomerang *unit = nil;
    NSString *color = nil;
    
    if (player == 1)
        color = @"blue";
    else if (player == 2)
        color = @"red";
    
    if ((unit = [super initWithFile:[NSString stringWithFormat:@"bowman_front_%@.png", color]])) {
        unit.layer = map;
        unit.totalHp = 10;
        unit.hp = unit.totalHp;
        unit.moves = 4;
        unit.distance = 3;
        unit.attack = 3;
        unit.state = IDLE;
        unit.name = @"Boomerang";
        unit.imgFront = [NSString stringWithFormat:@"bowman_front_%@.png", color];
        unit.imgBack = [NSString stringWithFormat:@"bowman_back_%@.png", color];
        unit.imgLeft = [NSString stringWithFormat:@"bowman_left_%@.png", color];
        unit.imgRight = [NSString stringWithFormat:@"bowman_right_%@.png", color];
        
        unit.imgBigRight = [NSString stringWithFormat:@"big_bowman_right_%@.png", color];
        unit.imgBigLeft = [NSString stringWithFormat:@"big_bowman_left_%@.png", color];
        
        unit.facingForwardAnimation = [self createAnimation:@"forward"];
        unit.facingBackAnimation = [self createAnimation:@"back"];
        unit.facingLeftAnimation = [self createAnimation:@"left"];
        unit.facingRightAnimation = [self createAnimation:@"right"];
        unit.shortestPath = nil;
    }
    return unit;
}

-(void)setDefaults
{
    self.moves = 4;
    self.state = IDLE;
}

@end