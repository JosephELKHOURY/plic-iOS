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

@interface MasterViewController : UIViewController <MasterControllerDelegate>
{
    Player *player;
}

@property (strong, nonatomic) RestKitController *rest;

-(IBAction)goJeu;

@end
