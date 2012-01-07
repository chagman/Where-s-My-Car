//
//  CHParkingMapSelectLocation.h
//  Parking
//
//  Created by Charles Hagman on 1/6/12.
//  Copyright (c) 2012 Deloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol CHParkingMapSelectLocationDelegate <NSObject>

-(void)setUserPickedLocation:(CLLocationCoordinate2D)coordinate;

@end

@interface CHParkingMapSelectLocation : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate> {
    MKMapView *_mapView;
    CLLocationManager *_locationManager;
    
    __weak id<CHParkingMapSelectLocationDelegate> _delegate;
}

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak) id<CHParkingMapSelectLocationDelegate> delegate;

-(IBAction)setLocation;

@end
