//
//  CHCar.m
//  Parking
//
//  Created by Charles Hagman on 1/16/12.
//  Copyright (c) 2012 Deloitte. All rights reserved.
//

#import "CHCar.h"
#import "CHParkingSpot.h"


@implementation CHCar

@dynamic color;
@dynamic defaultCar;
@dynamic make;
@dynamic model;
@dynamic nickname;
@dynamic year;
@dynamic spots;

-(NSString *)carLabel {
    return [NSString stringWithFormat:@"%@ %@", self.make, self.model];
}

@end
