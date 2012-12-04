//
//  RestKitController.m
//  PLIC-iOS
//
//  Created by SEKIMIA on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RestKitController.h"

@implementation RestKitController
@synthesize users, bonuses, units, userInfo;
@synthesize mapDelegate, masterDelegate;
@synthesize fromMaster;

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
    RKObjectManager *manager = [RKObjectManager objectManagerWithBaseURL:[RKURL URLWithBaseURLString:@"http://192.168.0.27:1054/api"]];
    
    /*RKObjectMapping* unitMapping = [RKObjectMapping mappingForClass:[Unit class]];
    [unitMapping mapKeyPath:@"Type" toAttribute:@"name"];
    [unitMapping mapKeyPath:@"CurrentHP" toAttribute:@"hp"];
    [unitMapping mapKeyPath:@"TotalHP" toAttribute:@"totalHp"];*/
    
    userMapping = [RKObjectMapping mappingForClass:[User class]];
    userMapping.setDefaultValueForMissingAttributes = YES;
    userMapping.setNilForMissingRelationships = YES;
    [userMapping mapKeyPath:@"UserId" toAttribute:@"UserId"];
    [userMapping mapKeyPath:@"UUID" toAttribute:@"UUID"];
    [userMapping mapKeyPath:@"Description" toAttribute:@"Description"];
    [userMapping mapKeyPath:@"Username" toAttribute:@"Username"];
    [userMapping mapKeyPath:@"Latitude" toAttribute:@"Latitude"];
    [userMapping mapKeyPath:@"Longitude" toAttribute:@"Longitude"];
    [userMapping mapKeyPath:@"Warrior" toAttribute:@"Warrior"];
    [userMapping mapKeyPath:@"Knight" toAttribute:@"Knight"];
    [userMapping mapKeyPath:@"Boomerang" toAttribute:@"Boomerang"];
    //[userMapping mapKeyPath:@"Units" toRelationship:@"Units" withMapping:unitMapping];
    [[RKObjectManager sharedManager].mappingProvider setSerializationMapping:userMapping forClass:[User class]];
    
    bonusMapping = [RKObjectMapping mappingForClass:[Bonus class]];
    bonusMapping.setDefaultValueForMissingAttributes = YES;
    bonusMapping.setNilForMissingRelationships = YES;
    [bonusMapping mapKeyPath:@"BonusId" toAttribute:@"BonusId"];
    [bonusMapping mapKeyPath:@"Description" toAttribute:@"Description"];
    [bonusMapping mapKeyPath:@"Yype" toAttribute:@"Type"];
    [bonusMapping mapKeyPath:@"Latitude" toAttribute:@"Latitude"];
    [bonusMapping mapKeyPath:@"Longitude" toAttribute:@"Longitude"];
    [[RKObjectManager sharedManager].mappingProvider setSerializationMapping:bonusMapping forClass:[Bonus class]];
    
    manager.serializationMIMEType = RKMIMETypeJSON;
    manager.acceptMIMEType = RKMIMETypeJSON;
    
    RKObjectRouter *router = [RKObjectRouter new];
    // Define a default resource path for all unspecified HTTP verbs  
    [router routeClass:[User class] toResourcePath:@"/user/" forMethod:RKRequestMethodPOST];
    [router routeClass:[User class] toResourcePath:@"/user/:uuid" forMethod:RKRequestMethodGET];
    [router routeClass:[User class] toResourcePath:@"/user/:UserId" forMethod:RKRequestMethodPUT];
    [router routeClass:[User class] toResourcePath:@"/user/:uuid" forMethod:RKRequestMethodDELETE];
    [router routeClass:[Bonus class] toResourcePath:@"/bonus/" forMethod:RKRequestMethodPOST];
    [router routeClass:[Bonus class] toResourcePath:@"/bonus" forMethod:RKRequestMethodGET];
    [router routeClass:[Bonus class] toResourcePath:@"/bonus/:id" forMethod:RKRequestMethodPUT];

    [RKObjectManager sharedManager].router = router;
}

- (void)getUsers
{
    [[RKObjectManager sharedManager].mappingProvider setMapping:userMapping forKeyPath:@""];
    [[RKObjectManager sharedManager].mappingProvider setMapping:userMapping forKeyPath:@"User"];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/user" delegate:self];
}

- (void)getBonuses
{
    [[RKObjectManager sharedManager].mappingProvider setMapping:bonusMapping forKeyPath:@""];
    [[RKObjectManager sharedManager].mappingProvider setMapping:bonusMapping forKeyPath:@"Bonus"];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/bonus" delegate:self];
}

- (void)getUser:(NSString *)uuid
{
    NSLog(@"Getting user with uuid %@", uuid);
    [[RKObjectManager sharedManager].mappingProvider setMapping:userMapping forKeyPath:@""];
    [[RKObjectManager sharedManager].mappingProvider setMapping:userMapping forKeyPath:@"User"];
    NSString *str = [NSString stringWithFormat:@"/user/%@", uuid];
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:str delegate:self];
    currentUUID = uuid;
}

- (void)createUser:(NSObject *)user
{
    [[RKObjectManager sharedManager].mappingProvider setMapping:userMapping forKeyPath:@""];
    [[RKObjectManager sharedManager].mappingProvider setMapping:userMapping forKeyPath:@"User"];
    RKObjectRouter *router = [RKObjectRouter new];
    [router routeClass:[User class] toResourcePath:@"/user/" forMethod:RKRequestMethodPOST];
    [[RKObjectManager sharedManager] postObject:user delegate:self]; 
    [RKObjectManager sharedManager].router = router;
}

- (void)updateUser:(NSObject *)user
{
    [[RKObjectManager sharedManager].mappingProvider setMapping:userMapping forKeyPath:@""];
    [[RKObjectManager sharedManager].mappingProvider setMapping:userMapping forKeyPath:@"User"];
    RKObjectRouter *router = [RKObjectRouter new];
    [router routeClass:[User class] toResourcePath:@"/user/:UserId" forMethod:RKRequestMethodPUT];
    [[RKObjectManager sharedManager] putObject:user delegate:self];
    [RKObjectManager sharedManager].router = router;
}

- (void)deleteUser:(NSObject *)user
{
    [[RKObjectManager sharedManager].mappingProvider setMapping:userMapping forKeyPath:@""];
    [[RKObjectManager sharedManager].mappingProvider setMapping:userMapping forKeyPath:@"User"];
    [[RKObjectManager sharedManager] putObject:user delegate:self];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", [error localizedDescription]);       
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response 
{
    NSLog(@"response code: %d", [response statusCode]);
    NSLog(@"response type: %@", [response contentType]);
    NSLog(@"response: %@", [response bodyAsString]);
    if ([response statusCode] == 500)
        [masterDelegate pushToRegister];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    NSLog(@"objects[%d]", [objects count]);

    if ([objectLoader wasSentToResourcePath:@"/user/" method:RKRequestMethodPOST])
    {
        [masterDelegate getPlayerFromServer];
    }
    else if ([objectLoader wasSentToResourcePath:@"/user"])
    {
        NSLog(@"users[%d]", [objects count]);
        users = [NSMutableArray arrayWithArray:objects];
        [mapDelegate addUsers];
    }
    else if ([objectLoader wasSentToResourcePath:@"/bonus"])
    {
        NSLog(@"bonuses[%d]", [objects count]);
        bonuses = [NSMutableArray arrayWithArray:objects];
        [mapDelegate addBonuses];
    }
    else if ([objectLoader wasSentToResourcePath:[NSString stringWithFormat:@"/user/%@", currentUUID]])
    {
        NSLog(@"user[%d]", [objects count]);
        NSLog(@"%@", objects);
        userInfo = [NSMutableArray arrayWithArray:objects];
        [masterDelegate setPlayer];
    }
}

@end
