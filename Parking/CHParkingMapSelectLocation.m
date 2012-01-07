//
//  CHParkingMapSelectLocation.m
//  Parking
//
//  Created by Charles Hagman on 1/6/12.
//  Copyright (c) 2012 Deloitte. All rights reserved.
//

#import "CHParkingMapSelectLocation.h"
#import "CHMapView.h"
#import "CHLocationAnnotation.h"

@interface CHParkingMapSelectLocation() {
    NSDate *_startLocationDate;
    CHLocationAnnotation *_currentSelectedLocation;
    
}
- (BOOL)isValidLocation:(CLLocation *)newLocation
        withOldLocation:(CLLocation *)oldLocation;
- (void)handleTap:(UIGestureRecognizer *)gestureRecognizer;

@property (strong, nonatomic) NSDate *startLocationDate;
@property (strong, nonatomic) CHLocationAnnotation *currentSelectedLocation;

@end

@implementation CHParkingMapSelectLocation

@synthesize mapView=_mapView, locationManager=_locationManager, startLocationDate=_startLocationDate, currentSelectedLocation=_currentSelectedLocation, delegate=_delegate;

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
        // 2
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
        // 3
        MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];                
        // 4
        [self.mapView setRegion:adjustedRegion animated:NO];
        
    }
    // If it's a relatively recent event, turn off updates to save power
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0)
    {
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              newLocation.coordinate.latitude,
              newLocation.coordinate.longitude);
    }
    // else skip the event and process the next one.
}

-(void)stopStandardUpdates {
    [self.locationManager stopUpdatingLocation];
}

- (void)handleTap:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];   
    CLLocationCoordinate2D touchMapCoordinate = 
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    CHLocationAnnotation *annot = [[CHLocationAnnotation alloc] initWithCoordinate:touchMapCoordinate];
    
    [self.mapView removeAnnotation:self.currentSelectedLocation];
    
    [self.mapView addAnnotation:annot];
    self.currentSelectedLocation = annot;
    
    [self stopStandardUpdates];
}

-(void)setLocation {
    [self.delegate setUserPickedLocation:self.currentSelectedLocation.coordinate];
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    self.locationManager.delegate = self;
    
    self.mapView.showsUserLocation = YES;
    self.mapView.zoomEnabled = YES;
    self.mapView.scrollEnabled = YES;
    
    [self startStandardUpdates];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] 
                                          initWithTarget:self action:@selector(handleTap:)];
    longPress.minimumPressDuration = .125;
    [self.mapView addGestureRecognizer:longPress];

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

@end
