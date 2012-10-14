//
//  iCodeBlogAnnotation.h
//  maps
//
//  Created by Ghady Rayess on 6/28/10.
//  Copyright 2010 FOO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef enum{
	iCodeBlogAnnotationTypeApple=0,
		iCodeBlogAnnotationTypeUser=1,
		iCodeBlogAnnotationTypeTaco=2,
}iCodeBlogAnnotationType;

@interface iCodeBlogAnnotation : NSObject<MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	NSString *title;
	NSString *subtitle;
	iCodeBlogAnnotationType annotationType;
}
@property(nonatomic) CLLocationCoordinate2D coordinate;
@property(nonatomic) NSString *title;
@property(nonatomic) NSString *subtitle;
@property(nonatomic) iCodeBlogAnnotationType annotationType;

-initWithCoordinate:(CLLocationCoordinate2D)inCoord;

@end
