//
//  CHCar.m
//  Parking
//
//  Created by Charles Hagman on 12/28/11.
//  Copyright (c) 2011 Deloitte. All rights reserved.
//

#import "CHCar.h"
#import "CHParkingSpot.h"


@implementation CHCar

@dynamic color;
@dynamic defaultCar;
@dynamic make;
@dynamic model;
@dynamic nickname;
@dynamic spots;

-(NSString *)carLabel {
    return [NSString stringWithFormat:@"%@ %@", self.make, self.model];
}

@end
