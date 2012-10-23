//
//  RestKitController.m
//  PLIC-iOS
//
//  Created by SEKIMIA on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RestKitController.h"

@implementation RestKitController
@synthesize data, bonuses, armies;
@synthesize mapDelegate, masterDelegate;

static RestKitController* singleton = nil;

+ (RestKitController*)getInstance
{
    if (singleton == nil) {
        singleton = [[RestKitController alloc] init];
    }
    return singleton;
}

- (void)setupMappingAndRoutes
{
    RKObjectManager *manager = [RKObjectManager objectManagerWithBaseURL:[RKURL URLWithBaseURLString:@"http://10.41.163.35:1054/api"]]; 
    
    /*RKObjectMapping* userMapping = [RKObjectMapping mappingForClass:[User class]];
    [userMapping mapKeyPath:@"UUID" toAttribute:@"UUID"];
    [userMapping mapKeyPath:@"description" toAttribute:@"description"];
    [userMapping mapKeyPath:@"username" toAttribute:@"username"];
    [userMapping mapKeyPath:@"id" toAttribute:@"id"];
    [userMapping mapKeyPath:@"latitude" toAttribute:@"latitude"];
    [userMapping mapKeyPath:@"longitude" toAttribute:@"longitude"];*/
    
    /*RKObjectMapping* bonusMapping = [RKObjectMapping mappingForClass:[Bonus class]];
    [bonusMapping mapKeyPath:@"description" toAttribute:@"description"];
    [bonusMapping mapKeyPath:@"id" toAttribute:@"id"];
    [bonusMapping mapKeyPath:@"latitude" toAttribute:@"latitude"];
    [bonusMapping mapKeyPath:@"longitude" toAttribute:@"longitude"];*/
    
    RKObjectMapping* armyMapping = [RKObjectMapping mappingForClass:[Player class]];
    [armyMapping mapKeyPath:@"Warrior" toAttribute:@"Warrior"];
    [armyMapping mapKeyPath:@"Knight" toAttribute:@"Knight"];
    [armyMapping mapKeyPath:@"Boomerang" toAttribute:@"Boomerang"];
    [armyMapping mapKeyPath:@"ArmyId" toAttribute:@"ArmyId"];

    
    //[[RKObjectManager sharedManager].mappingProvider setMapping:userMapping forKeyPath:@""];
    //[[RKObjectManager sharedManager].mappingProvider setMapping:bonusMapping forKeyPath:@""];
    [[RKObjectManager sharedManager].mappingProvider setMapping:armyMapping forKeyPath:@""];
    
    manager.serializationMIMEType = RKMIMETypeJSON;
    
    //[[RKObjectManager sharedManager].mappingProvider setSerializationMapping:userMapping forClass:[User class]];
    //[[RKObjectManager sharedManager].mappingProvider setSerializationMapping:bonusMapping forClass:[Bonus class]];
    [[RKObjectManager sharedManager].mappingProvider setSerializationMapping:armyMapping forClass:[Player class]];
    
    RKObjectRouter *router = [RKObjectRouter new];
    // Define a default resource path for all unspecified HTTP verbs  
    //[router routeClass:[User class] toResourcePath:@"/users/" forMethod:RKRequestMethodPOST];
    //[router routeClass:[User class] toResourcePath:@"/users" forMethod:RKRequestMethodGET];
    //[router routeClass:[User class] toResourcePath:@"/users/:id" forMethod:RKRequestMethodPUT];
    //[router routeClass:[User class] toResourcePath:@"/users/:id" forMethod:RKRequestMethodDELETE];
    //[router routeClass:[Bonus class] toResourcePath:@"/bonuses/" forMethod:RKRequestMethodPOST];
    //[router routeClass:[Bonus class] toResourcePath:@"/bonuses" forMethod:RKRequestMethodGET];
    //[router routeClass:[Bonus class] toResourcePath:@"/bonuses/:id" forMethod:RKRequestMethodPUT];
    //[router routeClass:[Player class] toResourcePath:@"/armies/" forMethod:RKRequestMethodPOST];
    [router routeClass:[Player class] toResourcePath:@"/armies" forMethod:RKRequestMethodGET];
    //[router routeClass:[Player class] toResourcePath:@"/armies/:id" forMethod:RKRequestMethodPUT];

    [RKObjectManager sharedManager].router = router;
}

- (void)getUsers
{
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/users" delegate:self];
}

- (void)getBonuses
{
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/bonuses" delegate:self];
}

- (void)getArmies
{
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/armies" delegate:self];
}

- (void)getArmiesOfPlayer:(int)playerId
{
    NSString *str = [NSString stringWithFormat:@"/armies/%d", playerId];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:str delegate:self];
}



- (void)createUser:(NSObject *)user
{
    RKObjectRouter *router = [RKObjectRouter new];
    [router routeClass:[User class] toResourcePath:@"/users/" forMethod:RKRequestMethodPOST];
    [[RKObjectManager sharedManager] postObject:user delegate:self]; 
    [RKObjectManager sharedManager].router = router;
}

- (void)markBonusAsTaken:(NSObject *)bonus
{
    //TODO
}

- (void)updateUser:(NSObject *)user
{
    RKObjectRouter *router = [RKObjectRouter new];
    [router routeClass:[User class] toResourcePath:@"/users/:id" forMethod:RKRequestMethodPOST];
    [[RKObjectManager sharedManager] postObject:user delegate:self]; 
    [RKObjectManager sharedManager].router = router;
}

- (void)deleteUser:(NSObject *)user
{
    [[RKObjectManager sharedManager] putObject:user delegate:self];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", [error localizedDescription]);
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response 
{
    NSLog(@"response code: %d", [response statusCode]);
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    if ([objectLoader wasSentToResourcePath:@"/users"]) 
    {
        NSLog(@"objects[%d]", [objects count]);
        data = [NSMutableArray arrayWithArray:objects];
        [mapDelegate addUsers];
    }
    else if ([objectLoader wasSentToResourcePath:@"/bonuses"])
    {
        NSLog(@"objects[%d]", [objects count]);
        bonuses = [NSMutableArray arrayWithArray:objects];
        [mapDelegate addBonuses];
    }
    else if ([objectLoader wasSentToResourcePath:@"/armies"] || [objectLoader wasSentToResourcePath:@"/armies/1"])
    {
        NSLog(@"objects[%d]", [objects count]);
        NSLog(@"%@", objects);
        armies = [NSMutableArray arrayWithArray:objects];
        [masterDelegate setPlayer];
    }
}

@end
