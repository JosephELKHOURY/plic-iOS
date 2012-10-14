//
//  MapHudLayer.m
//  Parilinx
//
//  Created by Leo on 10/1/12.
//  Copyright (c) 2012 Leo. All rights reserved.
//

#import "MapHud.h"

@implementation MapHud

@synthesize radioMenu, mainMenu, unitMenu, endTurnItem, waitTurnItem;
@synthesize warriorItem, knightItem, boomerangItem;
@synthesize unitStats;
@synthesize unitPosition;
@synthesize status;
@synthesize delegate;

-(id) init
{
    if ((self = [super init]))
    {
        radioMenu = [CCMenu menuWithItems: nil];
        [radioMenu alignItemsHorizontally];
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CGPoint point = ccp(winSize.width - 50, 30);
        [radioMenu setPosition:point];
        
        [self addChild:radioMenu];
        
        CCMenuItem *backItem = [CCMenuItemImage itemWithNormalImage:@"back.png" selectedImage:@"backSel.png" target:self selector:@selector(goBack)];
        
        CCMenuItem *settingsItem = [CCMenuItemImage itemWithNormalImage:@"setting.png" selectedImage:@"settingSel.png" target:self selector:@selector(goSettings)];
        
        CCMenuItemLabel *showUnitsItem = [CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"Units" fontName:@"Arial" fontSize:12] target:self selector:@selector(showUnits)];
        
        mainMenu = [CCMenu menuWithItems: showUnitsItem, settingsItem, backItem, nil];
        [mainMenu alignItemsVerticallyWithPadding:0];
        
        CCMenuItem *menuItem = [CCMenuItemImage
                                itemWithNormalImage:@"menuButton.png" selectedImage:@"menuButtonSel.png"
                                target:self selector:@selector(showMenu)];
        mMenu = [CCMenu menuWithItems: menuItem, nil];
        
        
        point = ccp(50, 30);
        [mainMenu setPosition:point];
        [mainMenu setVisible:NO];
        [mMenu setPosition:point];
        [self addChild:mainMenu];
        [self addChild:mMenu];
        
        warriorItem = [CCMenuItemImage itemWithNormalImage:@"warriorButton.png" selectedImage:@"warriorButtonSel.png" target:self selector:@selector(placeWarrior)];
        knightItem = [CCMenuItemImage itemWithNormalImage:@"horsemanButton.png" selectedImage:@"horsemanButtonSel.png" target:self selector:@selector(placeKnight)];
        boomerangItem = [CCMenuItemImage itemWithNormalImage:@"boomerangButton.png" selectedImage:@"boomerangButtonSel.png" target:self selector:@selector(placeBoomerang)];
        
        unitMenu = [CCMenu menuWithItems: warriorItem, knightItem, boomerangItem, nil];
        [unitMenu alignItemsVertically];
        point = ccp(50, winSize.height - 50);
        [unitMenu setPosition:point];
        [self addChild:unitMenu];
        unitMenu.visible = NO;
    }
    return self;
}

- (void)showUnitMenuWithPosition:(CGPoint)p
{
    [unitMenu setVisible:YES];
    unitPosition = p;
}

-(void)placeWarrior
{
    if ([delegate createUnitOfType:@"Warrior" AtPosition:unitPosition forPlayer:1] != nil)
    {
        [delegate deselectEligibleTileAtPosition:unitPosition];
    }
    [unitMenu setVisible:NO];
}

-(void)placeKnight
{
    if ([delegate createUnitOfType:@"Knight" AtPosition:unitPosition forPlayer:1] != nil)
    {
        [delegate deselectEligibleTileAtPosition:unitPosition];
    }
    [unitMenu setVisible:NO];
}

-(void)placeBoomerang
{
    if ([delegate createUnitOfType:@"Boomerang" AtPosition:unitPosition forPlayer:1] != nil)
    {
        [delegate deselectEligibleTileAtPosition:unitPosition];
    }
    [unitMenu setVisible:NO];
}

-(void)showUnits
{
    [mainMenu setVisible:NO];
    [mMenu setVisible:YES];
}

- (void)showMenu
{
    [mainMenu setVisible:YES];
    [mMenu setVisible:NO];
}

- (void)goBack
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Are you sure you want to quit the game ?"
                                                       delegate:self
                                              cancelButtonTitle:@"No"
                                              otherButtonTitles:@"Yes", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [[CCDirector sharedDirector] popScene];
        [mainMenu setVisible:NO];
        [mMenu setVisible:YES];
    }
}

- (void)goSettings
{
    [mainMenu setVisible:NO];
    [mMenu setVisible:YES];
}

- (void) showUnitStats:(Unit *)unit
{
    [self hideUnitStats];
    unitStats = [[UnitStatsLayer alloc] initWithUnit:unit];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CGPoint point = ccp(winSize.width - 50, winSize.height - 50);
    [unitStats setPosition:point];
    
    [self addChild:unitStats];
}

- (void) hideUnitStats
{
    [self removeChild:unitStats cleanup:YES];
}

- (void) showEndTurn
{
    if ([radioMenu.children count] > 0)
        [radioMenu removeAllChildrenWithCleanup:NO];
    
    endTurnItem = [CCMenuItemImage itemWithNormalImage:@"endTurn2.png"
                                         selectedImage:@"endTurnSel2.png" target:self selector:@selector(endButtonTapped:)];
    [radioMenu addChild:endTurnItem];
}

- (void) showWaitTurn
{
    if ([radioMenu.children count] > 0)
        [radioMenu removeAllChildrenWithCleanup:NO];
    
    waitTurnItem = [CCMenuItemImage itemWithNormalImage:@"wait.png"
                                          selectedImage:@"wait.png" target:self selector:@selector(waitButtonTapped:)];
    [radioMenu addChild:waitTurnItem];
}

- (void)endButtonTapped:(id)sender
{
    [delegate endTurn];
    [unitMenu setVisible:NO];
}

- (void)waitButtonTapped:(id)sender
{
}
@end


