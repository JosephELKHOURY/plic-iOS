//
//  CameraViewController.m
//  Parisk
//
//  Created by SEKIMIA on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CameraViewController.h"
#import <MapKit/MapKit.h>
#import "ARKit/ContentManager.h"

@interface CameraViewController ()

@end

@implementation CameraViewController
@synthesize cameraViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor clearColor];
	// Do any additional setup after loading the view.
    /*self.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    UIImageView *anImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected.png"]];
    anImageView.frame = CGRectMake(20, 200, anImageView.image.size.width*2, anImageView.image.size.height*2);
    anImageView.hidden = YES;
    self.cameraOverlayView = anImageView;
    lblAcc = [[UILabel alloc] initWithFrame:CGRectMake(0,0,300,100)];
    [self.cameraOverlayView addSubview:lblAcc];
    lblAcc.backgroundColor = [UIColor clearColor];
    lblAcc.textColor = [UIColor whiteColor];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:anImageView
                                    repeats:YES];
    
    self.accelerometer = [UIAccelerometer sharedAccelerometer];
    self.accelerometer.updateInterval = .1;
    self.accelerometer.delegate = self;*/
    //[[ContentManager sharedContentManager] setDebugMode:NO];
    //[[ContentManager sharedContentManager] setScaleOnDistance:YES];
    
    /*ARViewController *arvc = [[ARViewController alloc] initWithDelegate:self];
    [self setCameraViewController:arvc];
    [arvc release];
    //[cameraViewController setModalTransitionStyle: UIModalTransitionStyleFlipHorizontal];
    [self presentModalViewController:cameraViewController animated:YES];
    arvc = nil;*/
}

/*-(NSMutableArray*) geoLocations {
    
    NSMutableArray *locationArray = [[[NSMutableArray alloc] init] autorelease];
    ARGeoCoordinate *tempCoordinate;
    CLLocation        *tempLocation;
    
    tempLocation = [[CLLocation alloc] initWithLatitude:48.857806 longitude:2.29463];
	tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Tour Effeil"];
	[locationArray addObject:tempCoordinate];
    
    tempLocation = [[CLLocation alloc] initWithLatitude:48.815792 longitude:2.36311];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"EPITA"];
    [locationArray addObject:tempCoordinate];
    [tempLocation release];
    
    tempLocation = [[CLLocation alloc] initWithLatitude:48.889736 longitude:2.241843];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"La Defense"];
    [locationArray addObject:tempCoordinate];
    [tempLocation release];
    
    return locationArray;
}*/


/*- (void)timerFireMethod:(NSTimer*)theTimer
{
    UIView *cameraOverlayView = (UIView *)theTimer.userInfo;
    UIView *previewView = cameraOverlayView.superview.superview;
    
    if (previewView != nil) {
        [cameraOverlayView removeFromSuperview];
        [previewView insertSubview:cameraOverlayView atIndex:1];
        
        cameraOverlayView.hidden = NO;
        
        [theTimer invalidate];
    }
}*/


- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration 
{
    NSLog(@"%@%f", @"X: ", acceleration.x);
    NSLog(@"%@%f", @"Y: ", acceleration.y);
    NSLog(@"%@%f", @"Z: ", acceleration.z);
    lblAcc.text = [NSString stringWithFormat:@"X:%f Y:%f Z:%f",acceleration.x, acceleration.y, acceleration.z];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

/*- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}*/

@end
