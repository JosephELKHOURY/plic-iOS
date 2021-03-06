//
//  mapsViewController.h
//  maps
//
//  Created by Ghady Rayess on 6/28/10.
//  Copyright FOO 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "ARKit/ARViewController.h"
#import "Annotation.h"
#import "AnnotationView.h"
#import "MyCLController.h"
#import "GameViewController.h"
#import "User.h"
#import "RestKitController.h"
#import "MasterViewController.h"

@protocol MasterDelegate;

@interface MapViewController : UIViewController <MyCLControllerDelegate, ARLocationDelegate, MapControllerDelegate>
{
	IBOutlet MKMapView *mapView;
	NSString *currentLatitude;
	NSString *currentLongitude;
	NSMutableArray *pointEntries;
	NSMutableArray *instructionsEntries;
	NSMutableArray *gpsEntries;
	NSMutableDictionary* _routeViews;
	MyCLController *locationController;
    Annotation *user;
    User *restUser;
    bool found;
    int counter;
    ARViewController *cameraViewController;
    UIView *infoView;
    User *player;
    id<MasterDelegate> delegate;
    NSMutableArray *locationArray;
    User *p1;
    User *p2;
}
@property(nonatomic)	IBOutlet MKMapView *mapView;
@property(nonatomic)	NSString *currentLatitude;
@property(nonatomic)    NSString *currentLongitude;
@property (nonatomic)   ARViewController *cameraViewController;
@property (nonatomic)   UIView *infoView;
@property (strong, nonatomic) RestKitController *rest;
@property (nonatomic) id<MasterDelegate> delegate;


-(IBAction)openCamera:(id)sender;

@end

