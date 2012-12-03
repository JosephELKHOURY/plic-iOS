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
@synthesize delegate;

-(void)loadOurAnnotations
{	
	CLLocationCoordinate2D workingCoordinate;
    
    for (User *u in self.rest.users)
    {
        if ([u.UUID isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:@"UUID"]])
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
            //u.username = @"Joseph";
            //u.description = @"EPIMAC iPad";
            [rest updateUser:u];
        }
        else 
        {
            u.UUID = [[NSUserDefaults standardUserDefaults] valueForKey:@"UUID"];
            u.username = @"Joseph";
            u.description = @"EPIMAC iPad";
            u.latitude = [NSString stringWithFormat:@"%f", workingCoordinate.latitude];
            u.longitude = [NSString stringWithFormat:@"%f", workingCoordinate.longitude];
            [rest createUser:u];
        }
		user = [[Annotation alloc] initWithCoordinate:workingCoordinate];
		[user setTitle:u.Username];
		[user setSubtitle:@"Vous êtes ici"];
		[user setAnnotationType:AnnotationTypeUser];
	}
}

-(void)addUsers
{
    Annotation *userAnnotation;
    CLLocationCoordinate2D workingCoordinate;
    
    ARGeoCoordinate *tempCoordinate;
    CLLocation *tempLocation;
    
    for (User *u in self.rest.users)
    {
        if (![u.UUID isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:@"UUID"]])
        {
            workingCoordinate.latitude = [u.Latitude doubleValue];
            workingCoordinate.longitude = [u.Longitude doubleValue];
            userAnnotation = [[Annotation alloc] initWithCoordinate:workingCoordinate];
            [userAnnotation setTitle:u.Username];
            [userAnnotation setSubtitle:@""];
            [userAnnotation setAnnotationType:AnnotationTypeApple];
            [mapView addAnnotation:userAnnotation];
            tempLocation = [[CLLocation alloc] initWithLatitude:workingCoordinate.latitude longitude:workingCoordinate.longitude];
            tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:u.Username locationDescription:u.Description];
            [locationArray addObject:tempCoordinate];
        }
    }
    
    /*workingCoordinate.latitude = 48.860339;
    workingCoordinate.longitude = 2.337599;
    player = [[Annotation alloc] initWithCoordinate:workingCoordinate];
    [player setTitle:@"Camille"];
    [player setSubtitle:@""];
    [player setAnnotationType:AnnotationTypeApple];
    [mapView addAnnotation:player];
    
    workingCoordinate.latitude = 48.8583;
    workingCoordinate.longitude = 2.2945;
    player = [[Annotation alloc] initWithCoordinate:workingCoordinate];
    [player setTitle:@"Francois"];
    [player setSubtitle:@""];
    [player setAnnotationType:AnnotationTypeApple];
    [mapView addAnnotation:player];
    
    workingCoordinate.latitude = 48.891894;
    workingCoordinate.longitude = 2.282195;
    player = [[Annotation alloc] initWithCoordinate:workingCoordinate];
    [player setTitle:@"Florian"];
    [player setSubtitle:@""];
    [player setAnnotationType:AnnotationTypeApple];
    [mapView addAnnotation:player];*/
}

-(void)addBonuses
{
    Annotation *bonusAnnotation;
    CLLocationCoordinate2D workingCoordinate;
    
    ARGeoCoordinate *tempCoordinate;
    CLLocation *tempLocation;
    
    for (Bonus *b in self.rest.bonuses)
    {
        workingCoordinate.latitude = [b.latitude doubleValue];
        workingCoordinate.longitude = [b.longitude doubleValue];
        bonusAnnotation = [[Annotation alloc] initWithCoordinate:workingCoordinate];
        [bonusAnnotation setTitle:@"Bonus"];
        [bonusAnnotation setSubtitle:b.description];
        [bonusAnnotation setAnnotationType:AnnotationTypeApple];
        [mapView addAnnotation:bonusAnnotation];
        tempLocation = [[CLLocation alloc] initWithLatitude:workingCoordinate.latitude longitude:workingCoordinate.longitude];
        tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Bonus" locationDescription:b.description];
        [locationArray addObject:tempCoordinate];
    }
}

- (void)loadView 
{
	[super loadView];
	pointEntries = [[NSMutableArray alloc] init];
	instructionsEntries = [[NSMutableArray alloc] init];
    locationArray = [[NSMutableArray alloc] init];
	
	locationController = [[MyCLController alloc] init];
	locationController.delegate = self;
	[locationController.locationManager startUpdatingLocation];
    
    rest = [RestKitController getInstance];
    self.rest.mapDelegate = self;
    [rest setupMappingAndRoutes];
    [self.rest getUsers];
	[self loadOurAnnotations];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
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
        
        UILabel *lblDescriptionArmee = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, infovc.bounds.size.width - 20, 30)];
        [lblDescriptionArmee setFont:[UIFont systemFontOfSize:12]];
        [lblDescriptionArmee setNumberOfLines:3];
        [lblDescriptionArmee setTextAlignment:UITextAlignmentCenter];
        if (!coordinate.isBonus)
            lblDescriptionArmee.text = @"Son armée est plus petite que la vôtre";
        else
            lblDescriptionArmee.text = @"Collectionne des bonus pour gagner des points HP";
        [infovc addSubview:lblDescriptionArmee];
        
        UIButton *closeButton = [[UIButton alloc] init];
        UIImage *img = [UIImage imageNamed:@"button_close_dialog.png"];
        closeButton.frame = CGRectMake(infovc.bounds.size.width - 35, 5, 30, 30);
        [closeButton setImage:img forState:UIControlStateNormal];
        
        //[closeButton setBackgroundColor:[UIColor blueColor]];
        [closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [infovc addSubview:closeButton];
        
        //UIButton *challengeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        UIButton *challengeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        challengeButton.frame = CGRectMake(infovc.bounds.size.width /2 - 73, 140, 146, 48);
        //[challengeButton setTitle:@"Challenge" forState:UIControlStateNormal];
        if (!coordinate.isBonus)
        {
            [challengeButton setImage:[UIImage imageNamed:@"button_challenge.png"] forState:UIControlStateNormal];
            [challengeButton addTarget:self action:@selector(challengeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            [challengeButton setImage:[UIImage imageNamed:@"button_challenge.png"] forState:UIControlStateNormal];
            [challengeButton addTarget:self action:@selector(collectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        [infovc addSubview:challengeButton];
        
        //[[appDelegate window] addSubview:[infovc view]];
        [cameraViewController.view addSubview:infovc];
        
        if ([coordinate distanceFromOrigin] > 1000)
            challengeButton.enabled = NO;
        
        [self setInfoView:infovc];
    }
}

- (IBAction)closeButtonClicked:(id)sender
{
    [[self infoView] removeFromSuperview];
    infoView = nil;
}

- (void)setPlayer
{
    player = [[User alloc] createPlayer:1];
    for (User *p in self.rest.userInfo)
    {
        NSLog(@"%@", p);
        player.Warrior = p.Warrior;
        player.Knight = p.Knight;
        player.Boomerang = p.Boomerang;
    }
    //JUST FOR TESTING WITHOUT A SERVER
    player.Warrior = 3;
    player.Knight = 2;
    player.Boomerang = 2;
    player.warriorAvgLife = 19.5;
    player.knightAvgLife = 16;
    player.boomerangAvgLife = 10;
    NSLog(@"setPlayer: Done");
}

- (IBAction)challengeButtonClicked:(id)sender
{
    [self setPlayer];
    //[self dismissModalViewControllerAnimated:YES];
    //self.cameraViewController = nil;
    //[self.navigationController popToRootViewControllerAnimated:YES];

    /*CCGLView *glView = [CCGLView viewWithFrame:self.navigationController.parentViewController.view.bounds
								   pixelFormat:kEAGLColorFormatRGB565];
    [self.navigationController.parentViewController.view insertSubview:glView atIndex:10];
    //[self.view insertSubview:glView atIndex:10];
    [[CCDirector sharedDirector] setView:glView];
    [[CCDirector sharedDirector] runWithScene:[Map scene:player]];*/
    [delegate goJeu];
}

- (IBAction)collectButtonClicked:(id)sender
{
    [self closeButtonClicked:nil];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}


-(NSMutableArray*) geoLocations 
{    
    /*NSMutableArray *locationArray = [[NSMutableArray alloc] init];
    ARGeoCoordinate *tempCoordinate;
    CLLocation        *tempLocation;
    
    //[self.rest getUsers];
    
    for (User *u in self.rest.users)
    {
        if (![u.UUID isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:@"UUID"]])
        {
            double latitude = [u.Latitude doubleValue];
            double longitude = [u.Longitude doubleValue];
            
            tempLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
            tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:u.Username locationDescription:u.Description];
            [locationArray addObject:tempCoordinate];
        }
    }
    
    for (Bonus *b in self.rest.bonuses)
    {
        if (![u.UUID isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:@"UUID"]])
        {
            double latitude = [u.Latitude doubleValue];
            double longitude = [u.Longitude doubleValue];
            
            tempLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
            tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:u.Username locationDescription:u.Description];
            [locationArray addObject:tempCoordinate];
        }
    }
    
    double latitude = 48.860339;
    double longitude = 2.337599;
    
    tempLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Camille" locationDescription:@""];
    [locationArray addObject:tempCoordinate];
    
    latitude = 48.8583;
    longitude = 2.2945;
    
    tempLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Francois" locationDescription:@""];
    [locationArray addObject:tempCoordinate];
    
    latitude = 48.891894;
    longitude = 2.282195;
    
    tempLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Florian" locationDescription:@""];
    [locationArray addObject:tempCoordinate];
    
    
    //ADD BONUSES HERE TOO
    
    latitude = 46.891894;
    longitude = 3.282195;
    
    tempLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    tempCoordinate = [ARGeoCoordinate coordinateWithLocation:tempLocation locationTitle:@"Bonus" locationDescription:@""];
    tempCoordinate.isBonus = YES;
    [locationArray addObject:tempCoordinate];*/
    
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
    //[mapView setCenterCoordinate:workingCoordinate];
    
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
