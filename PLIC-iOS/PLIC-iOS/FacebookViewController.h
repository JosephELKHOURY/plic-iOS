//
//  FacebookViewController.h
//  PLIC-iOS
//
//  Created by Joseph El Khoury on 9/5/12.
//
//

#import <UIKit/UIKit.h>
#import "FacebookLoginViewController.h"

@protocol FacebookDelegate <NSObject>

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;

@end

@interface FacebookViewController : UIViewController    <FacebookDelegate>
@property (strong, nonatomic) IBOutlet FBProfilePictureView *userProfileImage;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;

@end
