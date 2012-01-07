//
//  CHCar.h
//  Parking
//
//  Created by Charles Hagman on 12/28/11.
//  Copyright (c) 2011 Deloitte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CHParkingSpot;

@interface CHCar : NSManagedObject

@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSNumber * defaultCar;
@property (nonatomic, retain) NSString * make;
@property (nonatomic, retain) NSString * model;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSSet *spots;
@end

@interface CHCar (CoreDataGeneratedAccessors)

- (void)addSpotsObject:(CHParkingSpot *)value;
- (void)removeSpotsObject:(CHParkingSpot *)value;
- (void)addSpots:(NSSet *)values;
- (void)removeSpots:(NSSet *)values;

-(NSString *)carLabel;

@end
