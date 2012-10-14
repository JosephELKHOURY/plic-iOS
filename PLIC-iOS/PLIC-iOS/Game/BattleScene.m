//
//  BattleScene.m
//  PLIC-iOS
//
//  Created by Leo on 10/2/12.
//
//

#import "BattleScene.h"

// HelloWorldLayer implementation
@implementation BattleScene

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	BattleScene *layer = [BattleScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        CGSize size = [[CCDirector sharedDirector] winSize];
        
		CCSprite *background;
		
        background = [CCSprite spriteWithFile:@"Background.png"];
        
		background.position = ccp(size.width/2, size.height/2);
        
        [self addChild: background];
        
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Battle!" fontName:@"Marker Felt" fontSize:32];
        
		// position the label on the center of the screen
		label.position =  ccp(size.width/2, size.height - 32);
		
		// add the label as a child to this Layer
		[self addChild: label];
        
        self.isTouchEnabled = YES;
	}
	return self;
}

-(void) startBattleWith:(Unit *)player Against:(Unit *)enemy
{
    [self setVisible:TRUE];
    [self loadPlayerUnit:player];
    [self loadEnemyUnit:enemy];
}

-(void) loadPlayerUnit:(Unit *)player
{
    CCSprite *playerSprite;
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    playerSprite = [CCSprite spriteWithFile:player.imgBigLeft];
    
    playerSprite.position = ccp(size.width - 60, size.height/2 - 30);
    
    [self addChild: playerSprite];
}

-(void) loadEnemyUnit:(Unit *)enemy
{
    CCSprite *enemySprite;
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    enemySprite = [CCSprite spriteWithFile:enemy.imgBigRight];
    
    enemySprite.position = ccp(60, size.height/2 - 30);
    
    [self addChild: enemySprite];
}

@end
