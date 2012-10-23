//
//  UserInfoViewController.m
//  PLIC-iOS
//
//  Created by Joseph El Khoury on 10/23/12.
//
//

#import "UserInfoViewController.h"

@interface UserInfoViewController ()

@end

@implementation UserInfoViewController
@synthesize user;

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
    self.txtName.text = user.username;
    self.txtDescription.text = user.description;
	// Do any additional setup after loading the view.
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
- (IBAction)saveInfo:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
