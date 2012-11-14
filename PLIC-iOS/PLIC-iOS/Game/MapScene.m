#import "MapScene.h"

typedef enum {
	kStateStartGame,
	kStatePicker,
	kStateMultiplayer,
	kStateMultiplayerCointoss,
	kStateMultiplayerReconnect
} gameStates;

@implementation Map

@synthesize tileMap = _tileMap;
@synthesize background = _background;
@synthesize foreground = _foreground;
@synthesize meta = _meta;
@synthesize player = _player;
@synthesize numCollected = _numCollected;
@synthesize hud = _hud;
@synthesize battleScene = _battleScene;
@synthesize player1, player2;
@synthesize selectedTiles, attackingTiles, potentialTiles, eligibleTiles;
@synthesize turnPlayer1;
@synthesize attackEffect;
@synthesize status;
@synthesize rest;

+(id) scene:(User *)player
{
	CCScene *scene = [CCScene node];

	Map *layer = [Map node];
	[scene addChild: layer];
    
    MapHud *hud = [MapHud node];
    [scene addChild: hud];
    layer.hud = hud;
    
    BattleScene *battleScene = [BattleScene node];
    [battleScene setVisible:FALSE];
    [scene addChild: battleScene z:50];
    layer.battleScene = battleScene;
    
    //layer.player1 = player;
    
	return scene;
}

-(void)setViewpointCenter:(CGPoint) position {
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    int x = MAX(position.x, winSize.width / 2);
    int y = MAX(position.y, winSize.height / 2);
    x = MIN(x, (_tileMap.mapSize.width * _tileMap.tileSize.width) - winSize.width / 2);
    y = MIN(y, (_tileMap.mapSize.height * _tileMap.tileSize.height) - winSize.height/2);
    CGPoint actualPosition = ccp(x, y);
    
    CGPoint centerOfView = ccp(winSize.width/2, winSize.height/2);
    CGPoint viewPoint = ccpSub(centerOfView, actualPosition);
    self.position = viewPoint;
}

- (void)highlightEligiblePositions:(NSString *)str
{
    int startX;
    int startY;
    int width;
    int height;
    CCTMXObjectGroup *objects = [_tileMap objectGroupNamed:@"PlayersPos"];
    NSAssert(objects != nil, @"'PlayersPos' object group not found");
    NSMutableDictionary *eligibles = [objects objectNamed:str];
    NSAssert(eligibles != nil, @"eligibles object not found");
    startX = [[eligibles valueForKey:@"x"] intValue];
    startY = [[eligibles valueForKey:@"y"] intValue];
    width = [[eligibles valueForKey:@"width"] intValue];
    height = [[eligibles valueForKey:@"height"] intValue];
    
    CGPoint p = ccp(startX,startY);
    p = [self tileCoordForPosition:p];
    p = [self positionForTileCoord:p];
    
    CGPoint t = ccp(width, height);
    t = [self tileCoordForPosition:t];
    t = [self positionForTileCoord:t];
    
    for (int x = p.x; x < t.x+p.x; x += _tileMap.tileSize.width)
    {
        for (int y = p.y; y < t.y+p.y; y += _tileMap.tileSize.height)
            [self setEligibleTileAtX:x AtY:y];
    }
    //
}

// on "init" you need to initialize your instance
-(id) init
{
    if( (self=[super init] )) 
    {
        //[[SimpleAudioEngine sharedEngine] preloadEffect:@"pickup.caf"];
        //[[SimpleAudioEngine sharedEngine] preloadEffect:@"hit.caf"];
        //[[SimpleAudioEngine sharedEngine] preloadEffect:@"move.caf"];
        //[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"TileMap.caf"];
        self.isTouchEnabled = YES;
        
        self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"map.tmx"];
        self.background = [_tileMap layerNamed:@"Background"];
        self.foreground = [_tileMap layerNamed:@"Foreground"];
        self.meta = [_tileMap layerNamed:@"Meta"];
        _meta.visible = NO;
        
        //player1 = [[Player alloc] createPlayer:1];
        //player2 = [[User alloc] createPlayer:2];
        //player2.Warrior = 1;
        //[player2 addUnit:[self createUnitOfType:@"Warrior" AtX:7 Y:3 forPlayer:2]];
        
        selectedTiles = [[NSMutableArray alloc] init];
        attackingTiles = [[NSMutableArray alloc] init];
        potentialTiles = [[NSMutableArray alloc] init];
        eligibleTiles = [[NSMutableArray alloc] init];
        
        //TODO: Get from server
        turnPlayer1 = TRUE;
        
        // Create a player sprite at the x,y coordinates
        self.player = [Unit spriteWithFile:@"mittouw.png"];
        //self.player = [self createUnitOfType:@"Warrior" AtX:4/_tileMap.tileSize.width Y:4/_tileMap.tileSize.height forPlayer:1];
        //[player1.units addObject:self.player];
        //[self selectTilesAroundUnit:self.player];
        
        // Center the view on the player (or as close as we can!)
        [self setViewpointCenter:_player.position];

        [self addChild:_tileMap z:-1];
        
        //status = [[CCLabelTTF alloc] initWithString:@"test" fontName:@"Arial" fontSize:16];
        //status.position = ccp(10, 10);
        //[self addChild:status];
        //////////////////////////////////////////////////////////////////
        ///This part is for enablig scrolling but still not working///
        // boundingRect is the area you wish to pan around
        /*CGRect boundingRect = CGRectMake(0, 0, 32*50, 32*50);
        
        controller = [[CCPanZoomController controllerWithNode:self] retain];
        controller.boundingRect = boundingRect;
        controller.zoomOutLimit = controller.optimalZoomOutLimit;
        controller.zoomInLimit = 2.0f;
        
        [controller enableWithTouchPriority:0 swallowsTouches:YES];*/
        ///////////////////////////////////////////////////////////////////
        positioningScreen = TRUE;
        [self.hud.status setString:@"Placez vos unités sur la carte"];
        
        AppDelegate * delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
        [[GCHelper sharedInstance] findMatchWithMinPlayers:2 maxPlayers:2 viewController:delegate.window.rootViewController delegate:self];
        
        ourRandom = arc4random();
        [self setGameState:kGameStateWaitingForMatch];
    }
    return self;
}

- (void)sendData:(NSData *)data {
    NSError *error;
    BOOL success = [[GCHelper sharedInstance].match sendDataToAllPlayers:data withDataMode:GKMatchSendDataReliable error:&error];
    if (!success) {
        CCLOG(@"Error sending init packet");
        [self matchEnded];
    }
}

- (void)sendRandomNumber {
    
    MessageRandomNumber message;
    message.message.messageType = kMessageTypeRandomNumber;
    message.randomNumber = ourRandom;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageRandomNumber)];
    [self sendData:data];
}

- (void)sendGameBegin {
    
    MessageGameBegin message;
    message.message.messageType = kMessageTypeGameBegin;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageGameBegin)];
    [self sendData:data];    
}

- (void)sendTurnPlayer1 {
    
    MessageTurn message;
    message.message.messageType = KMessageTypeTurn;
    message.turnPlayer1 = turnPlayer1;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageTurn)];
    [self sendData:data];
    
}


- (void)sendMoveFromPosition:(CGPoint)from toPosition:(CGPoint)to {
    
    MessageMove message;
    message.message.messageType = kMessageTypeMove;
    message.from = from;
    message.to = to;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageMove)];
    [self sendData:data];
}

- (void)sendAddUnitAtPosition:(CGPoint)position Type:(char)type HP:(int)hp {
    
    MessageAddUnit message;
    message.message.messageType = kMessageTypeAddUnit;
    message.position = position;
    message.type = type;
    message.hp = hp;
    message.forPlayer1 = isPlayer1;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageMove)];
    [self sendData:data];
}

- (void)sendAttack {
    
    MessageAttack message;
    message.message.messageType = kMessageTypeAttack;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageAttack)];
    [self sendData:data];
    
}

- (void)sendGameOver:(BOOL)player1Won {
    
    MessageGameOver message;
    message.message.messageType = kMessageTypeGameOver;
    message.player1Won = player1Won;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageGameOver)];
    [self sendData:data];
    
}

#pragma mark GCHelperDelegate

- (void)matchStarted
{
    CCLOG(@"Match started");
    if (receivedRandom) {
        [self setGameState:kGameStateWaitingForStart];
    } else {
        [self setGameState:kGameStateWaitingForRandomNumber];
    }
    [self sendRandomNumber];
    [self tryStartGame];
}

- (void)matchEnded
{
    CCLOG(@"Match ended");
    [[GCHelper sharedInstance].match disconnect];
    [GCHelper sharedInstance].match = nil;
    [self endScene:kEndReasonDisconnect];
}

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {
    
    // Store away other player ID for later
    if (otherPlayerID == nil) {
        otherPlayerID = playerID;
    }
    
    Message *message = (Message *) [data bytes];
    if (message->messageType == kMessageTypeRandomNumber)
    {
        
        MessageRandomNumber * messageInit = (MessageRandomNumber *) [data bytes];
        CCLOG(@"Received random number: %ud, ours %ud", messageInit->randomNumber, ourRandom);
        bool tie = false;
        
        if (messageInit->randomNumber == ourRandom) {
            CCLOG(@"TIE!");
            tie = true;
            ourRandom = arc4random();
            [self sendRandomNumber];
        } else if (ourRandom > messageInit->randomNumber) {
            CCLOG(@"We are player 1");
            isPlayer1 = YES;
        } else {
            CCLOG(@"We are player 2");
            isPlayer1 = NO;
            [self.hud showWaitTurn];
        }

        if (!tie) {
            receivedRandom = YES;
            if (gameState == kGameStateWaitingForRandomNumber) {
                [self setGameState:kGameStateWaitingForStart];
            }
            [self tryStartGame];
        }
        
    }
    else if (message->messageType == kMessageTypeGameBegin)
    {
        [self setGameState:kGameStateActive];
        [self sendTurnPlayer1];
    }
    else if (message->messageType == KMessageTypeTurn)
    {
        CCLOG(@"Received turn");
        MessageTurn * messageTurn = (MessageTurn *) [data bytes];
        turnPlayer1 = messageTurn->turnPlayer1;
        
        if (turnPlayer1 == isPlayer1)
        {
            CCLOG(@"It's our turn");
            [self startTurn];
        }
    }
    else if (message->messageType == kMessageTypeMove)
    {
        CCLOG(@"Received move");
        MessageMove * messageMove = (MessageMove *) [data bytes];
        
        if (isPlayer1)
        {
            for (Unit *unit in player2.Units)
            {
                if (CGRectContainsPoint([unit boundingBox], messageMove->from))
                {
                    [unit setPosition:messageMove->to];
                }
            }
        }
        else
        {
            for (Unit *unit in player1.Units)
            {
                if (CGRectContainsPoint([unit boundingBox], messageMove->from))
                {
                    [unit setPosition:messageMove->to];
                }
            }
        }
    }
    else if (message->messageType == kMessageTypeAddUnit)
    {
        CCLOG(@"Received add unit");
        
        MessageAddUnit * messageAddUnit= (MessageAddUnit *) [data bytes];
        int forPlayer = 0;
        
        // If the unit is added for player X and we are player X, nothing to do
        
        CCLOG(@"I am player 1? %d", isPlayer1);
        CCLOG(@"unit is for player 1? %d", messageAddUnit->forPlayer1);
        
        if (isPlayer1 != messageAddUnit->forPlayer1)
        {
            CCLOG(@"I have to add a unit that is not mine");
            if (messageAddUnit->forPlayer1)
                forPlayer = 1;
            else
                forPlayer = 2;
            
            CGPoint p = messageAddUnit->position;
            CCLOG(@"position X %f Y %f", p.x, p.y);
            
            CCLOG(@"forPlayer %d", forPlayer);
            switch (messageAddUnit->type)
            {
                case 'k':
                    [self createUnitOfType:@"Knight" AtX:p.x Y:p.y forPlayer:forPlayer];
                    break;
                case 'b':
                    [self createUnitOfType:@"Boomerang" AtX:p.x Y:p.y forPlayer:forPlayer];
                    break;
                case 'w':
                    [self createUnitOfType:@"Warrior" AtX:p.x Y:p.y forPlayer:forPlayer];
                    break;
                default:
                    break;
            }
        }
    }
    else if (message->messageType == kMessageTypeGameOver)
    {
        
        MessageGameOver * messageGameOver = (MessageGameOver *) [data bytes];
        CCLOG(@"Received game over with player 1 won: %d", messageGameOver->player1Won);
        
        if (messageGameOver->player1Won) {
            [self endScene:kEndReasonLose];
        } else {
            [self endScene:kEndReasonWin];    
        }
        
    }    
}

//////////////////////////////

- (void)setGameState:(GameState)state {
    
    gameState = state;
    if (gameState == kGameStateWaitingForMatch) {
        [debugLabel setString:@"Waiting for match"];
    } else if (gameState == kGameStateWaitingForRandomNumber) {
        [debugLabel setString:@"Waiting for rand #"];
    } else if (gameState == kGameStateWaitingForStart) {
        [debugLabel setString:@"Waiting for start"];
    } else if (gameState == kGameStateActive) {
        [debugLabel setString:@"Active"];
    } else if (gameState == kGameStateDone) {
        [debugLabel setString:@"Done"];
    }
}

// Helper code to show a menu to restart the level
- (void)endScene:(EndReason)endReason {
    
    if (gameState == kGameStateDone) return;
    [self setGameState:kGameStateDone];
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    NSString *message;
    if (endReason == kEndReasonWin) {
        message = @"You win!";
    } else if (endReason == kEndReasonLose) {
        message = @"You lose!";
    }
    
    CCLabelBMFont *label = [CCLabelBMFont labelWithString:message fntFile:@"Arial.fnt"];
    label.scale = 0.1;
    label.position = ccp(winSize.width/2, 180);
    [self addChild:label];
    
    CCLabelBMFont *restartLabel = [CCLabelBMFont labelWithString:@"Restart" fntFile:@"Arial.fnt"];
    
    CCMenuItemLabel *restartItem = [CCMenuItemLabel itemWithLabel:restartLabel target:self selector:@selector(restartTapped:)];
    restartItem.scale = 0.1;
    restartItem.position = ccp(winSize.width/2, 140);
    
    CCMenu *menu = [CCMenu menuWithItems:restartItem, nil];
    menu.position = CGPointZero;
    [self addChild:menu];
    
    [restartItem runAction:[CCScaleTo actionWithDuration:0.5 scale:1.0]];
    [label runAction:[CCScaleTo actionWithDuration:0.5 scale:1.0]];
    
    if (isPlayer1) {
        if (endReason == kEndReasonWin) {
            [self sendGameOver:true];
        } else if (endReason == kEndReasonLose) {
            [self sendGameOver:false];
        }
    }
    
}


- (void)update:(ccTime)dt
{
    if (!isPlayer1) return;
    [self setViewpointCenter:_player.position];
}

- (void)tryStartGame
{
    self.player1 = [[User alloc] createPlayer:1];
    self.player1.Warrior = 3;
    self.player1.Knight = 2;
    self.player1.Boomerang = 2;
    self.player2 = [[User alloc] createPlayer:2];
    self.player2.Warrior = 2;
    self.player2.Knight = 1;
    self.player2.Boomerang = 3;
    
    if (isPlayer1 && gameState == kGameStateWaitingForStart) {
        [self setGameState:kGameStateActive];
        [self sendGameBegin];
    }
}

- (void)checkUnitsAvailability
{
    User *currentPlayer = nil;
    
    if (isPlayer1)
    {
        CCLOG(@"checkUnitsAvailability isPlayer1");
        currentPlayer = self.player1;
    }
    else
    {
        CCLOG(@"checkUnitsAvailability isPlayer2");
        currentPlayer = self.player2;
    }
    
    CCLOG(@"checkUnitsAvailability I have %d warriors", currentPlayer.Warrior);
    
    self.hud.warriorItem.label.string = [NSString stringWithFormat:@"Warrior (%d)", currentPlayer.Warrior];
    self.hud.knightItem.label.string = [NSString stringWithFormat:@"Knight (%d)", currentPlayer.Knight];
    self.hud.boomerangItem.label.string = [NSString stringWithFormat:@"Boomerang (%d)", currentPlayer.Boomerang];
    
    self.hud.warriorItem.isEnabled = YES;
    self.hud.knightItem.isEnabled = YES;
    self.hud.boomerangItem.isEnabled = YES;
    
    if (currentPlayer.Warrior == 0)
        self.hud.warriorItem.isEnabled = NO;
    if (currentPlayer.Knight == 0)
        self.hud.knightItem.isEnabled = NO;
    if (currentPlayer.Boomerang == 0)
        self.hud.boomerangItem.isEnabled = NO;
}

-(Unit *)createUnitOfType:(NSString *)type AtX:(int)x Y:(int)y forPlayer:(int)player
{
    Unit *unit = nil;
    User *currentPlayer = nil;
    
    char t;
    
    if (player == 1)
        currentPlayer = player1;
    else if (player == 2)
        currentPlayer = player2;
    
    if (type == @"Warrior")
    {
        if (currentPlayer.Warrior == 0)
            return nil;
        
        unit = [[Warrior alloc] unitWithLayer:self player:player];
        currentPlayer.Warrior--;
        t = 'w';
    }
    else if (type == @"Knight")
    {
        if (currentPlayer.Knight == 0)
            return nil;
        
        unit = [[Knight alloc] unitWithLayer:self player:player];
        currentPlayer.Knight--;
        t = 'k';
    }
    else if (type == @"Boomerang")
    {
        if (currentPlayer.Boomerang == 0)
            return nil;

        unit = [[Boomerang alloc] unitWithLayer:self player:player];
        currentPlayer.Boomerang--;
        t = 'b';
    }
    
    CGPoint p = ccp(x,y);
    unit.position = [self positionForTileCoord:p];
    [self addChild:unit];
    
    [currentPlayer addUnit:unit];
    
    [self checkUnitsAvailability];
    
    // Send message for the other player
    [self sendAddUnitAtPosition:p Type:t HP:unit.hp];
    
    return unit;
}

-(Unit *)createUnitOfType:(NSString *)type AtPosition:(CGPoint)p forPlayer:(int)player
{
    return [self createUnitOfType:type AtX:p.x Y:p.y forPlayer:player];
}

-(Unit *)createUnitForCurrentPlayerOfType:(NSString *)type AtPosition:(CGPoint)p
{
    int player = 2;
    if (isPlayer1) {
        player = 1;
    }
    return [self createUnitOfType:type AtX:p.x Y:p.y forPlayer:player];
}

- (CGPoint)tileCoordForPosition:(CGPoint)position {
    int x = position.x / _tileMap.tileSize.width;
    int y = ((_tileMap.mapSize.height * _tileMap.tileSize.height) - position.y) / _tileMap.tileSize.height;
    return ccp(x, y);
}

- (CGPoint)positionForTileCoord:(CGPoint)tileCoord {
    int x = (tileCoord.x * _tileMap.tileSize.width) + _tileMap.tileSize.width/2;
    int y = (_tileMap.mapSize.height * _tileMap.tileSize.height) - (tileCoord.y * _tileMap.tileSize.height) - _tileMap.tileSize.height/2;
    return ccp(x, y);
}


- (void)registerWithTouchDispatcher
{
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    [self.hud setDelegate:self];
}

- (void)selectAttackingTilesAroundUnit:(Unit *)unit

{
    CGPoint playerPos = unit.position;
    
    int distX = 0;
    
    for (int x = playerPos.x; x < _tileMap.mapSize.width * _tileMap.tileSize.width && x <= playerPos.x + unit.distance * _tileMap.tileSize.width; x += _tileMap.tileSize.width,
         distX++) 
    {
        for (int y = playerPos.y, distY = 0; y <= _tileMap.mapSize.height * _tileMap.tileSize.height && y <= playerPos.y + unit.distance * _tileMap.tileSize.height && distX + distY <= unit.distance; y += _tileMap.tileSize.height, distY++) 
        {
            [self selectAttackingTileAtX:x AtY:y];
        }
        for (int y = playerPos.y, distY = 0; y > 0 && y >= playerPos.y - unit.distance * _tileMap.tileSize.height && distX + distY <= unit.distance; y -= _tileMap.tileSize.height, distY++) 
        {
            [self selectAttackingTileAtX:x AtY:y];
        }
        
    }
    for (int x = playerPos.x, distX = 0; x > 0 && x >= playerPos.x - unit.distance * _tileMap.tileSize.width; x -= _tileMap.tileSize.width,
         distX++) 
    {
        for (int y = playerPos.y, distY = 0; y <= _tileMap.mapSize.height * _tileMap.tileSize.height && y <= playerPos.y + unit.distance * _tileMap.tileSize.height && distX + distY <= unit.distance; y += _tileMap.tileSize.height, distY++) 
        {
            [self selectAttackingTileAtX:x AtY:y];
        }
        for (int y = playerPos.y, distY = 0; y > 0 && y >= playerPos.y - unit.distance * _tileMap.tileSize.height && distX + distY <= unit.distance; y -= _tileMap.tileSize.height, distY++) 
        {
            [self selectAttackingTileAtX:x AtY:y];
        }
    }
}

-(void)selectAttackingTileAtX:(float)x AtY:(float) y
{
    CCSprite *sprite = nil;
    CGPoint selectPos;
    selectPos.x = x;
    selectPos.y = y;
    
    [self deselectAllTiles:selectedTiles];
    
    if ([self isEnemyAtX:x AtY:y])
    {
        if (![self isSpriteInArray:attackingTiles atPos:selectPos])
        {
            sprite = [CCSprite spriteWithFile:@"attack.png"];
            sprite.position = selectPos;
        
            [self addChild:sprite];
            
            [self reorderChild:sprite z:-1];
            [attackingTiles addObject:sprite];
        }
    }
    else 
    { 
        if (![self isSpriteInArray:potentialTiles atPos:selectPos])
        {
            sprite = [CCSprite spriteWithFile:@"potential.png"];
            sprite.position = selectPos;
            
            [self addChild:sprite];
            
            [self reorderChild:sprite z:-1];
            [potentialTiles addObject:sprite];
        }
    }
}

-(void)selectTilesAroundUnit:(Unit *)unit
{
    [self deselectAllTiles:selectedTiles];
    CGPoint playerPos = unit.position;
    CGPoint p;
    
    for (int x = playerPos.x; x < _tileMap.mapSize.width * _tileMap.tileSize.width && x <= playerPos.x + unit.moves * _tileMap.tileSize.width; x += _tileMap.tileSize.width) 
    {
        for (int y = playerPos.y; y <= _tileMap.mapSize.height * _tileMap.tileSize.height && y <= playerPos.y + unit.moves * _tileMap.tileSize.height; y += _tileMap.tileSize.height) 
        {
            p = CGPointMake(x, y);
            [unit moveToward:p];
            if (unit.shortestPath != nil)
                [self selectTileAtX:x AtY:y];
            unit.shortestPath = nil;
        }
        for (int y = playerPos.y; y > 0 && y >= playerPos.y - unit.moves * _tileMap.tileSize.height; y -= _tileMap.tileSize.height) 
        {
            p = CGPointMake(x, y);
            [unit moveToward:p];
            if (unit.shortestPath != nil)
                [self selectTileAtX:x AtY:y];
            unit.shortestPath = nil;
        }
    }
    
    for (int x = playerPos.x; x > 0 && x >= playerPos.x - unit.moves * _tileMap.tileSize.width; x -= _tileMap.tileSize.width) 
    {
        for (int y = playerPos.y; y < _tileMap.mapSize.height * _tileMap.tileSize.height && y <= playerPos.y + unit.moves * _tileMap.tileSize.height; y += _tileMap.tileSize.height) 
        {
            p = CGPointMake(x, y);
            [unit moveToward:p];
            if (unit.shortestPath != nil)
                [self selectTileAtX:x AtY:y];
            unit.shortestPath = nil;
        }
        for (int y = playerPos.y; y > 0 && y >= playerPos.y - unit.moves * _tileMap.tileSize.height; y -= _tileMap.tileSize.height) 
        {
            p = CGPointMake(x, y);
            [unit moveToward:p];
            if (unit.shortestPath != nil)
                [self selectTileAtX:x AtY:y];
            unit.shortestPath = nil;
        }
    }
    self.player.state = SELECTED;
}

-(BOOL)isEnemyAtX:(float)x AtY:(float)y
{
    CGPoint point = CGPointMake(x, y);
    
    if (turnPlayer1 == TRUE)
    {
        for (Unit *unit in player2.Units)
        {
            if (CGRectContainsPoint([unit boundingBox], point)) 
            {
                return TRUE;
            }
            return FALSE;
        }
    }
    return FALSE;
}

-(void)selectTileAtX:(int)x AtY:(int)y
{
    CCSprite *sprite = nil;
    sprite = [CCSprite spriteWithFile:@"selected.png"];
    
    CGPoint selectPos;
    selectPos.x = x;
    selectPos.y = y;
    
    if (![self isSpriteInArray:selectedTiles atPos:selectPos] && ![self isUnitAtPosition:selectPos])
    {
        sprite.position = selectPos;
        [self addChild:sprite];
        [self reorderChild:_player z:2];
        [selectedTiles addObject:sprite];
    }
}

-(void)setEligibleTileAtX:(int)x AtY:(int)y
{
    CCSprite *sprite = nil;
    sprite = [CCSprite spriteWithFile:@"eligible.png"];
    
    CGPoint selectPos;
    selectPos.x = x;
    selectPos.y = y;
    
    if (![self isUnitAtPosition:selectPos])
    {
        sprite.position = selectPos;
        [self addChild:sprite];
        [self reorderChild:_player z:2];
        [eligibleTiles addObject:sprite];
    }
}

-(void)deselectAllTiles:(NSMutableArray *)array
{
    for (CCSprite *tile in array)
    {
        [self removeChild:tile cleanup:YES];
    }
    [array removeAllObjects];
}

-(void)deselectEligibleTiles
{
    for (CCSprite *tile in eligibleTiles)
    {
        [self removeChild:tile cleanup:YES];
    }
    [eligibleTiles removeAllObjects];
}

-(void)deselectEligibleTileAtPosition:(CGPoint)pos
{
    pos = [self positionForTileCoord:pos];
    
    for (CCSprite *tile in eligibleTiles)
    {
        if (CGRectContainsPoint([tile boundingBox], pos))
        {
            [self removeChild:tile cleanup:YES];
            [eligibleTiles removeObject:tile];
            return;
        }
    }
}

-(BOOL) isSpriteInArray:(NSMutableArray *)array atPos:(CGPoint)position
{
    for (CCSprite *tile in array)
        if (CGPointEqualToPoint(tile.position,position)) 
            return TRUE;
    return FALSE;
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

-(void)setPlayerPosition:(CGPoint)position 
{
    //[[SimpleAudioEngine sharedEngine] playEffect:@"move.caf"];
    [_player moveToward:position];
    [_player popStepAndAnimate];
    
    _player.state = HASMOVED;
}

- (BOOL)isUnitAtPosition:(CGPoint)touchLocation
{
    for (Unit *unit in player1.Units)
    {
        if (CGRectContainsPoint([unit boundingBox], touchLocation)) 
        {
            return YES;
        }
    }
    for (Unit *unit in player2.Units)
    {
        if (CGRectContainsPoint([unit boundingBox], touchLocation)) 
        {
            return YES;
        }
    }
    return NO;
}

-(NSMutableArray *) getCurrentPlayerUnitList
{
    return player1.Units;
}

-(void) attackWith:(Unit *)player Against:(Unit *)enemy
{
    //BATTLE SCENE
    //[self.battleScene startBattleWith:player Against:enemy];
    //return;
    
    enemy.hp -= player.attack;
    player.state = HASATTACKED;
    attackEffect = [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"-%d", player.attack] fontName:@"Arial" fontSize:16];
    attackEffect.position = ccp(enemy.position.x,enemy.position.y + 25);
    [self addChild:attackEffect];
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(removeAttackEffect:) userInfo:nil repeats:NO];
    
    if (enemy.hp < 0)
    {
        [self removeChild:enemy cleanup:TRUE];
        [player2.Units removeObject:enemy];
    }
    
    if ([player2.Units count] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Victoire!" message:@"Vous avez gagné!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }

}

-(void)removeAttackEffect:(NSTimer *)timer
{
    [self removeChild:attackEffect cleanup:YES];
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInView: [touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];

    [self deselectAllTiles:potentialTiles];
    
    if (positioningScreen)
    {
        if (turnPlayer1 == isPlayer1)
        {
            self.hud.unitMenu.visible = NO;
            for (CCSprite *tile in eligibleTiles)
            {
                if (CGRectContainsPoint([tile boundingBox], touchLocation))
                {
                    CGPoint p = [self tileCoordForPosition:touchLocation];
                    [self checkUnitsAvailability];
                    [self.hud showUnitMenuWithPosition:p];
                    //CGPoint t = [self positionForTileCoord:p];
                    //[self setEligibleTileAtX:t.x AtY:t.y];
                    return;
                }
            }
            [self setViewpointCenter:touchLocation];
            return;
        }
        else
            return;
    }
    
    if (turnPlayer1)
    {
        if (self.battleScene.visible = YES)
            self.battleScene.visible = NO;
        for (Unit *unit in player1.Units)
        {
            if (CGRectContainsPoint([unit boundingBox], touchLocation)) 
            {
                self.player = unit;
                [self.hud showUnitStats:unit];
                [self setViewpointCenter:_player.position];
                if (self.player.state == IDLE)
                {
                    [self selectTilesAroundUnit:self.player];
                    return;
                }
                else if (self.player.state == HASMOVED || self.player.state == SELECTED)
                {
                    [self selectAttackingTilesAroundUnit:self.player];
                    return;
                }
                else
                {
                    [self.hud.status setString:@"L'unité ne peut plus effectuer d'action!"];
                    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(removeStatus:) userInfo:nil repeats:NO];
                    return;
                }
            }
        }
        
        for (Unit *unit in player2.Units)
        {
            if (CGRectContainsPoint([unit boundingBox], touchLocation)) 
            {
                [self.hud showUnitStats:unit];
                if (self.player != nil && self.player.state != HASATTACKED)
                {
                    if ([self isSpriteInArray:attackingTiles atPos:unit.position])
                    {
                        [self attackWith:self.player Against:unit];
                        [self deselectAllTiles:attackingTiles];
                    }
                    return;
                }
                else
                {
                    [self.hud.status setString:@"L'unité a déjà été attaquée!"];
                    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(removeStatus:) userInfo:nil repeats:NO];
                }
            }
        }
        for (CCSprite *tile in selectedTiles)
        {
            if (CGRectContainsPoint([tile boundingBox], touchLocation))
            {
                if (gameState != kGameStateActive) return;
                [self sendMoveFromPosition:self.player.position toPosition:touchLocation];
                [self setPlayerPosition:touchLocation];
                [self setViewpointCenter:_player.position];
                [self deselectAllTiles:selectedTiles];
                [self.hud hideUnitStats];
                return;
            }
        }
        [self deselectAllTiles:attackingTiles];
        [self.hud hideUnitStats];
    }
    [self setViewpointCenter:touchLocation];
    
    //[self.hud.status setString:@"Vous avez gagné"];
}

- (void)removeStatus:(NSTimer *)timer
{
    [self.hud.status setString:@""];
}

-(void)startTurn
{
    
    // Setup timer to end our turn after 30 seconds
    
    // TODO change timer to cocos2d scheduler
    // http://www.cocos2d-iphone.org/wiki/doku.php/prog_guide:best_practices
    [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(endTurn) userInfo:nil repeats:NO];
    
    if (positioningScreen)
    {
        if (isPlayer1)
        {
            [self highlightEligiblePositions:@"Player1Eligible1"];
            [self highlightEligiblePositions:@"Player1Eligible2"];
            [self highlightEligiblePositions:@"Player1Eligible3"];
        }
        else
        {
            [self highlightEligiblePositions:@"Player2Eligible1"];
            [self highlightEligiblePositions:@"Player2Eligible2"];
            [self highlightEligiblePositions:@"Player2Eligible3"];
        }
    }
    
    // Allow player to end his turn early
    [self.hud showEndTurn];
}

-(void)endTurn
{
    // If it's currently our turn, end it, else don't do anything
    if (turnPlayer1 == isPlayer1)
    {
        [self.hud showWaitTurn];
        
        [self deselectAllTiles:selectedTiles];
        [self deselectAllTiles:attackingTiles];
        [self deselectAllTiles:potentialTiles];
        
        // Reset unit moves
        for (Unit *unit in player1.Units)
        {
            [unit setDefaults];
        }
        
        if (positioningScreen)
        {
            positioningScreen = FALSE;
            [self deselectEligibleTiles];
        }
        
        [self removeStatus:nil];
    
        // Toggle turn
        turnPlayer1 = !turnPlayer1;
    
        [self sendTurnPlayer1];
    }
}

- (BOOL)isValidTileCoord:(CGPoint)tileCoord {
    if (tileCoord.x < 0 || tileCoord.y < 0 || 
        tileCoord.x >= _tileMap.mapSize.width ||
        tileCoord.y >= _tileMap.mapSize.height) {
        return FALSE;
    } else {
        return TRUE;
    }
}

- (NSArray *)walkableAdjacentTilesCoordForTileCoord:(CGPoint)tileCoord
{
	NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:4];
    
	// Top
	CGPoint p = CGPointMake(tileCoord.x, tileCoord.y - 1);
	if ([self isValidTileCoord:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
	}
    
	// Left
	p = CGPointMake(tileCoord.x - 1, tileCoord.y);
	if ([self isValidTileCoord:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
	}
    
	// Bottom
	p = CGPointMake(tileCoord.x, tileCoord.y + 1);
	if ([self isValidTileCoord:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
	}
    
	// Right
	p = CGPointMake(tileCoord.x + 1, tileCoord.y);
	if ([self isValidTileCoord:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
	}
    
	return [NSArray arrayWithArray:tmp];
}


@end
