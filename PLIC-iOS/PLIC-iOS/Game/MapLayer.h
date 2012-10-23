//
//  MapLayer.h
//  PLIC-iOS
//
//  Created by Leo on 10/18/12.
//
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

#import "cocos2d.h"
#import "Player.h"

@interface MapLayer : CCLayer
{
    RestKitController *rest;
    
    CCTMXTiledMap *tileMap;
    CCTMXLayer *background;
    CCTMXLayer *meta;

    Player *player1;
    Player *player2;
    

	NSInteger	gameState;
}

@property (strong, nonatomic) RestKitController *rest;

@property (nonatomic, retain) CCTMXTiledMap *tileMap;
@property (nonatomic, retain) CCTMXLayer *background;
@property (nonatomic, retain) CCTMXLayer *meta;

@property (nonatomic, retain) Player *player1;
@property (nonatomic, retain) Player *player2;

@property(nonatomic) NSInteger gameState;

@end
