//
//  RestKitViewController.m
//  Parisk
//
//  Created by SEKIMIA on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RestKitViewController.h"

@interface RestKitViewController ()

@end

@implementation RestKitViewController
@synthesize txtResponse;

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
    //[self connectToClient];
    //[self sendRequests];
    [self load];
}

- (void)connectToClient
{
    RKClient* client = [RKClient clientWithBaseURL:[RKURL URLWithString:@"https://api.twitter.com"]];  
    NSLog(@"I am your RKClient singleton : %@", client); 
    NSString *str = [NSString stringWithFormat:@"%@\nConnecting to client: http://api.twitter.com", txtResponse.text];
    txtResponse.text = str;
}


- (void)sendRequests 
{  
    // Une simple requete HTTP GET
    [[RKClient sharedClient] get:@"1/statuses/21947795900469248/retweeted_by.json" delegate:self];      
    NSString *str = [NSString stringWithFormat:@"%@\nSending HTTP GET request: 1/statuses/21947795900469248/retweeted_by.json", txtResponse.text];
    txtResponse.text = str;
    
    // Une simple requete HTTP POST  
    NSDictionary* params = [NSDictionary dictionaryWithObject:@"RestKit" forKey:@"Sender"];  
    [[RKClient sharedClient] post:@"/other.json" params:params delegate:self];  
}  

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response 
{  
    if ([request isGET]) 
    {  
        // Handling GET /foo.xml  
        NSString *str = [NSString stringWithFormat:@"%@\nResponse code: %d", txtResponse.text, response.statusCode];
        txtResponse.text = str;
        if ([response isOK]) 
        {  
            // Success! Let's take a look at the data  
            NSLog(@"Retrieved XML: %@", [response bodyAsString]);  
        }  
        else {
            //NSLog(@"response is not OK"); 
        }
        
    } 
    else if ([request isPOST])
    {  
        // Handling POST /other.json  
        if ([response isJSON]) 
        {  
            NSLog(@"Got a JSON response back from our POST!");  
        }  
        
    }  
}  

- (void)load
{
    // Creation de l'instance de RKObjectManager
    RKObjectManager* objectManager = [RKObjectManager managerWithBaseURLString:@"https://api.twitter.com/"];
    
    objectManager.client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    
    // Mapping des attributs
    RKObjectMapping* responseMapping = [RKObjectMapping mappingForClass:[Response class]];
    [responseMapping mapKeyPath:@"id" toAttribute:@"identifier"];
    [responseMapping mapKeyPath:@"name" toAttribute:@"name"];
    [responseMapping mapKeyPath:@"lang" toAttribute:@"lang"];
    [responseMapping mapKeyPath:@"followers_count" toAttribute:@"followers_count"];
    
    [objectManager.mappingProvider setObjectMapping:responseMapping forResourcePathPattern:@"1/statuses/21947795900469248/retweeted_by.json"];
    
    objectManager = [RKObjectManager sharedManager];
    
    // On specifie ici l'URL de notre serveur
    objectManager.client.baseURL = [RKURL URLWithString:@"https://api.twitter.com/"];
    
    // Voila la requete GET
    [objectManager loadObjectsAtResourcePath:@"1/statuses/21947795900469248/retweeted_by.json" delegate:self];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {  
    for (Response *response in objects)
    {
        NSLog(@"Loaded Response ID %@,\nName: %@,\nLanguage: %@,\nFollowers: %@", response.identifier, response.name, response.lang, response.followers_count);  
        NSString *str = [NSString stringWithFormat:@"%@\nLoaded Response ID %@,\nName: %@,\nLanguage: %@,\nFollowers: %@", txtResponse.text, response.identifier, response.name, response.lang, response.followers_count];
        txtResponse.text = str;
    }
}  

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {  
    NSLog(@"Encountered an error: %@", error);  
} 

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
