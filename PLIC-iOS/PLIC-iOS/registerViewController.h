//
//  registerViewController.h
//  PLIC-iOS
//
//  Created by Joseph El Khoury on 10/14/12.
//
//

#import <UIKit/UIKit.h>

@interface registerViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *txtName;
@property (strong, nonatomic) IBOutlet UITextView *txtDescription;

-(IBAction)cancel;

@end
