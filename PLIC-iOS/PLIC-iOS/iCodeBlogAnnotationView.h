//
//  iCodeBlogAnnotationView.h
//  maps
//
//  Created by Ghady Rayess on 6/28/10.
//  Copyright 2010 FOO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "iCodeBlogAnnotation.h"
#import"iCodeBlogAnnotationView.h"

@interface iCodeBlogAnnotationView : MKAnnotationView {
	UIImageView *imageView;
}
@property(nonatomic) UIImageView *imageView;
@end
