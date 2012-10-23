//
//  UserInfoViewController.h
//  PLIC-iOS
//
//  Created by Joseph El Khoury on 10/23/12.
//
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface UserInfoViewController : UIViewController
{
    User *user;
}

@property (strong, nonatomic) User *user;
@property (strong, nonatomic) IBOutlet UILabel *txtName;
@property (strong, nonatomic) IBOutlet UILabel *txtDescription;
@property (strong, nonatomic) IBOutlet UIButton *btnSave;

- (IBAction)updateInfo:(id)sender;
- (IBAction)saveInfo:(id)sender;

@end
