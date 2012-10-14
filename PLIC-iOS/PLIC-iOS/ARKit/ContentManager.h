//
//  ContentManager.h
//  ContentManager
//
//  Created by Niels Hansen on 10/9/11.
//  Copyright 2011 Agilite Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ContentManager : NSObject
{    
    UIViewController	*prevViewController;
	NSMutableArray		*controllerList;
    BOOL debugMode;
    BOOL scaleOnDistance;    
}

@property (nonatomic, strong) UIViewController  *prevViewController;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property BOOL debugMode;
@property BOOL scaleOnDistance;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+ (ContentManager *)sharedContentManager;
-(void) goBackFromView:(UIViewController*) currentViewController goBack:(int)popOff;
- (void) goToView:(UIViewController*) toViewController fromView:(UIViewController*) fromViewController;


@end
