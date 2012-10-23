//
//  MapLayer.m
//  PLIC-iOS
//
//  Created by Leo on 10/18/12.
//
//

#import "MapLayer.h"

@implementation MapLayer

@synthesize rest;
@synthesize tileMap;
@synthesize background;
@synthesize meta;
@synthesize player1, player2;
@synthesize gameState;

+(id) scene:(Player *)player
{
	CCScene *scene = [CCScene node];
    
	MapLayer *layer = [MapLayer node];
	[scene addChild: layer];
    
    layer.player1 = player;
    
	return scene;
}

-(id) init
{
    if( (self=[super init] )) {
        self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"map.tmx"];
        self.background = [tileMap layerNamed:@"Background"];
        self.meta = [tileMap layerNamed:@"Meta"];
        
        [self addChild:tileMap z:-1];
    }
    return self;
}

-(void) setViewpointCenter:(CGPoint) position {
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    int x = MAX(position.x, winSize.width / 2);
    int y = MAX(position.y, winSize.height / 2);
    x = MIN(x, (tileMap.mapSize.width * tileMap.tileSize.width)
            - winSize.width / 2);
    y = MIN(y, (tileMap.mapSize.height * tileMap.tileSize.height)
            - winSize.height/2);
    CGPoint actualPosition = ccp(x, y);
    
    CGPoint centerOfView = ccp(winSize.width/2, winSize.height/2);
    CGPoint viewPoint = ccpSub(centerOfView, actualPosition);
    self.position = viewPoint;
}

@end
