//
//  CHParkingMapCell.h
//  Parking
//
//  Created by Charles Hagman on 12/29/11.
//  Copyright (c) 2011 Deloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@protocol CHParkingMapViewCellDelegate <NSObject>

-(void)updateLocation:(CLLocation *)location;
-(void)selectedMap;

@end

@interface CHParkingMapCell : UITableViewCell <MKMapViewDelegate, CLLocationManagerDelegate> {
    
    CLLocationManager *_locationManager;
    MKMapView *_mapView;
    CLLocation *_location;
    BOOL _userDidPickLocation;
    
    __weak id<CHParkingMapViewCellDelegate> _cellDelegate;
}

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocation *location;
@property (weak, nonatomic) id <CHParkingMapViewCellDelegate> cellDelegate;
@property (nonatomic) BOOL userDidPickLocation;

- (void)configureMapViewCell;
- (void)startStandardUpdates;
- (void)stopStandardUpdates;
- (void)moveMapToCoordinate:(CLLocationCoordinate2D)coordinate;
- (void)moveMapToCoordinate:(CLLocationCoordinate2D)coordinate withScale:(float) miles;
- (void)setUserPickedLocation:(CLLocationCoordinate2D)coordinate;

@end
