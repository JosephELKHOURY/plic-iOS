//
//  User.h
//  PLIC-iOS
//
//  Created by SEKIMIA on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *UDID;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSNumber *id;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;

@end
