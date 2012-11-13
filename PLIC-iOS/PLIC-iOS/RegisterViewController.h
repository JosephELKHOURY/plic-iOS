//
//  registerViewController.h
//  PLIC-iOS
//
//  Created by Joseph El Khoury on 10/14/12.
//
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "RestKitController.h"

@interface RegisterViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UITextField *txtName;
@property (strong, nonatomic) IBOutlet UITextView *txtDescription;

- (IBAction)cancel;
- (IBAction)btnRegister:(id)sender;

@end
