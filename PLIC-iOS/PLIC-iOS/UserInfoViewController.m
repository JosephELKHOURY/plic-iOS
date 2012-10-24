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
    // Do any additional setup after loading the view.
    self.txtName.text = user.Username;
    self.txtDescription.text = user.Description;
    [self.btnSave addTarget:self action:@selector(updateInfo:) forControlEvents:UIControlEventTouchUpInside];
    self.txtName.textColor = [UIColor lightGrayColor];
    self.txtDescription.textColor = [UIColor lightGrayColor];
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
    [self setBtnSave:nil];
    [super viewDidUnload];
}

-(IBAction)updateInfo:(id)sender
{
    self.txtName.enabled = YES;
    self.txtName.textColor = [UIColor blackColor];
    self.txtDescription.enabled = YES;
    self.txtDescription.textColor = [UIColor blackColor];
    [self.btnSave removeTarget:self action:@selector(updateInfo:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnSave addTarget:self action:@selector(saveInfo:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnSave setTitle:@"Sauvegarder" forState:UIControlStateNormal];
}

- (IBAction)saveInfo:(id)sender
{
    self.txtName.enabled = NO;
    self.txtName.textColor = [UIColor lightGrayColor];
    self.txtDescription.enabled = NO;
    self.txtDescription.textColor = [UIColor lightGrayColor];
    
    user.Username = self.txtName.text;
    user.Description = self.txtDescription.text;
    
    //TODO UDPDATE INFO: SEND TO SERVER
    RestKitController *rest = [RestKitController getInstance];
    [rest updateUser:user];
    
    
    [self.btnSave removeTarget:self action:@selector(saveInfo:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnSave addTarget:self action:@selector(updateInfo:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnSave setTitle:@"Modifier" forState:UIControlStateNormal];
}

@end
