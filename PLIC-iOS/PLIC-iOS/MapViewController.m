//
//  mapsViewController.m
//  maps
//
//  Created by Joseph ELKHOURY on 6/28/11.
//  Copyright H.J ELKHOURY 2011. All rights reserved.
//

#import "MapViewController.h"
#import "cocos2d.h"
#import "MapScene.h"

@implementation MapViewController

@synthesize mapView;
@synthesize currentLatitude,currentLongitude;
@synthesize cameraViewController;
@synthesize infoView;
@synthesize rest;

-(void)loadOurAnnotations
{	
	CLLocationCoordinate2D workingCoordinate;
    
    for (User *u in self.rest.data)
    {
        if ([u.UDID isEqualToString:[[UIDevice currentDevice] uniqueIdentifier]])
        {
            restUser = u;
            found = YES;
        }
    }
	
	if(![currentLatitude isEqualToString:@"0.000000"])
	{
        workingCoordinate.latitude = locationController.locationManager.location.coordinate.latitude;
		workingCoordinate.longitude = locationController.locationManager.location.coordinate.longitude;
        
        User *u = [[User alloc] init];
        if (found)
        {
            u = restUser;
            u.latitude = [NSString stringWithFormat:@"%f", workingCoordinate.latitude];
            u.longitude = [NSString stringWithFormat:@"%f", workingCoordinate.longitude];
            u.username = @"Joseph";
            u.description = @"EPIMAC iPad";
            [rest updateUser:u];
        }
        else 
        {
            u.UDID = [[UIDevice currentDevice] uniqueIdentifier];
            u.username = @"Joseph";
            u.description = @"EPIMAC iPad";
            u.latitude = [NSString stringWithFormat:@"%f", workingCoordinate.latitude];
            u.longitude = [NSString stringWithFormat:@"%f", workingCoordinate.longitude];
            [rest createUser:u];
        }
		user = [[Annotation alloc] initWithCoordinate:workingCoordinate];
		[user setTitle:u.username];
		[user setSubtitle:@"Vous êtes ici"];
		[user setAnnotationType:AnnotationTypeUser];
	}
}

-(void)addUsers
{
    Annotation *player;
    CLLocationCoordinate2D workingCoordinate;
    
    for (User *u in self.rest.data)
    {
        if (![u.UDID isEqualToString:[[UIDevice currentDevice] uniqueIdentifier]])
        {
            workingCoordinate.latitude = [u.latitude doubleValue];
            workingCoordinate.longitude = [u.longitude doubleValue];
            player = [[Annotation alloc] initWithCoordinate:workingCoordinate];
            [player setTitle:u.username];
            [player setSubtitle:@""];
            [player setAnnotationType:AnnotationTypeApple];
            [mapView addAnnotation:player];
        }
    }
}

-(void)addBonuses
{
    Annotation *bonus;
    CLLocationCoordinate2D workingCoordinate;
    
    for (Bonus *b in self.rest.data)
    {
        workingCoordinate.latitude = [b.latitude doubleValue];
        workingCoordinate.longitude = [b.longitude doubleValue];
        bonus = [[Annotation alloc] initWithCoordinate:workingCoordinate];
        [bonus setTitle:b.description];
        [bonus setSubtitle:@""];
        [bonus setAnnotationType:AnnotationTypeApple];
        [mapView addAnnotation:bonus];
    }
}

- (void)loadView 
{
	[super loadView];
	pointEntries = [[NSMutableArray alloc] init];
	instructionsEntries = [[NSMutableArray alloc] init];
	
	locationController = [[MyCLController alloc] init];
	locationController.delegate = self;
	[locationController.locationManager startUpdatingLocation];
}

-(void) locationClicked:(ARGeoCoordinate *) coordinate 
{
    if (coordinate != nil) 
    {
        NSLog(@"Main View Controller received the click Event for: %@",[coordinate title]);
        
        //AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        //UIViewController *infovc = [[UIViewController alloc] init];
        UIView *infovc = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 - 100, 20, 200, 200)];
        [infovc setBackgroundColor:[UIColor whiteColor]];
        infovc.layer.cornerRadius = 5;
        infovc.layer.masksToBounds = YES;
        
        /*UILabel *errorLabel = [[UILabel alloc] init];
        [errorLabel setNumberOfLines:0];
        [errorLabel setText: [NSString stringWithFormat:@"%@ - Distance: %.2f km. Son armée est plus petite que la vôtre",[coordinate title], [coordinate distanceFromOrigin]/1000.0f]];
        [errorLabel setFrame: [infovc bounds]];
        [errorLabel setTextAlignment:UITextAlignmentCenter];
        [infovc addSubview:errorLabel];*/
        
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(infovc.bounds.size.width/2 - 50,40, 100, 25)];
        [lblTitle setFont:[UIFont boldSystemFontOfSize:14]];
        [lblTitle setTextAlignment:UITextAlignmentCenter];
        lblTitle.text = [coordinate title];
        [infovc addSubview:lblTitle];
        
        UILabel *lblDescription = [[UILabel alloc] initWithFrame:CGRectMake(infovc.bounds.size.width/2 - 50, 65, 100, 40)];
        [lblDescription setFont:[UIFont italicSystemFontOfSize:12]];
        [lblDescription setTextAlignment:UITextAlignmentCenter];
        lblDescription.text = [coordinate description];
        [infovc addSubview:lblDescription];
        
        UILabel *lblDescriptionArmee = [[UILabel alloc] initWithFrame:CGRectMake(10, 110, infovc.bounds.size.width - 20, 30)];
        [lblDescriptionArmee setFont:[UIFont systemFontOfSize:12]];
        [lblDescriptionArmee setNumberOfLines:3];
        [lblDescriptionArmee setTextAlignment:UITextAlignmentCenter];
        lblDescriptionArmee.text = @"Son armée est plus petite que la vôtre";
        [infovc addSubview:lblDescriptionArmee];
        
        UIButton *closeButton = [[UIButton alloc] init];
        UIImage *img = [UIImage imageNamed:@"retour.png"];
        closeButton.frame = CGRectMake(5, 5, 60, 30);
        [closeButton setImage:img forState:UIControlStateNormal];
        
        //[closeButton setBackgroundColor:[UIColor blueColor]];
        [closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [infovc addSubview:closeButton];
        
        UIButton *challengeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        challengeButton.frame = CGRectMake(infovc.bounds.size.width /2 - 60, 150, 120, 30);
        [challengeButton setTitle:@"Challenge" forState:UIControlStateNormal];
        
        //[challengeButton setBackgroundColor:[UIColor blackColor]];
        [challengeButton addTarget:self action:@selector(challengeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [infovc addSubview:challengeButton];
        
        //[[appDelegate window] addSubview:[infovc view]];
        [cameraViewController.view addSubview:infovc];
        
        [self setInfoView:infovc];
    }
}

- (IBAction)closeButtonClicked:(id)sender
{
    [[self infoView] removeFromSuperview];
    infoView = nil;
}

- (IBAction)challengeButtonClicked:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];

    CCGLView *glView = [CCGLView viewWithFrame:self.view.bounds
								   pixelFormat:kEAGLColorFormatRGB565];
    [self.view insertSubview:glView atIndex:10];
    [[CCDirector sharedDirector] setView:glView];
    [self.rest getArmies];
    Player *player = [[Player alloc] createPlayer:1];
    for (Player *p in self.rest.armies)
    {
        player.Warrior = p.Warrior;
        player.Knight = p.Knight;
        player.Boomerang = p.Boomerang;
    }
    [[CCDirector sharedDirector] runWithScene:[Map scene:player]];
}


-(NSMutableArray*) geoLocations 
{    
    NSMutableArray *locationArray = [[NSMutableArray alloc] init];
    ARGeoCoordinate *tempCoordinate;
    CLLocation        *tempLocation;
    
    //[self.rest getUsers];
    
    for (User *u in self.rest.data)
    {
        if (![u.UDID isEqualToString:[[UIDevice currentDevice] uniqueIdentifier]])
        {
            double latitude = [u.latitude doubleValue];
            double longitude = [u.longitude doubleValue];
            
            tempLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
            tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:u.username locationDescription:u.description];
            [locationArray addObject:tempCoordinate];
        }
    }
    
    //ADD BONUSES HERE TOO
    
    return locationArray;
}


-(IBAction)openCamera:(id)sender
{
    ARViewController *arvc = [[ARViewController alloc] initWithDelegate:self];
    [self setCameraViewController:arvc];
    [self presentModalViewController:cameraViewController animated:YES];
    arvc = nil;
}

- (void)locationUpdate:(CLLocation *)location
{
    CLLocationCoordinate2D workingCoordinate;
    workingCoordinate.latitude = location.coordinate.latitude;
    workingCoordinate.longitude = location.coordinate.longitude;
    [mapView removeAnnotation:user]; 
    user.coordinate = workingCoordinate;
    [mapView addAnnotation:user];
    
    counter++;
    if (((int)roundf(user.coordinate.latitude) == 49) && ((int)roundf(user.coordinate.longitude) == 2) && (counter == 0))
    {
        UIAlertView *msg = [[UIAlertView alloc] initWithTitle:@"Alerte!" message:@"Vous etes dans une region importante! Vous pouvez soit declencher la mission soit fuir!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [msg show];
        counter++;
    }
}

- (void)locationError:(NSError *)error 
{
	NSLog(@"error");
}


-(void)run:(id)identifier
{
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    rest = [RestKitController getInstance];
    self.rest.mapDelegate = self;
    [rest setupMappingAndRoutes];
    [self.rest getUsers];
	[self loadOurAnnotations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {

}

#pragma mark mapView delegate functions

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}



@end
