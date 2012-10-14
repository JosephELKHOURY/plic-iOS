//
//  MyCLController.m
//  CamProject
//
//  Created by Ghady Rayess on 3/16/11.
//  Copyright 2011 FOO. All rights reserved.
//

#import "MyCLController.h"


@implementation MyCLController

@synthesize locationManager;
@synthesize delegate;


- (id) init 
{
    self = [super init];
    if (self != nil) 
	{
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self; // send loc updates to myself
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    //NSLog(@"Location: %@", [newLocation description]);
	[self.delegate locationUpdate:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error
{
	//NSLog(@"Error: %@", [error description]);
	[self.delegate locationError:error];
}

/*- (void)dealloc 
{
    [self.locationManager release];
    [super dealloc];
}*/

@end
