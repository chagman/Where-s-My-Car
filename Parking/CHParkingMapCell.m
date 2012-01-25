//
//  CHParkingMapCell.m
//  Parking
//
//  Created by Charles Hagman on 12/29/11.
//  Copyright (c) 2011 Deloitte. All rights reserved.
//

#import "CHParkingMapCell.h"
#import <CoreLocation/CoreLocation.h>
#import "CHMapView.h"
#import <QuartzCore/QuartzCore.h>
#import "CHLocationAnnotation.h"

@interface CHParkingMapCell() {
    NSDate *_startLocationDate;
}
- (BOOL)isValidLocation:(CLLocation *)newLocation
        withOldLocation:(CLLocation *)oldLocation;
- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer;
@property (strong, nonatomic) NSDate *startLocationDate;

@end

@implementation CHParkingMapCell

@synthesize locationManager=_locationManager, mapView=_mapView, location=_location, cellDelegate=_cellDelegate, startLocationDate=_startLocationDate, userDidPickLocation=_userDidPickLocation;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureMapViewCell {
    self.mapView.delegate = self;
    self.locationManager.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.layer.cornerRadius = 10.0;
    //self.clipsToBounds = YES;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = .1;
    [self.mapView addGestureRecognizer:longPress];
    
    self.userDidPickLocation = (self.location != nil);
    
    if (!self.userDidPickLocation) {
        [self startStandardUpdates];
    } else {
        [self stopStandardUpdates];
        [self moveMapToCoordinate:self.location.coordinate withScale:.15];
    }
}

#pragma mark LocationManagerDelegate Methods

- (void)startStandardUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (nil == _locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.startLocationDate = [[NSDate alloc] init];
    }
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // Set a movement threshold for new events.
    self.locationManager.distanceFilter = 5;
    
    [self.locationManager startUpdatingLocation];
}

- (BOOL)isValidLocation:(CLLocation *)newLocation
        withOldLocation:(CLLocation *)oldLocation
{
    // Filter out nil locations
    if (!newLocation) {
        return NO;
    }
    
    // Filter out points by invalid accuracy
    if (newLocation.horizontalAccuracy < 0) {
        return NO;
    }
    
    // Filter out points that are out of order
    NSTimeInterval secondsSinceLastPoint =
    [newLocation.timestamp timeIntervalSinceDate:oldLocation.timestamp];
    
    if (secondsSinceLastPoint < 0) {
        return NO;
    }
    
    // Filter out points created before the manager was initialized
    NSTimeInterval secondsSinceManagerStarted =
    [newLocation.timestamp timeIntervalSinceDate:self.startLocationDate];
    
    if (secondsSinceManagerStarted < 0) {
        return NO;
    }
    
    // The newLocation is good to use
    return YES;
}

// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    if (![self isValidLocation:newLocation withOldLocation:oldLocation]){
        NSLog(@"Is invalid location.");
        return;
    }
    
    if (oldLocation == nil) {
        [self moveMapToCoordinate:newLocation.coordinate];
    }
    // If it's a relatively recent event, turn off updates to save power
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 5.0 && !self.userDidPickLocation) {
        [self.cellDelegate updateLocation:newLocation];
    }
    // else skip the event and process the next one.
}

- (void)moveMapToCoordinate:(CLLocationCoordinate2D)coordinate {
    [self moveMapToCoordinate:coordinate withScale:0.15];
}

- (void)moveMapToCoordinate:(CLLocationCoordinate2D)coordinate withScale:(float)miles {
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinate, miles*METERS_PER_MILE, miles*METERS_PER_MILE);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];                
    [self.mapView setRegion:adjustedRegion animated:YES];
}

-(void)stopStandardUpdates {
    [self.locationManager stopUpdatingLocation];
}

-(void)setUserPickedLocation:(CLLocationCoordinate2D)coordinate {
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    self.location = location;
    
    //Don't need to waste battery updating location anymore
    [self stopStandardUpdates];
    
    self.userDidPickLocation = YES;
    
    //Remove old current location annontation (if there was one)
    for (NSObject *obj in [self.mapView annotations]) {
        if ([obj class] == [CHLocationAnnotation class]) {
            CHLocationAnnotation *annotation = (CHLocationAnnotation *)obj;
            [self.mapView removeAnnotation:annotation];
        }
    }
    
    CHLocationAnnotation *annotation = [[CHLocationAnnotation alloc] initWithCoordinate:coordinate];
    
    //Add our new location to the map
    [self.mapView addAnnotation:annotation];
    //39.446725301147815, -77.988309552988227
    //CLLocationCoordinate2D locCoor = CLLocationCoordinate2DMake(39.446725301147815, -77.988309552988227);
    //Make sure the map is over the location
    [self moveMapToCoordinate:coordinate withScale:0.15];
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    [self.cellDelegate selectedMap];
}

- (MKAnnotationView *) mapView:(MKMapView *) mapView viewForAnnotation:(id ) annotation {
    if (annotation==self.mapView.userLocation)
        return nil;
    
     MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
     //customPinView.pinColor = MKPinAnnotationColorPurple;
     customPinView.animatesDrop = YES;
     customPinView.canShowCallout = NO;
     //UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
     //[rightButton addTarget:self action:@selector(annotationViewClick:) forControlEvents:UIControlEventTouchUpInside];
     //customPinView.rightCalloutAccessoryView = rightButton;
     return customPinView;
    
}


@end
