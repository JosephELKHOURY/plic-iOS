//
//  mapsViewController.h
//  maps
//
//  Created by Ghady Rayess on 6/28/10.
//  Copyright FOO 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import"iCodeBlogAnnotation.h"
#import"iCodeBlogAnnotationView.h"
//#import "CSMapRouteLayerView.h"
//#import "CSRouteAnnotation.h"
//#import "CSMapAnnotation.h"
//#import "CSRouteView.h"
#import "MyCLController.h"
//#import "JSON.h"
//#import "Region.h"
#import "ARKit/ARViewController.h"
#import "GameViewController.h"
#import "User.h"
#import "RestKitController.h"

@interface MapViewController : UIViewController <MyCLControllerDelegate, ARLocationDelegate, MapControllerDelegate>
{
	IBOutlet MKMapView *mapView;
	//CSMapRouteLayerView* _routeView;
	IBOutlet UITableView *tableview;
	NSString *currentLatitude;
	NSString *currentLongitude;
	NSMutableArray *pointEntries;
	NSMutableArray *instructionsEntries;
	NSMutableArray *gpsEntries;
	NSMutableDictionary* _routeViews;
	MyCLController *locationController;
    iCodeBlogAnnotation *user;
    User *restUser;
    bool found;
	//Region *region;
    int counter;
    ARViewController *cameraViewController;
    UIView *infoView;
}
@property(nonatomic)	IBOutlet MKMapView *mapView;
//property (nonatomic, retain) CSMapRouteLayerView* routeView;
@property(nonatomic)IBOutlet UITableView *tableview;
@property(nonatomic)	NSString *currentLatitude;
@property(nonatomic) NSString *currentLongitude;
@property (nonatomic) ARViewController *cameraViewController;
@property (nonatomic) UIView *infoView;
@property (strong, nonatomic) RestKitController *rest;
//@property(nonatomic,retain)	Region *region;


-(void)getRouteInformationWithSourceLatitude:(double)source_latitude SourceLongitude:(double)source_longitude 
						 DestinationLatitude:(NSString *)destination_latitude DestinationLongitude:(NSString *)destination_longitude;
//-(void)setRegion:(Region *)reg;
-(IBAction)openCamera:(id)sender;

@end

