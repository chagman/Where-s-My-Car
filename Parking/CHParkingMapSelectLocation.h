//
//  CHParkingMapSelectLocation.h
//  Parking
//
//  Created by Charles Hagman on 1/6/12.
//  Copyright (c) 2012 Deloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CHLocationAnnotation.h"

@protocol CHParkingMapSelectLocationDelegate <NSObject>

-(void)setUserPickedLocation:(CLLocationCoordinate2D)coordinate;

@end

@interface CHParkingMapSelectLocation : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate> {
    MKMapView *_mapView;
    CLLocationManager *_locationManager;
    UISegmentedControl *_segmentedControl;
    
    CHLocationAnnotation *_currentSelectedLocation;
    
    __weak id<CHParkingMapSelectLocationDelegate> _delegate;
}

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak) id<CHParkingMapSelectLocationDelegate> delegate;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) CHLocationAnnotation *currentSelectedLocation;

-(IBAction)setLocation;
-(IBAction)changeMapType:(id)sender;

@end
