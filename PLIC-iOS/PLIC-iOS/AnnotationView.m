//
//  AnnotationView.m
//  maps
//
//  Created by Ghady Rayess on 6/28/10.
//  Copyright 2010 FOO. All rights reserved.
//

#import "AnnotationView.h"

@implementation AnnotationView

@synthesize imageView;

#define kHeight 20
#define kWidth 20
#define kBorder 2

-(id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
	Annotation *myAnnotation = (Annotation*)annotation;
	if ([myAnnotation annotationType]==AnnotationTypeApple) {
		self=[super initWithAnnotation:myAnnotation reuseIdentifier:reuseIdentifier];
		self.frame = CGRectMake(0, 0, kWidth, kHeight);
		self.backgroundColor = [UIColor clearColor];
		
		imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"movieB.png"]];
		imageView.frame = CGRectMake(kBorder, kBorder, kWidth-2*kBorder, kWidth-2*kBorder);
		[self addSubview:imageView];
	}
	else if ([myAnnotation annotationType]==AnnotationTypeUser) {
		self=[super initWithAnnotation:myAnnotation reuseIdentifier:reuseIdentifier];
		self.frame = CGRectMake(0, 0, kWidth, kHeight);
		self.backgroundColor = [UIColor clearColor];
		
		imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"man.png"]];
		imageView.frame = CGRectMake(kBorder, kBorder, kWidth-2*kBorder, kWidth-2*kBorder);
		[self addSubview:imageView];
		
	}
	[imageView setContentMode:UIViewContentModeScaleAspectFill];
	return self;
}

@end
