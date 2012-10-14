//
//  UnitStatsLayer.h
//  PariskGame
//
//  Created by Lion User on 28/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Unit.h"

@interface UnitStatsLayer : CCLayer
{ 
    CCProgressTimer *healthBar;
    CCSprite *bgSprite;
    CCSprite *bar;
    CCLabelTTF *unitName;
    CCLabelTTF *unitHP;
}

- (id) initWithUnit:(Unit *)unit;

@end
