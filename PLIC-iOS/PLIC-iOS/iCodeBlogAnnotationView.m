//
//  iCodeBlogAnnotationView.m
//  maps
//
//  Created by Ghady Rayess on 6/28/10.
//  Copyright 2010 FOO. All rights reserved.
//

#import "iCodeBlogAnnotationView.h"
@implementation iCodeBlogAnnotationView
@synthesize imageView;
#define kHeight 20
#define kWidth 20
#define kBorder 2

-(id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
	iCodeBlogAnnotation *myAnnotation = (iCodeBlogAnnotation*)annotation;
	if ([myAnnotation annotationType]==iCodeBlogAnnotationTypeApple) {
		self=[super initWithAnnotation:myAnnotation reuseIdentifier:reuseIdentifier];
		self.frame = CGRectMake(0, 0, kWidth, kHeight);
		self.backgroundColor = [UIColor clearColor];
		
		imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"movieB.png"]];
		imageView.frame = CGRectMake(kBorder, kBorder, kWidth-2*kBorder, kWidth-2*kBorder);
		[self addSubview:imageView];
	}
	else if ([myAnnotation annotationType]==iCodeBlogAnnotationTypeUser) {
		self=[super initWithAnnotation:myAnnotation reuseIdentifier:reuseIdentifier];
		self.frame = CGRectMake(0, 0, kWidth, kHeight);
		self.backgroundColor = [UIColor clearColor];
		
		imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"man.png"]];
		imageView.frame = CGRectMake(kBorder, kBorder, kWidth-2*kBorder, kWidth-2*kBorder);
		[self addSubview:imageView];
		
	}
	else if ([myAnnotation annotationType]==iCodeBlogAnnotationTypeTaco) {
		self=[super initWithAnnotation:myAnnotation reuseIdentifier:reuseIdentifier];
		self.frame = CGRectMake(0, 0, kWidth, kHeight);
		self.backgroundColor = [UIColor clearColor];
		
		imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TacosMarker.png"]];
		imageView.frame = CGRectMake(kBorder, kBorder, kWidth-2*kBorder, kWidth-2*kBorder);
		[self addSubview:imageView];
	}
	[imageView setContentMode:UIViewContentModeScaleAspectFill];
	return self;
}



@end
