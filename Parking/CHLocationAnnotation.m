//
//  CHLocationAnnotation.m
//  Parking
//
//  Created by Charles Hagman on 1/6/12.
//  Copyright (c) 2012 Deloitte. All rights reserved.
//

#import "CHLocationAnnotation.h"

@implementation CHLocationAnnotation

@synthesize coordinate=_coordinate;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate {
    if ((self = [super init])) {
        _coordinate = coordinate;
    }
    return self;
}


- (NSString *)title {
    return @"Your Location";
}

- (NSString *)subtitle {
    return @"Tap Set to Return";
}

@end
