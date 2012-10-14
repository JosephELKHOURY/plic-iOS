//
//  BattleScene.h
//  PLIC-iOS
//
//  Created by Leo on 10/2/12.
//
//

#import "cocos2d.h"
#import "Unit.h"

@interface BattleScene : CCLayer
{
}

+(CCScene *) scene;
-(void) startBattleWith:(Unit *)player Against:(Unit *)enemy;

@end
