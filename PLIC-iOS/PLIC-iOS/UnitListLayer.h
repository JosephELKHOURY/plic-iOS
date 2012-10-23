//
//  UnitListLayer.h
//  PLIC-iOS
//
//  Created by Leo on 10/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Unit.h"

@class Unit;

@interface UnitListLayer : CCLayer {
    NSMutableArray *unitList;
    CCNode *widget;
    CCNode *widgetReversed;
}

@property (nonatomic, retain) NSMutableArray *unitList;
@property (nonatomic, retain) CCNode *widget;
@property (nonatomic, retain) CCNode *widgetReversed;

- (CCNode *) widget;
- (CCNode *) widgetReversed;
- (void) updateForScreenReshape;
- (void) updateWidget;
- (void) refreshForUnitList:(NSMutableArray *)playerUnitList;

@end
