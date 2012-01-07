//
//  CHParkingSpot.m
//  Parking
//
//  Created by Charles Hagman on 1/3/12.
//  Copyright (c) 2012 Deloitte. All rights reserved.
//

#import "CHParkingSpot.h"
#import "CHCar.h"


@implementation CHParkingSpot

@dynamic address;
@dynamic city;
@dynamic latitude;
@dynamic longitude;
@dynamic startDate;
@dynamic state;
@dynamic endDate;
@dynamic zip;
@dynamic timeLimit;
@dynamic car;


-(CLLocationCoordinate2D)location {
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
    return loc;
}

@end
