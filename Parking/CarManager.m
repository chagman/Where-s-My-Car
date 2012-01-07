//
//  CarManager.m
//  Parking
//
//  Created by Charles Hagman on 12/28/11.
//  Copyright (c) 2011 Deloitte. All rights reserved.
//

#import "CarManager.h"
#import "CHCar.h"
#import "CHParkingSpot.h"
#import "AppDelegate.h"

@interface CarManager()
-(void)scheduleNotificationForSpot:(CHParkingSpot *)spot interval:(int)minutesBefore;
- (void)cancelNotificationsAssociatedWithCar:(CHCar *)car;
@end

@implementation CarManager 

@synthesize fetchedResultsController=_fetchedResultsController, managedObjectContext=_managedObjectContext;

static CarManager *sharedCarManagerInstance = nil;

-(CHCar *)addCarWithMake:(NSString *)make model:(NSString *)model year:(NSString *)year color:(NSString *)color {
    
    NSManagedObjectContext *context = [[CarManager sharedCarManager] managedObjectContext];
    
    CHCar *car = (CHCar *)[NSEntityDescription insertNewObjectForEntityForName:@"CHCar" inManagedObjectContext:context];
    car.make = make;
    car.model = model;
    car.color = color;
    car.defaultCar = [NSNumber numberWithBool:YES];
    
    // Commit the change.
    NSError *error = nil;
    if (![context save:&error]) {
        //TODO Handle the error.
    }
    return car;
}

-(CHCar *)addCarWithMake:(NSString *)make model:(NSString *)model year:(NSString *)year color:(NSString *)color isDefault:(BOOL)defaultCar {
    
    NSManagedObjectContext *context = [[CarManager sharedCarManager] managedObjectContext];
    
    CHCar *car = (CHCar *)[NSEntityDescription insertNewObjectForEntityForName:@"CHCar" inManagedObjectContext:context];
    car.make = make;
    car.model = model;
    car.color = color;
    
    //TODO make sure there are no other default cars
    car.defaultCar = [NSNumber numberWithBool:defaultCar];
    
    // Commit the change.
    NSError *error = nil;
    if (![context save:&error]) {
        //TODO Handle the error.
    }
    return car;
}

-(CHParkingSpot *)parkWithCar:(CHCar *)car location:(CLLocation *)location {
    NSManagedObjectContext *context = self.managedObjectContext;
    CHParkingSpot *spot = (CHParkingSpot *)[NSEntityDescription insertNewObjectForEntityForName:@"CHParkingSpot" inManagedObjectContext:context];
    spot.car = car;
    spot.latitude = [NSNumber numberWithDouble:location.coordinate.latitude];
    spot.longitude = [NSNumber numberWithDouble:location.coordinate.longitude];
    spot.startDate = [[NSDate alloc] init];
    
    NSError *error = nil;
    if (![context save:&error]){
        //TODO handle error
    }
    return spot;
}


-(CHParkingSpot *)parkWithCar:(CHCar *)car location:(CLLocation *)location endDate:(NSDate *)endDate {
    NSManagedObjectContext *context = self.managedObjectContext;
    CHParkingSpot *spot = (CHParkingSpot *)[NSEntityDescription insertNewObjectForEntityForName:@"CHParkingSpot" inManagedObjectContext:context];
    spot.car = car;
    spot.latitude = [NSNumber numberWithDouble:location.coordinate.latitude];
    spot.longitude = [NSNumber numberWithDouble:location.coordinate.longitude];
    spot.startDate = [[NSDate alloc] init];
    spot.endDate = endDate;
    
    [self scheduleNotificationForSpot:spot interval:15];
    
    NSError *error = nil;
    if (![context save:&error]){
        //TODO handle error
    }
    return spot;
}

-(CHParkingSpot *)parkWithCar:(CHCar *)car location:(CLLocation *)location meterLimitInSeconds:(NSInteger)seconds {
    NSManagedObjectContext *context = self.managedObjectContext;
    CHParkingSpot *spot = (CHParkingSpot *)[NSEntityDescription insertNewObjectForEntityForName:@"CHParkingSpot" inManagedObjectContext:context];
    spot.car = car;
    spot.latitude = [NSNumber numberWithDouble:location.coordinate.latitude];
    spot.longitude = [NSNumber numberWithDouble:location.coordinate.longitude];
    spot.startDate = [[NSDate alloc] init];
    spot.endDate = [spot.startDate dateByAddingTimeInterval:seconds];
    spot.timeLimit = [NSNumber numberWithInteger:seconds];
    
    [self scheduleNotificationForSpot:spot interval:15];
    
    NSError *error = nil;
    if (![context save:&error]){
        //TODO handle error
    }
    return spot;
}

-(CHParkingSpot *)getMostRecentSpot {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"CHParkingSpot" 
                                                         inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    // Set example predicate and sort orderings...
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"startDate" ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [request setFetchLimit:1];
    
    NSError *error = nil;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (array == nil || ([array count] < 1)) {
        return nil;
    }
    
    return (CHParkingSpot*)[array objectAtIndex:0];
}

-(CHCar *)getDefaultCar {
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"CHCar" 
                                                         inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *testForTrue = [NSPredicate predicateWithFormat:@"defaultCar == YES"];
    [request setPredicate:testForTrue];
    
    // Set example predicate and sort orderings...
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"model" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [request setFetchLimit:1];
    
    NSError *error = nil;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (array == nil || ([array count] < 1)) {
        NSLog(@"No default car found");
        return nil;
    }
    
    return (CHCar *)[array objectAtIndex:0];
    
}

- (NSString *)timeRemainingForSpot:(CHParkingSpot *)spot {
    if (spot.endDate == nil) {
        return @" ";
    }
    
    NSDate *now = [[NSDate alloc] init];
    
    if ([now compare:spot.endDate] != NSOrderedAscending) {
        return @"Expired";
    }
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
	NSUInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    
	NSDateComponents *components = [gregorian components:unitFlags
											    fromDate:now
												  toDate:spot.endDate options:0];
    
	NSString *dateDesc = nil;
	
    //NSLog(@"M: %d, W: %d, D: %d, h: %d, m:%d", [components month], [components week], [components day], [components hour], [components minute]);
    
	if ([components month] > 0) {
        dateDesc = [NSString stringWithFormat:@"%dM", [components month]];
    } else if ([components week]>0) {
        dateDesc = [NSString stringWithFormat:@"%dW", [components week]];
    } else if ([components day] >0) {
        dateDesc = [NSString stringWithFormat:@"%dd", [components day]];
    } else if ([components hour] > 0 || [components minute] > 0) {
        dateDesc = [NSString stringWithFormat:@"%d h and %d min remaining", [components hour], [components minute]];
    } else {
        dateDesc = [NSString stringWithFormat:@"%dm", [components minute]];
    }
    
    return dateDesc;

}

- (void)scheduleNotificationForSpot:(CHParkingSpot *)spot interval:(int)minutesBefore {
    /*NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setDay:item.day];
    [dateComps setMonth:item.month];
    [dateComps setYear:item.year];
    [dateComps setHour:item.hour];
    [dateComps setMinute:item.minute];
    NSDate *itemDate = [calendar dateFromComponents:dateComps];
    */
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    
    //Cancel notifications associated to this car
    [self cancelNotificationsAssociatedWithCar:spot.car];
    
    //Schedule new notification
    localNotif.fireDate = [spot.endDate dateByAddingTimeInterval:-(minutesBefore*60)];
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    localNotif.alertBody = [NSString stringWithFormat:NSLocalizedString(@"Meter runs out in %i minutes.", nil), minutesBefore];
    localNotif.alertAction = NSLocalizedString(@"Add Time", nil);
    //localNotif.alertLaunchImage = @"meter.png";
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    //localNotif.applicationIconBadgeNumber = 1;
    
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:spot.car.carLabel forKey:METER_EXPIRED_KEY];
    localNotif.userInfo = infoDict;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    
    //[[UIApplication sharedApplication] presentLocalNotificationNow:localNotif];
}

- (void)cancelNotificationsAssociatedWithCar:(CHCar *)car {
    for(UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        NSString *notifCar = (NSString *)[notification.userInfo objectForKey:METER_EXPIRED_KEY];
        
        if([notifCar isEqualToString:car.carLabel]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
}

+ (CarManager *)sharedCarManager {
    if (sharedCarManagerInstance != nil) {
		return sharedCarManagerInstance;
	}
	
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{ sharedCarManagerInstance = [[self alloc] init]; });
    
    return sharedCarManagerInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedCarManagerInstance == nil) {
            sharedCarManagerInstance = [super allocWithZone:zone];
            return sharedCarManagerInstance;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}


- (id)copyWithZone:(NSZone *)zone {
    return self;
}

// setup the data collection
- init {
	if (self = [super init]) {
        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        self.managedObjectContext = [delegate managedObjectContext];
	}
	return self;
}


@end
