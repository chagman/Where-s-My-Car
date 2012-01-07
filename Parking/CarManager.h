//
//  CarManager.h
//  Parking
//
//  Created by Charles Hagman on 12/28/11.
//  Copyright (c) 2011 Deloitte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>

@class CHCar;
@class CHParkingSpot;

#define METER_EXPIRED_KEY @"EXPIRED_NOTIF"
#define SPOT_KEY @"SPOT"

@interface CarManager : NSObject {
    NSFetchedResultsController *_fetchedResultsController;
    NSManagedObjectContext *_managedObjectContext;
}

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

+(CarManager*)sharedCarManager;

//Car Methods
- (CHCar *)addCarWithMake:(NSString *)make model:(NSString *)model year:(NSString *)year color:(NSString *)color;
- (CHCar *)addCarWithMake:(NSString *)make model:(NSString *)model year:(NSString *)year color:(NSString *)color isDefault:(BOOL)defaultCar;
- (CHCar *)getDefaultCar;

//Parking Methods
- (CHParkingSpot *)parkWithCar:(CHCar *)car location:(CLLocation *)location endDate:(NSDate *)endDate;
- (CHParkingSpot *)parkWithCar:(CHCar *)car location:(CLLocation *)location meterLimitInSeconds:(NSInteger)seconds;
- (CHParkingSpot *)parkWithCar:(CHCar *)car location:(CLLocation *)location;
- (CHParkingSpot *)getMostRecentSpot;
- (NSString *) timeRemainingForSpot:(CHParkingSpot *)spot;

@end
