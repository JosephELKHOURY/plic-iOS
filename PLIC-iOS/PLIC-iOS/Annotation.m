//
//  Annotation.m
//  maps
//
//  Created by Ghady Rayess on 6/28/10.
//  Copyright 2010 FOO. All rights reserved.
//

#import "Annotation.h"


@implementation Annotation
@synthesize coordinate,title,subtitle,annotationType;
-init{
	return self;
}

-initWithCoordinate:(CLLocationCoordinate2D)inCoord{
	coordinate=inCoord;
	return self;
}

@end
