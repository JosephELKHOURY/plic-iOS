//
//  CameraViewController.h
//  Parisk
//
//  Created by SEKIMIA on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARKit/ARViewController.h"
 
@interface CameraViewController : UIViewController
{
    ARViewController *cameraViewController;
    UIAccelerometer *accelerometer;
    UILabel *lblAcc;
}

@property (nonatomic) ARViewController *cameraViewController;

@end
