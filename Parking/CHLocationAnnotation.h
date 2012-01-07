//
//  CHLocationAnnotation.h
//  Parking
//
//  Created by Charles Hagman on 1/6/12.
//  Copyright (c) 2012 Deloitte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CHLocationAnnotation : NSObject <MKAnnotation> {
     CLLocationCoordinate2D _coordinate;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end
