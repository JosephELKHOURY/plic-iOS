//
//  AnnotationView.h
//  maps
//
//  Created by Ghady Rayess on 6/28/10.
//  Copyright 2010 FOO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Annotation.h"
#import "AnnotationView.h"

@interface AnnotationView : MKAnnotationView {
	UIImageView *imageView;
}
@property(nonatomic) UIImageView *imageView;
@end
