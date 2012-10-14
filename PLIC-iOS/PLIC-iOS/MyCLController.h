//
//  MyCLController.h
//  CamProject
//
//  Created by Ghady Rayess on 3/16/11.
//  Copyright 2011 FOO. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MyCLControllerDelegate 
@required
- (void)locationUpdate:(CLLocation *)location;
- (void)locationError:(NSError *)error;
@end


@interface MyCLController : NSObject <CLLocationManagerDelegate>
{
	CLLocationManager *locationManager;
	id delegate;
}

@property (nonatomic) CLLocationManager *locationManager;  
@property (nonatomic) id  delegate;

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;

@end
