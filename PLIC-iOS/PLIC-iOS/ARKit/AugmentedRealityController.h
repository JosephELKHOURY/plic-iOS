//
//  AugmentedRealityController.h
//  AR Kit
//
//  Modified by Niels W Hansen on 12/31/11.
//  Copyright 2011 Agilite Software All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "ARViewController.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class ARCoordinate;

@interface AugmentedRealityController : NSObject <UIAccelerometerDelegate, CLLocationManagerDelegate> {

	id<ARDelegate> __weak delegate;
    
    BOOL scaleViewsBasedOnDistance;
	BOOL rotateViewsBasedOnPerspective;

	double maximumScaleDistance;
	double minimumScaleFactor;
	double maximumRotationAngle;

	ARCoordinate		*centerCoordinate;
	CLLocationManager	*locationManager;
	UIViewController	*rootViewController;
	
@private
	double	latestHeading;
	double  degreeRange;
	
	BOOL	debugMode;
   
    float	viewAngle;
	float   prevHeading;
    int     cameraOrientation;
    
	NSMutableArray	*coordinates;
    
    UILabel				*debugView;
    AVCaptureSession    *captureSession;
    AVCaptureVideoPreviewLayer *previewLayer;
    
    UIAccelerometer		*accelerometerManager;
	CLLocation			*centerLocation;
	UIView				*displayView;

}

@property BOOL scaleViewsBasedOnDistance;
@property BOOL rotateViewsBasedOnPerspective;
@property BOOL debugMode;

@property double maximumScaleDistance;
@property double minimumScaleFactor;
@property double maximumRotationAngle;

@property (nonatomic, strong) UIAccelerometer           *accelerometerManager;
@property (nonatomic, strong) CLLocationManager         *locationManager;
@property (nonatomic, strong) ARCoordinate              *centerCoordinate;
@property (nonatomic, strong) CLLocation                *centerLocation;
@property (nonatomic, strong) UIView                    *displayView;
@property (nonatomic, strong) UIView                    *cameraView;
@property (nonatomic, strong) UIViewController          *rootViewController;
@property (nonatomic, strong) AVCaptureSession          *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, weak) id<ARDelegate> delegate;


@property (strong) UILabel  *debugView;

@property (nonatomic,strong) NSMutableArray		*coordinates;

- (id)initWithViewController:(UIViewController *)theView withDelgate:(id<ARDelegate>) aDelegate;

- (void) setupDebugPostion;
- (void) updateLocations;
- (void) stopListening;

// Adding coordinates to the underlying data model.
- (void)addCoordinate:(ARGeoCoordinate *)coordinate;

// Removing coordinates
- (void)removeCoordinate:(ARGeoCoordinate *)coordinate;
- (void)removeCoordinates:(NSArray *)coordinateArray;
- (void) updateDebugMode:(BOOL) flag;


@end
