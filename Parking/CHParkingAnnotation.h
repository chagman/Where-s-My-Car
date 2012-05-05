//
//  CHParkingAnnotation.h
//  Parking
//
//  Created by Charles Hagman on 12/27/11.
//  Copyright (c) 2011 Deloitte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class CHParkingSpot;

@interface CHParkingAnnotation : NSObject <MKAnnotation> {
    NSString *_car;
    NSString *_address;
    CLLocationCoordinate2D _coordinate;
    
    CHParkingSpot *_parkingSpot;
}

@property (copy) NSString *car;
@property (copy) NSString *address;
@property (strong, nonatomic) CHParkingSpot *parkingSpot;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithCar:(NSString*)car coordinate:(CLLocationCoordinate2D)coordinate;
- (id)initWithParkingSpot:(CHParkingSpot *)parkingSpot;


@end
