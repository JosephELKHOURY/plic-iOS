//
//  UnitStatsLayer.m
//  PariskGame
//
//  Created by Lion User on 28/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Unit.h"
#import "UnitStatsLayer.h"

@implementation UnitStatsLayer

- (id) initWithUnit:(Unit *)unit 
{
    if ((self = [super init]))
    {
        bgSprite = [CCSprite spriteWithFile:@"healthbarEmpty.png"];
        bgSprite.position = ccp(-19,30);
        [self addChild:bgSprite];
        
        float percent = unit.hp * 100 / unit.totalHp;
        
        if (percent > 30) {
            bar = [CCSprite spriteWithFile:@"healthBar.png"];
        }
        else {
            bar = [CCSprite spriteWithFile:@"healthbarAlert.png"];
        }
        
        healthBar = [CCProgressTimer progressWithSprite:bar];
        healthBar.type = kCCProgressTimerTypeBar;
        healthBar.barChangeRate=ccp(1,0);
        healthBar.midpoint=ccp(0,0);
        
        healthBar.percentage = percent;
        
        [self addChild:healthBar z:3];
        [healthBar setAnchorPoint: ccp(0.5,-2)];
        
        
    }
    return self;
}

@end
