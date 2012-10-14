#import "cocos2d.h"
#import "MapHud.h"
#import "UnitStatsLayer.h"
#import "Unit.h"
#import "Player.h"
#import "BattleScene.h"

@class RestKitController;

@interface Map : CCLayer <MapDelegate>
{
    CCTMXTiledMap *_tileMap;
    CCTMXLayer *_background;
    CCTMXLayer *_foreground;
    CCTMXLayer *_meta;
    Unit *_player;
    int _numCollected;
    MapHud *_hud;
    BattleScene *_battleScene;
    Player *player1;
    Player *player2;
    NSMutableArray *selectedTiles;
    NSMutableArray *attackingTiles;
    NSMutableArray *potentialTiles;
    NSMutableArray *eligibleTiles;
    CCLabelTTF *attackEffect;
    CCLabelTTF *status;
    bool positioningScreen;
}

@property (strong, nonatomic) RestKitController *rest;
@property (nonatomic, retain) CCTMXTiledMap *tileMap;
@property (nonatomic, retain) CCTMXLayer *background;
@property (nonatomic, retain) CCTMXLayer *foreground;
@property (nonatomic, retain) CCTMXLayer *meta;
@property (nonatomic, retain) Unit *player;
@property (nonatomic, assign) int numCollected;
@property (nonatomic, retain) MapHud *hud;
@property (nonatomic, retain) BattleScene *battleScene;
@property (nonatomic, retain) Player *player1;
@property (nonatomic, retain) Player *player2;
@property (nonatomic, retain) NSMutableArray *selectedTiles;
@property (nonatomic, retain) NSMutableArray *attackingTiles;
@property (nonatomic, retain) NSMutableArray *potentialTiles;
@property (nonatomic, retain) NSMutableArray *eligibleTiles;
@property (nonatomic, assign) BOOL turn;
@property (nonatomic, retain) CCLabelTTF *attackEffect;
@property (nonatomic, retain) CCLabelTTF *status;

+ (id) scene:(Player *)player;
- (void)setPlayerPosition:(CGPoint)position;
- (CGPoint)tileCoordForPosition:(CGPoint)position;
- (CGPoint)positionForTileCoord:(CGPoint)tileCoord;
- (void)selectTilesAroundUnit:(Unit *)unit;
- (void)selectTileAtX:(int)x AtY:(int)y Type:(NSString *)type;
- (BOOL)isUnitAtPosition:(CGPoint)touchLocation;
- (Unit *)createUnitOfType:(NSString *)type AtX:(int)x Y:(int)y forPlayer:(int)player;
- (BOOL)isEnemyAtX:(float)x AtY:(float)y;
- (NSArray *)walkableAdjacentTilesCoordForTileCoord:(CGPoint)tileCoord;

@end
