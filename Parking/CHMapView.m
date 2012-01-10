//
//  CHMapView.m
//  Parking
//
//  Created by Charles Hagman on 12/26/11.
//  Copyright (c) 2011 Deloitte. All rights reserved.
//

#import "CHMapView.h"
#import "CHParkingAnnotation.h"
#import "CHCar.h"
#import "CHParkingSpot.h"
#import "CarManager.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface CHMapView()
-(void)startStandardUpdates;
-(MKCoordinateRegion)regionThatFitsSpotAndUserLocation;
@end

@implementation CHMapView

@synthesize mapView=_mapView, locationManager=_locationManager, parkingSpot=_parkingSpot;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma make - MapViewDelegate

- (MKAnnotationView *) mapView:(MKMapView *) mapView viewForAnnotation:(id ) annotation {
    NSLog(@"View for annotation called");
    
    if (annotation==self.mapView.userLocation)
        return nil;
      
    MKAnnotationView *customAnnotationView=[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    //Set the pin image
    UIImage *pinImage = [UIImage imageNamed:@"meterPin.png"];
	[customAnnotationView setImage:pinImage];
    customAnnotationView.canShowCallout = YES;
    //Set the icon in the callout
    UIImageView *leftIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"whiteCar.png"]];
	customAnnotationView.leftCalloutAccessoryView = leftIconView;
	customAnnotationView.centerOffset = CGPointMake(0, -27);
    return customAnnotationView;

    
}

- (IBAction) annotationViewClick:(id) sender {
    NSLog(@"clicked");
}

-(IBAction)moveToUserlocationAndSpot:(id)sender{
    MKCoordinateRegion region = [self regionThatFitsSpotAndUserLocation];
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:region];                
    [self.mapView setRegion:adjustedRegion animated:YES];
}

-(MKCoordinateRegion)regionThatFitsSpotAndUserLocation {

    CLLocationCoordinate2D southWest = self.parkingSpot.location;
    CLLocationCoordinate2D northEast = southWest;
    
    CLLocation *userLocation = self.mapView.userLocation.location;
    if (userLocation == nil && self.parkingSpot != nil) {
        NSLog(@"UserLocation is null");
        return MKCoordinateRegionMakeWithDistance(self.parkingSpot.location, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);     
    }
    
    if (userLocation != nil && self.parkingSpot == nil) {
        return MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.coordinate, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);     
    }
    
    southWest.latitude = MIN(southWest.latitude, userLocation.coordinate.latitude);
    southWest.longitude = MIN(southWest.longitude, userLocation.coordinate.longitude);
    
    northEast.latitude = MAX(northEast.latitude, userLocation.coordinate.latitude);
    northEast.longitude = MAX(northEast.longitude, userLocation.coordinate.longitude);
    
    CLLocation *locSouthWest = [[CLLocation alloc] initWithLatitude:southWest.latitude longitude:southWest.longitude];
    CLLocation *locNorthEast = [[CLLocation alloc] initWithLatitude:northEast.latitude longitude:northEast.longitude];
    
    MKCoordinateRegion region;
    region.center.latitude = (southWest.latitude + northEast.latitude) / 2.0;
    region.center.longitude = (southWest.longitude + northEast.longitude) / 2.0;
    
    region.span.latitudeDelta = fabs(northEast.latitude - southWest.latitude) * 1.1; 
    region.span.longitudeDelta = fabs(northEast.longitude - southWest.longitude) * 1.1;
    
    return region;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self.mapView setDelegate:self];
	self.mapView.showsUserLocation = YES;
    
    [self startStandardUpdates];
    
    // 1
    CLLocationCoordinate2D zoomLocation;
    CHParkingAnnotation *parkingAnnotation;
    
    CHParkingSpot *spot = [[CarManager sharedCarManager] getMostRecentSpot];
    MKCoordinateRegion region;
    
    if (spot == nil && 
        self.mapView.userLocation.coordinate.latitude == 0 && 
        self.mapView.userLocation.coordinate.longitude == 0) {
        return;
    }
    
    self.parkingSpot = spot;
    if (spot == nil) {
        zoomLocation = self.mapView.userLocation.coordinate;
        region = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    } else {
        zoomLocation = spot.location;
        parkingAnnotation = [[CHParkingAnnotation alloc] initWithParkingSpot:spot];
        if(self.mapView.userLocation != nil) {
            region = [self regionThatFitsSpotAndUserLocation];
        } else {
            region = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
        }
        //region = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    }
    
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:region];                
    [self.mapView setRegion:adjustedRegion animated:YES];
    //self.mapView se
    [self.mapView addAnnotation:parkingAnnotation];
   
}

-(void)addParkingSpotToMap:(CHParkingSpot *)parkingSpot {
    
    if (parkingSpot == nil) {
        return;
    }
    
    self.parkingSpot = parkingSpot;
    
    NSArray *annotations = self.mapView.annotations;
    
    for (NSObject *obj in annotations) {
        if ([obj class] == [CHParkingAnnotation class]) {
            CHParkingAnnotation *pAnnotation = (CHParkingAnnotation *)obj;
            [self.mapView removeAnnotation:pAnnotation];
        }
    }
    
    CHParkingAnnotation *parkingAnnotation = [[CHParkingAnnotation alloc] initWithParkingSpot:parkingSpot];
    MKCoordinateRegion viewRegion = [self regionThatFitsSpotAndUserLocation];
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];                
    
    [self.mapView setRegion:adjustedRegion animated:YES];
    [self.mapView addAnnotation:parkingAnnotation];
    [self dismissModalViewControllerAnimated:YES];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"modalPark"]) {
        NSLog(@"Destination controller %@", [[segue destinationViewController] class] );
        NSLog(@"Destination top controller %@", [[[segue destinationViewController] topViewController] class] );
        CHParkingView *view = (CHParkingView *)[[segue destinationViewController] topViewController];
        view.parkingDelegate = self;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark User Location Methods

- (void)startStandardUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (nil == _locationManager)
        self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    // Set a movement threshold for new events.
    self.locationManager.distanceFilter = 500;
    
    [self.locationManager startUpdatingLocation];
}

// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    if (oldLocation == nil) {
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
        MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:region];                
        [self.mapView setRegion:adjustedRegion animated:YES];
        
    }
    
    // If it's a relatively recent event, turn off updates to save power
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              newLocation.coordinate.latitude,
              newLocation.coordinate.longitude);
        
    }
    // else skip the event and process the next one.
}

@end
