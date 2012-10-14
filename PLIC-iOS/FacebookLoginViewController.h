//
//  FacebookViewController.h
//  PLIC-iOS
//
//  Created by Joseph El Khoury on 9/5/12.
//
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "FacebookViewController.h"

@protocol FacebookDelegate;

@interface FacebookLoginViewController : UIViewController
{
    UIViewController *topViewController;
}

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic) id<FacebookDelegate> delegate;
@property (strong, nonatomic) UIViewController *topViewController;

- (IBAction)performLogin:(id)sender;
- (IBAction)goBack:(id)sender;

@end
