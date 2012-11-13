//
//  AppDelegate.h
//  PLIC-iOS
//
//  Created by SEKIMIA on 7/1/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "GCHelper.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, CCDirectorDelegate>
{
	UIWindow *window_;
	UINavigationController *__weak navController_;

	CCDirectorIOS	*__unsafe_unretained director_;							// weak ref
}

@property (strong, nonatomic) UIWindow *window;
@property (weak, readonly) UINavigationController *navController;
@property (unsafe_unretained, readonly) CCDirectorIOS *director;

@end
