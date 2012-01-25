//
//  CHParkingView.h
//  Parking
//
//  Created by Charles Hagman on 12/27/11.
//  Copyright (c) 2011 Deloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHCarPickerView.h"
#import "CHParkingMapCell.h"
#import "CHTimeTabBar.h"
#import <CoreLocation/CoreLocation.h>
#import "CHParkingMapSelectLocation.h"
#import "CHEditTableViewCell.h"

@class CHCar;
@class CHParkingSpot;

@protocol CHParkingViewDelegate <NSObject>

-(void) addParkingSpotToMap:(CHParkingSpot *)parkingSpot;

@end

@interface CHParkingView : UITableViewController <CHCarPickerDelegate, CHParkingMapViewCellDelegate, CHMeterViewDelegate, CHParkingMapSelectLocationDelegate, CHEditTableViewCellDelegate> {
    
    NSArray *_parkingAttrs;
    NSArray *_locationAttrs;
    NSArray *_dataSource;
    
    CHCar *_car;
    CHParkingSpot *_spot;
    CLLocation *_location;
    
    NSDate *_endDate;
    
    NSInteger _timeLimit;
    NSString *_notes;
    
    BOOL _shouldScheduleReminder;
    
    __weak id<CHParkingViewDelegate> _parkingDelegate;
}

@property (strong, nonatomic) NSArray *parkingAttrs;
@property (strong, nonatomic) NSArray *locationAttrs;
@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) CHCar *car;
@property (strong, nonatomic) CHParkingSpot *spot;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;
@property (nonatomic) NSInteger timeLimit;
@property (strong, nonatomic) NSString *notes;
@property (nonatomic) BOOL shouldScheduleReminder;

@property (weak) id<CHParkingViewDelegate> parkingDelegate;

-(IBAction)cancel:(id)sender;
-(IBAction)done:(id)sender;

@end
