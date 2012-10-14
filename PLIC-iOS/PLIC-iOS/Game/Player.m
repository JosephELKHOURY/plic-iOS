#import "Player.h"
#import "MapScene.h"

@implementation Player

@synthesize units;
@synthesize id, ArmyId, Warrior, Knight, Boomerang, rest;

- (id)createPlayer:(int)playerId
{
    self.units = [[NSMutableArray alloc] init];

    return self;
}


- (void)addUnit:(Unit *)unit
{
    if (unit != nil)
        [units addObject:unit];
}

@end
