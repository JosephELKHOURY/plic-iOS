#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

#import "cocos2d.h"
#import "MapHud.h"
#import "UnitStatsLayer.h"
#import "Unit.h"
#import "Player.h"
#import "User.h"
#import "BattleScene.h"
#import "GCHelper.h"
#import "AppDelegate.h"

typedef enum {
    kGameStateWaitingForMatch = 0,
    kGameStateWaitingForRandomNumber,
    kGameStateWaitingForStart,
    kGameStateActive,
    kGameStateDone
} GameState;

typedef enum {
    kEndReasonWin,
    kEndReasonLose,
    kEndReasonDisconnect
} EndReason;

typedef enum {
    kMessageTypeRandomNumber = 0,
    kMessageTypeGameBegin,
    KMessageTypeTurn,
    kMessageTypeMove,
    kMessageTypeAddUnit,
    kMessageTypeAttack,
    kMessageTypeGameOver
} MessageType;

typedef struct {
    MessageType messageType;
} Message;

typedef struct {
    Message message;
    uint32_t randomNumber;
} MessageRandomNumber;

typedef struct {
    Message message;
} MessageGameBegin;

typedef struct {
    Message message;
    bool turnPlayer1;
} MessageTurn;

typedef struct {
    Message message;
    CGPoint from;
    CGPoint to;
} MessageMove;

typedef struct {
    Message message;
    CGPoint position;
    char type;
    int hp;
    bool forPlayer1;
} MessageAddUnit;

typedef struct {
    Message message;
    CGPoint from;
    CGPoint to;
    bool fromPlayer1;
} MessageAttack;

typedef struct {
    Message message;
    BOOL player1Won;
} MessageGameOver;

@class RestKitController;

@interface Map : CCLayer <MapDelegate, GKPeerPickerControllerDelegate, GKSessionDelegate, UIAlertViewDelegate, GCHelperDelegate>
{
    CCTMXTiledMap *_tileMap;
    CCTMXLayer *_background;
    CCTMXLayer *_foreground;
    CCTMXLayer *_meta;
    Unit *_player;
    int _numCollected;
    MapHud *_hud;
    BattleScene *_battleScene;
    User *player1;
    User *player2;
    NSMutableArray *selectedTiles;
    NSMutableArray *attackingTiles;
    NSMutableArray *potentialTiles;
    NSMutableArray *eligibleTiles;
    CCLabelTTF *attackEffect;
    CCLabelTTF *status;
    bool positioningScreen;
    
    uint32_t ourRandom;
    BOOL receivedRandom;
    NSString *otherPlayerID;
    BOOL isPlayer1;
    GameState gameState;
    CCLabelBMFont *debugLabel;
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
@property (nonatomic, retain) User *player1;
@property (nonatomic, retain) User *player2;
@property (nonatomic, retain) NSMutableArray *selectedTiles;
@property (nonatomic, retain) NSMutableArray *attackingTiles;
@property (nonatomic, retain) NSMutableArray *potentialTiles;
@property (nonatomic, retain) NSMutableArray *eligibleTiles;
@property (nonatomic, assign) BOOL turnPlayer1;
@property (nonatomic, retain) CCLabelTTF *attackEffect;
@property (nonatomic, retain) CCLabelTTF *status;

+ (id) scene:(User *)player;
- (void)setPlayerPosition:(CGPoint)position;
- (CGPoint)tileCoordForPosition:(CGPoint)position;
- (CGPoint)positionForTileCoord:(CGPoint)tileCoord;
- (void)selectTilesAroundUnit:(Unit *)unit;
- (void)selectTileAtX:(int)x AtY:(int)y Type:(NSString *)type;
- (BOOL)isUnitAtPosition:(CGPoint)touchLocation;
- (Unit *)createUnitOfType:(NSString *)type AtX:(int)x Y:(int)y forPlayer:(int)player;
- (BOOL)isEnemyAtX:(float)x AtY:(float)y;
- (NSArray *)walkableAdjacentTilesCoordForTileCoord:(CGPoint)tileCoord;
- (void)checkUnitsAvailability;

@end
