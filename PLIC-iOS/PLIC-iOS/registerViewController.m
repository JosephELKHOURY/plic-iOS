//
//  registerViewController.m
//  PLIC-iOS
//
//  Created by Joseph El Khoury on 10/14/12.
//
//

#import "registerViewController.h"

@interface registerViewController ()

@end

@implementation registerViewController

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

-(IBAction)cancel
{
    [self dismissModalViewControllerAnimated:YES];
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

- (void)viewDidUnload {
    [self setTxtName:nil];
    [self setTxtDescription:nil];
    [super viewDidUnload];
}
@end
