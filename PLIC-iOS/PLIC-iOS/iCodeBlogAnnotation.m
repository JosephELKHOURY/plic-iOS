//
//  iCodeBlogAnnotation.m
//  maps
//
//  Created by Ghady Rayess on 6/28/10.
//  Copyright 2010 FOO. All rights reserved.
//

#import "iCodeBlogAnnotation.h"


@implementation iCodeBlogAnnotation
@synthesize coordinate,title,subtitle,annotationType;
-init{
	return self;
}

-initWithCoordinate:(CLLocationCoordinate2D)inCoord{
	coordinate=inCoord;
	return self;
}

@end
