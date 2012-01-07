//
//  CHParkingView.m
//  Parking
//
//  Created by Charles Hagman on 12/27/11.
//  Copyright (c) 2011 Deloitte. All rights reserved.
//

#import "CHParkingView.h"
#import "CHCarPickerView.h"
#import "CHCar.h"
#import "CHParkingMapCell.h"
#import "CarManager.h"
#import <CoreLocation/CoreLocation.h>
#import "CHMeterView.h"
#import "CHLocationAnnotation.h"


@interface CHParkingView () {
    NSString *_timeLabel;
}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@property (strong, nonatomic) NSString *timeLabel;

@end

@implementation CHParkingView

@synthesize parkingAttrs=_parkingAttrs, dataSource=_dataSource, locationAttrs=_locationAttrs, car=_car, spot=_spot, location=_location, parkingDelegate=_parkingDelegate;
@synthesize startDate=_startDate, endDate=_endDate, timeLimit=_timeLimit, timeLabel=_timeLabel;

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

#pragma mark - MapView methods

-(void)updateLocation:(CLLocation *)location {
    self.location = location;
    NSLog(@"New location: latitude %+.6f, longitude %+.6f\n",
          location.coordinate.latitude,
          location.coordinate.longitude);
}

#pragma mark - transistion methods

-(IBAction)done:(id)sender {
    
    if (self.car == nil) {
        //TODO handle error
    } else if (self.location == nil) {
        //TODO handle error
    } else {
        CHParkingSpot *spot;
        if (self.endDate != nil) {
            spot = [[CarManager sharedCarManager] parkWithCar:self.car location:self.location endDate:self.endDate];
        } else if (self.timeLimit > 0){
            spot = [[CarManager sharedCarManager] parkWithCar:self.car location:self.location meterLimitInSeconds:self.timeLimit];
        } else if ([self.timeLabel isEqualToString:@"None"]) {
            spot = [[CarManager sharedCarManager] parkWithCar:self.car location:self.location]; 
        }
        [self.parkingDelegate addParkingSpotToMap:spot];
    }
}

-(IBAction)cancel:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"selectedRow"]) {
        CHCarPickerView *picker = (CHCarPickerView *)[segue destinationViewController];
        picker.carDelegate = self;
    } else if ([[segue identifier] isEqualToString:@"timerSelected"]) {
        CHTimeTabBar *tabBar = (CHTimeTabBar *)[segue destinationViewController];
        tabBar.meterDelegate = self;
    } else if ([[segue identifier] isEqualToString:@"tapMapView"]) { 
        CHParkingMapSelectLocation *view = (CHParkingMapSelectLocation *)[segue destinationViewController];
        view.delegate = self;
    } else {
        NSLog(@"Segue with identifier:%@ called", [segue identifier]);
    }
}

-(void)didPickCar:(CHCar *)car {
    if (self.car != car) {
        self.car = car;
        
        NSArray *path = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
        [[self tableView] reloadRowsAtIndexPaths:path withRowAnimation:UITableViewRowAnimationNone];
    }
    [[self navigationController] popToRootViewControllerAnimated:YES];
}

-(void)didPickTimeLimitWithEndDate:(NSDate *)endDate label:(NSString *)label{
    NSLog(@"Time limit is set!");
    
    self.endDate = endDate;
    self.timeLabel = label;
    
    //clear the time limit
    self.timeLimit = 0;
    
    NSArray *path = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]];
    [[self tableView] reloadRowsAtIndexPaths:path withRowAnimation:UITableViewRowAnimationNone];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)didPickMeterTimeLimit:(NSInteger)meterTime label:(NSString *)label{
    NSLog(@"Meter limit is set!");
    self.timeLimit = meterTime;
    self.timeLabel = label;
    
    //clear the end date
    self.endDate = nil;
    
    NSArray *path = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]];
    [[self tableView] reloadRowsAtIndexPaths:path withRowAnimation:UITableViewRowAnimationNone];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)selectedMap {
    //NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:1];
    //[self.tableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self performSegueWithIdentifier: @"tapMapView" 
                              sender: self];
}

- (void)setUserPickedLocation:(CLLocationCoordinate2D)coordinate {
    //Set our new location
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [self updateLocation:location];
    
    //TODO create member variable initiated during viewDidLoad to handle where cells are
    NSArray *paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]];
    [[self tableView] reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationNone];
    
    //dismiss view
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - tableView methods

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.dataSource objectAtIndex:section] count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *MapCellIdentifier = @"MapViewCell";
    static NSString *TimerCellIdentifier = @"TimerCell";
    
    UITableViewCell *cell = nil;
    if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:MapCellIdentifier];
    } else {
        if (indexPath.row == 0) {
            cell = cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        } else {
            cell = cell = [tableView dequeueReusableCellWithIdentifier:TimerCellIdentifier];
        }
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    NSLog(@"Getting row %d of sections %d", indexPath.row, indexPath.section);
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSString *label = (NSString *)[[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        if (indexPath.row == 0) {
            cell.textLabel.text = label;
            if (self.car != nil) {
                cell.detailTextLabel.text = self.car.carLabel;
            } else {
                cell.detailTextLabel.text = @"Pick a Car";
            }
        } else if (indexPath.row == 1) { //TIME LIMIT
            UILabel *label = (UILabel *)[cell viewWithTag:1];
            label.text = self.timeLabel;
            
            //cell.detailTextLabel.text = self.timeLabel;
        }
    }
    
    if (indexPath.section == 1) {
        ((CHParkingMapCell *)cell).cellDelegate = self;
        [((CHParkingMapCell *)cell) configureMapViewCell];
        
        if (self.location != nil) {
            //Get our map cell, tell it to add the pin
            [((CHParkingMapCell *)cell) setUserPickedLocation:self.location.coordinate];
        }
        
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	if(section == 0)
		return @"Parking Spot";
	else
		return @"Location";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 ) {
        return 200.0;
    } else {
        return 44.0;
    }
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
    
    self.parkingAttrs = [NSArray arrayWithObjects:@"Car", @"Time Limit", nil];
    self.locationAttrs = [NSArray arrayWithObjects:@"Location", nil];
    self.dataSource = [NSArray arrayWithObjects:self.parkingAttrs, self.locationAttrs, nil];
    
    self.navigationItem.title = @"Your Spot";
    self.tableView.delegate = self;
    
    self.timeLabel = @"None";

    self.car = [[CarManager sharedCarManager] getDefaultCar];
    
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
