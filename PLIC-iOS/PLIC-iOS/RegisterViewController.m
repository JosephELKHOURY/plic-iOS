//
//  registerViewController.m
//  PLIC-iOS
//
//  Created by Joseph El Khoury on 10/14/12.
//
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

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
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"inscription.jpg"]];
    [self.tableView setBackgroundView:imageView];
}

-(IBAction)cancel
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)register:(id)sender
{
    User *user = [[User alloc] init];
    user.UUID = [[NSUserDefaults standardUserDefaults] valueForKey:@"UUID"];
    user.Username = self.txtName.text;
    user.Description = self.txtDescription.text;
    RestKitController *rest = [RestKitController getInstance];
    [rest createUser:user];
    [self cancel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.txtName isFirstResponder] && [touch view] != self.txtName)
        [self.txtName resignFirstResponder];
    if ([self.txtDescription isFirstResponder] && [touch view] != self.txtDescription)
        [self.txtDescription resignFirstResponder];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}


- (void)viewDidUnload {
    [self setTxtName:nil];
    [self setTxtDescription:nil];
    [super viewDidUnload];
}
@end
