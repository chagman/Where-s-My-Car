//
//  CHMapView.h
//  Parking
//
//  Created by Charles Hagman on 12/26/11.
//  Copyright (c) 2011 Deloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CHParkingView.h"

@class CHParkingSpot;
@class CHParkingAnnotation;

#define METERS_PER_MILE 1609.344

@interface CHMapView : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, CHParkingViewDelegate> {
    MKMapView *_mapView;
    CLLocationManager *_locationManager;
    
    CHParkingSpot *_parkingSpot;
    
}

@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CHParkingSpot *parkingSpot;

-(IBAction)moveToUserlocationAndSpot:(id)sender;

@end
