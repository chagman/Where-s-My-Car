//
//  CHParkingSpot.h
//  Parking
//
//  Created by Charles Hagman on 1/3/12.
//  Copyright (c) 2012 Deloitte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>

@class CHCar;

@interface CHParkingSpot : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSString * zip;
@property (nonatomic, retain) NSNumber * timeLimit;
@property (nonatomic, retain) CHCar *car;

-(CLLocationCoordinate2D)location;

@end
