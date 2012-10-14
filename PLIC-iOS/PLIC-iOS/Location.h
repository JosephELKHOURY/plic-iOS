//
//  Location.h
//  PLIC-iOS
//
//  Created by SEKIMIA on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <RestKit/RestKit.h>

@interface Location : RKObjectMapping

@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;

@end
