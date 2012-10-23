#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef enum{
	AnnotationTypeApple=0,
    AnnotationTypeUser=1
}AnnotationType;

@interface Annotation : NSObject<MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	NSString *title;
	NSString *subtitle;
	AnnotationType annotationType;
}
@property(nonatomic) CLLocationCoordinate2D coordinate;
@property(nonatomic) NSString *title;
@property(nonatomic) NSString *subtitle;
@property(nonatomic) AnnotationType annotationType;

-initWithCoordinate:(CLLocationCoordinate2D)inCoord;

@end
