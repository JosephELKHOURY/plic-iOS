//
//  FacebookViewController.m
//  PLIC-iOS
//
//  Created by Joseph El Khoury on 9/5/12.
//
//

#import "FacebookLoginViewController.h"

@interface FacebookLoginViewController ()

@end

@implementation FacebookLoginViewController
@synthesize label;
@synthesize delegate, topViewController;
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
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (IBAction)performLogin:(id)sender
{
    [delegate openSessionWithAllowLoginUI:YES];
}

- (IBAction)goBack:(id)sender
{
    [topViewController dismissModalViewControllerAnimated:YES];
    [topViewController.navigationController popToRootViewControllerAnimated:YES];
}
@end
