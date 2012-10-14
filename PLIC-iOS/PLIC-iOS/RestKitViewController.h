//
//  RestKitViewController.h
//  Parisk
//
//  Created by SEKIMIA on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "Response.h"

@interface RestKitViewController : UIViewController <RKRequestDelegate, RKObjectLoaderDelegate>
{
    IBOutlet UITextView *txtResponse;
}

@property(nonatomic, retain) IBOutlet UITextView *txtResponse;

@end
