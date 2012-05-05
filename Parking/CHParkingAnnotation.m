//
//  CHParkingAnnotation.m
//  Parking
//
//  Created by Charles Hagman on 12/27/11.
//  Copyright (c) 2011 Deloitte. All rights reserved.
//

#import "CHParkingAnnotation.h"
#import "CHParkingSpot.h"
#import "CHCar.h"
#import "CarManager.h"

@implementation CHParkingAnnotation

@synthesize car=_car, address=_address, coordinate=_coordinate, parkingSpot=_parkingSpot;

- (id)initWithCar:(NSString *)car coordinate:(CLLocationCoordinate2D)coordinate {
    if ((self = [super init])) {
        self.car = [car copy];
        //self.address = [address copy];
        _coordinate = coordinate;
    }
    return self;
}

- (id)initWithParkingSpot:(CHParkingSpot *)parkingSpot {
    if ((self = [super init])) {
        self.parkingSpot = parkingSpot;
        _coordinate = parkingSpot.location;
    }
    return self;
}

- (NSString *)title {
    if (self.parkingSpot) {
        return self.parkingSpot.car.carLabel;
    } else {
        return @"Mazda3";
    }
    
}

- (NSString *)subtitle {
    if (self.parkingSpot != nil){
        NSString *timeRemaining = [[CarManager sharedCarManager] timeRemainingForSpot:self.parkingSpot];
        NSString *notes = (self.parkingSpot.notes != nil) ? [self.parkingSpot.notes stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] : @"";
        
        if (![notes isEqualToString:@""]) {
                return [NSString stringWithFormat:@"Notes: %@. \n%@", notes , timeRemaining];
        }
        
        return timeRemaining;
    }
    return nil;
}

@end
