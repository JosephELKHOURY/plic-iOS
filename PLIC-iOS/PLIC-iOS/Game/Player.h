
@class Map;
@class Unit;
@class RestKitController;

@interface Player : NSObject
{
    NSMutableArray *units;
    int id;
    int Warrior;
    int Knight;
    int Boomerang;
    int ArmyId;
}

@property (strong, nonatomic) NSMutableArray *units;
@property (nonatomic, assign) int id;
@property (nonatomic, assign) int Warrior;
@property (nonatomic, assign) int Knight;
@property (nonatomic, assign) int Boomerang;
@property (nonatomic, assign) int ArmyId;
@property (strong, nonatomic) RestKitController *rest;

- (id)createPlayer:(int)playerId;
- (void)addUnit:(Unit *)unit;

@end