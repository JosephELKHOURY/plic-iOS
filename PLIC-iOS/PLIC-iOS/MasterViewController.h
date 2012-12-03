//
//  MasterViewController.h
//  Parisk
//
//  Created by SEKIMIA on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameViewController.h"
#import "RestKitController.h"
#import "UserInfoViewController.h"
#import "DebriefViewController.h"
#import "MapViewController.h"
#import "RoundedRectView.h"

@protocol MasterDelegate <NSObject>

-(IBAction)goJeu;

@end

@interface MasterViewController : UIViewController <MasterControllerDelegate, MasterDelegate>
{
    User *player;
    RoundedRectView *loadingView;
	UIActivityIndicatorView *activityView;
}

@property (strong, nonatomic) RestKitController *rest;

@end
