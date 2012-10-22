//
//  mapsViewController.m
//  maps
//
//  Created by Joseph ELKHOURY on 6/28/11.
//  Copyright H.J ELKHOURY 2011. All rights reserved.
//

#import "MapViewController.h"
#import "iCodeBlogAnnotationView.h"
#import "cocos2d.h"
#import "MapScene.h"

@implementation MapViewController
@synthesize mapView,tableview;
@synthesize currentLatitude,currentLongitude;
@synthesize cameraViewController;
@synthesize infoView;
@synthesize rest;
//@synthesize routeView = _routeView;
//@synthesize region;

-(void)loadOurAnnotations
{	
	CLLocationCoordinate2D workingCoordinate;
    
    for (User *u in self.rest.data)
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
            u.username = @"Joseph";
            u.description = @"EPIMAC iPad";
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
		user = [[iCodeBlogAnnotation alloc] initWithCoordinate:workingCoordinate];
		[user setTitle:u.username];
		[user setSubtitle:@"Vous êtes ici"];
		[user setAnnotationType:iCodeBlogAnnotationTypeUser];
	}
}

-(void)addUsers
{
    iCodeBlogAnnotation *player;
    CLLocationCoordinate2D workingCoordinate;
    
    for (User *u in self.rest.data)
    {
        if (![u.UUID isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:@"UUID"]])
        {
            workingCoordinate.latitude = [u.latitude doubleValue];
            workingCoordinate.longitude = [u.longitude doubleValue];
            player = [[iCodeBlogAnnotation alloc] initWithCoordinate:workingCoordinate];
            [player setTitle:u.username];
            [player setSubtitle:@""];
            [player setAnnotationType:iCodeBlogAnnotationTypeApple];
            [mapView addAnnotation:player];
        }
    }
}

-(void)addBonuses
{
    iCodeBlogAnnotation *bonus;
    CLLocationCoordinate2D workingCoordinate;
    
    for (Bonus *b in self.rest.data)
    {
        workingCoordinate.latitude = [b.latitude doubleValue];
        workingCoordinate.longitude = [b.longitude doubleValue];
        bonus = [[iCodeBlogAnnotation alloc] initWithCoordinate:workingCoordinate];
        [bonus setTitle:b.description];
        [bonus setSubtitle:@""];
        [bonus setAnnotationType:iCodeBlogAnnotationTypeApple];
        [mapView addAnnotation:bonus];
    }
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
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
    //GameViewController *v = [[GameViewController alloc] initWithNibName:@"GameView" bundle:nil];
    //[self.navigationController pushViewController:v animated:YES];
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
        if (![u.UUID isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:@"UUID"]])
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
    //[cameraViewController setModalTransitionStyle: UIModalTransitionStyleFlipHorizontal];
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

/*-(void)showRoute
{
	_routeViews = [[NSMutableDictionary alloc] init];
	
	NSMutableArray* points = [[NSMutableArray alloc] initWithCapacity:pointEntries.count];
	
	for(int idx = 0; idx < pointEntries.count; idx+=2)
	{
		CLLocationDegrees latitude  = [[pointEntries objectAtIndex:idx] doubleValue];
		CLLocationDegrees longitude = [[pointEntries objectAtIndex:idx+1] doubleValue];
		
		CLLocation* currentLocation = [[[CLLocation alloc] initWithLatitude:latitude longitude:longitude] autorelease];
		[points addObject:currentLocation];
	}
	
	// CREATE THE ANNOTATIONS AND ADD THEM TO THE MAP
	
	// first create the route annotation, so it does not draw on top of the other annotations. 
	CSRouteAnnotation* routeAnnotation = [[[CSRouteAnnotation alloc] initWithPoints:points] autorelease];
	[mapView addAnnotation:routeAnnotation];
	
	
	// create the rest of the annotations
	//CSMapAnnotation* annotation = nil;*/
	
	/*// create the start annotation and add it to the array
	 annotation = [[[CSMapAnnotation alloc] initWithCoordinate:[[points objectAtIndex:0] coordinate]
	 annotationType:CSMapAnnotationTypeStart
	 title:@"Start Point"] autorelease];
	 [mapView addAnnotation:annotation];
	 
	 
	 // create the end annotation and add it to the array
	 annotation = [[[CSMapAnnotation alloc] initWithCoordinate:[[points objectAtIndex:points.count - 1] coordinate]
	 annotationType:CSMapAnnotationTypeEnd
	 title:@"End Point"] autorelease];
	 [mapView addAnnotation:annotation];*/
	
	
	/*// create the image annotation
	 annotation = [[[CSMapAnnotation alloc] initWithCoordinate:[[points objectAtIndex:points.count / 2] coordinate]
	 annotationType:CSMapAnnotationTypeImage
	 title:@"Cleveland Circle"] autorelease];
	 [annotation setUserData:@"cc.jpg"];
	 [annotation setUrl:[NSURL URLWithString:@"http://en.m.wikipedia.org/wiki/Cleveland_Circle"]];
	 
	 [mapView addAnnotation:annotation];*/
	
	// center and size the map view on the region computed by our route annotation. 
	//[mapView setRegion:routeAnnotation.region];
	
	//[points release];
//}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
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
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (iCodeBlogAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id )annotation
{
	NSLog(@"view for annotations is called");
	iCodeBlogAnnotationView *annotationView = nil;
	//iCodeBlogAnnotation* myAnnotation = (iCodeBlogAnnotation *)annotation;
	
	/*if(![annotation isKindOfClass:[CSRouteAnnotation class]])
	{
		if(myAnnotation.annotationType == iCodeBlogAnnotationTypeApple) {
			NSString *identifier = @"Apple";
			iCodeBlogAnnotationView *newAnnotationView = (iCodeBlogAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
			
			if(nil == newAnnotationView)
			{
				newAnnotationView=[[[iCodeBlogAnnotationView alloc] initWithAnnotation:myAnnotation reuseIdentifier:identifier];
			}
			annotationView = newAnnotationView;
		}
		else if(myAnnotation.annotationType==iCodeBlogAnnotationTypeUser){
			NSString *identifier = @"School";
			iCodeBlogAnnotationView *newAnnotationView=(iCodeBlogAnnotationView*) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
			if (newAnnotationView==nil) {
				newAnnotationView=[[[iCodeBlogAnnotationView alloc]initWithAnnotation:myAnnotation reuseIdentifier:identifier];
			}
			annotationView = newAnnotationView;
		}
		else if(myAnnotation.annotationType==iCodeBlogAnnotationTypeTaco){
			NSString *identifier = @"Taco";
			iCodeBlogAnnotationView *newAnnotationView=(iCodeBlogAnnotationView*) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
			if (newAnnotationView==nil) {
				newAnnotationView=[[[iCodeBlogAnnotationView alloc]initWithAnnotation:myAnnotation reuseIdentifier:identifier]autorelease];
			}
			annotationView = newAnnotationView;
		}
		[annotationView setEnabled:YES];
		[annotationView setCanShowCallout:YES];
	}
	
	else
	{
		CSRouteAnnotation* routeAnnotation = (CSRouteAnnotation*) annotation;
		
		annotationView = [_routeViews objectForKey:routeAnnotation.routeID];
		
		if(nil == annotationView)
		{
			CSRouteView* routeView = [[[CSRouteView alloc] initWithFrame:CGRectMake(0, 0, self.mapView.frame.size.width, self.mapView.frame.size.height)] autorelease];
			
			routeView.annotation = routeAnnotation;
			routeView.mapView = self.mapView;
			
			[_routeViews setObject:routeView forKey:routeAnnotation.routeID];
			
			annotationView = (iCodeBlogAnnotationView *)routeView;
		}
	}*/
	
	return annotationView;
}

#pragma mark mapView delegate functions
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
	// turn off the view of the route as the map is chaning regions. This prevents
	// the line from being displayed at an incorrect positoin on the map during the
	// transition. 
	/*for(NSObject* key in [_routeViews allKeys])
	{
		CSRouteView* routeView = [_routeViews objectForKey:key];
		routeView.hidden = YES;
	}*/
	
}
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
	// re-enable and re-poosition the route display. 
	/*for(NSObject* key in [_routeViews allKeys])
	{
		CSRouteView* routeView = [_routeViews objectForKey:key];
		routeView.hidden = NO;
		[routeView regionChanged];
	}*/
	
}

/*-(void)getRouteInformationWithSourceLatitude:(double)source_latitude SourceLongitude:(double)source_longitude 
						 DestinationLatitude:(NSString *)destination_latitude DestinationLongitude:(NSString *)destination_longitude
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	
	
	NSString *blogAddress = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=false",
							 source_latitude,source_longitude,[destination_latitude doubleValue],[destination_longitude doubleValue]];
	NSLog(@"%@",blogAddress);
	
	
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:blogAddress]];
	
	NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	
	
	NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
	NSDictionary *feed = [parser objectWithString:json_string error:nil];
	
	if([[feed objectForKey:@"status"] isEqualToString:@"ZERO_RESULTS"] || [[feed objectForKey:@"status"] isEqualToString:@"OVER_QUERY_LIMIT"])
	{
		[parser release];
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		return;
	}
	
	NSArray *routesArray = [feed objectForKey:@"routes"];
    NSDictionary *firstRoute = [routesArray objectAtIndex:0];
    NSArray *legsArray = [firstRoute objectForKey:@"legs"];
    NSDictionary *firstLeg = [legsArray objectAtIndex:0];
	NSDictionary *steps = [firstLeg objectForKey:@"steps"];
    //NSDictionary *distanceDict = [firstLeg objectForKey:@"distance"];
    //NSString *distanceText = [distanceDict objectForKey:@"text"];
	
	NSLog(@"%@",steps);
	
	if(steps != (NSDictionary *)[NSNull null])
	{
		NSDictionary *start_location;
		NSDictionary *end_location;
		NSDictionary *distance;
		for(NSMutableDictionary *step in steps)
		{
			start_location = [step objectForKey:@"start_location"];
			[pointEntries addObject:[start_location objectForKey:@"lat"]];
			[pointEntries addObject:[start_location objectForKey:@"lng"]];
			end_location = [step objectForKey:@"end_location"];
			[pointEntries addObject:[end_location objectForKey:@"lat"]];
			[pointEntries addObject:[end_location objectForKey:@"lng"]];
			[instructionsEntries addObject:[step objectForKey:@"html_instructions"]];
			distance = [step objectForKey:@"distance"];
			[instructionsEntries addObject:[distance objectForKey:@"text"]];
		}
	}
	NSLog(@"%@",pointEntries);
	[json_string release];
	[parser release];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[pool release];
}*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}



@end
