//
//  ARViewController.m
//  ARKitDemo
//
//  Modified by Niels W Hansen on 12/31/11.
//  Copyright 2011 Agilite Software. All rights reserved.
//

#import "ARViewController.h"
#import "AugmentedRealityController.h"
#import "GEOLocations.h"
#import "MarkerView.h"
#import "ContentManager.h"

@implementation ARViewController

@synthesize agController;
@synthesize delegate;

-(id)initWithDelegate:(id<ARLocationDelegate>) aDelegate {
	
	[self setDelegate:aDelegate];
	
	if (!(self = [super init]))
		return nil;
	
	[self setWantsFullScreenLayout: NO];
    
 	return self;
}

- (void)loadView {
    
	AugmentedRealityController*  arc = [[AugmentedRealityController alloc] initWithViewController:self withDelgate:self];
	
	[arc setDebugMode:NO];
	[arc setScaleViewsBasedOnDistance:YES];
	[arc setMinimumScaleFactor:0.5];
	[arc setRotateViewsBasedOnPerspective:YES];
    [arc updateDebugMode:![arc debugMode]];
    
    UIButton *closeBtn = [[UIButton alloc] init];
    UIImage *img = [UIImage imageNamed:@"button_back.png"];
    closeBtn.frame = CGRectMake(5, 5, 74, 30);
    [closeBtn setImage:img forState:UIControlStateNormal];
    
   // UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
   // closeBtn.frame = CGRectMake(5, 5, 60, 30);
    //UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    
    //[closeBtn setTitle:@"Fermer" forState:UIControlStateNormal];
    
    //[closeBtn setBackgroundColor:[UIColor greenColor]];
    [closeBtn addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:closeBtn];
    
	
	GEOLocations* locations = [[GEOLocations alloc] initWithDelegate:delegate];
	
	if ([[locations returnLocations] count] > 0) {
		for (ARGeoCoordinate *coordinate in [locations returnLocations]) {
			MarkerView *cv = [[MarkerView alloc] initForCoordinate:coordinate withDelgate:self] ;
            [coordinate setDisplayView:cv];
            
			[arc addCoordinate:coordinate];
		}
	}
    
    [self setAgController:arc];
}

- (IBAction)closeButtonClicked:(id)sender {
    [self setAgController:nil];
    [self dismissModalViewControllerAnimated:YES];
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

-(void) didTapMarker:(ARGeoCoordinate *) coordinate {
    NSLog(@"delegate worked click on %@", [coordinate title]);
    [delegate locationClicked:coordinate];
    
}

-(void) didUpdateHeading:(CLHeading *)newHeading {
    NSLog(@"Heading Updated");

}
-(void) didUpdateLocation:(CLLocation *)newLocation {
    NSLog(@"Location Updated");

}
-(void) didUpdateOrientation:(UIDeviceOrientation) orientation {
    NSLog(@"Orientation Updated");
    
    if (orientation == UIDeviceOrientationPortrait)
        NSLog(@"Protrait");

}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	agController = nil;
}



@end
