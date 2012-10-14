//
//  CoordinateView.h
//  AR Kit
//
//  Created by Niels W Hansen on 12/31/11.
//  Copyright 2011 Agilite Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARViewProtocol.h"

@class ARGeoCoordinate;

@interface MarkerView : UIView {
    ARGeoCoordinate *coordinateInfo;
    id<ARMarkerDelegate> __weak delegate;
}

- (id)initForCoordinate:(ARGeoCoordinate *)coordinate withDelgate:(id<ARMarkerDelegate>) aDelegate;

@property (nonatomic,strong) ARGeoCoordinate *coordinateInfo;
@property (nonatomic, weak) id<ARMarkerDelegate> delegate;
@property (nonatomic, strong) UILabel *lblDistance;


@end
