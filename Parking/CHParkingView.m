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
#import "CHReminderView.h"


@interface CHParkingView () {
    NSString *_timeLabel;
    BOOL _reminderSet;
    BOOL _userSetLocation;
    
    NSString *_NOTES_KEY;
    
    UITextField *_textField;
}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)toggleParkButton;
- (NSString *)labelForTimeCell;
- (BOOL)calendarReminderIsSet;
- (BOOL)meterIsSet;

@property (strong, nonatomic) NSString *timeLabel;
@property (nonatomic) BOOL reminderSet;
@property (strong, nonatomic) NSString *NOTES_KEY;
@property (nonatomic) BOOL userSetLocation;
@property (nonatomic, strong) UITextField *textField;

@end

@implementation CHParkingView

@synthesize parkingAttrs=_parkingAttrs, dataSource=_dataSource, locationAttrs=_locationAttrs, car=_car, spot=_spot, location=_location, parkingDelegate=_parkingDelegate, reminderSet=_reminderSet, notes=_notes, NOTES_KEY=_NOTES_KEY;

@synthesize startDate=_startDate, endDate=_endDate, timeLimit=_timeLimit, timeLabel=_timeLabel, userSetLocation=_userSetLocation, shouldScheduleReminder=_shouldScheduleReminder, textField=_textField;

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
    //If the user has not set their location
    if (!self.userSetLocation) {
        self.location = location;
        [self toggleParkButton];
    }

}

#pragma mark - transistion methods

-(IBAction)done:(id)sender {
    
    if (self.textField != nil) {
        [self.textField resignFirstResponder];
    }
    
    if (self.car == nil) {
        //TODO handle error
    } else if (self.location == nil) {
        //TODO handle error
    } else {
        CHParkingSpot *spot;
        if ([self calendarReminderIsSet]) {
            spot = [[CarManager sharedCarManager] parkWithCar:self.car location:self.location endDate:self.endDate notes:self.notes reminder:self.reminderSet];
        } else if ([self meterIsSet]){
            spot = [[CarManager sharedCarManager] parkWithCar:self.car location:self.location meterLimitInSeconds:self.timeLimit notes:self.notes reminder:self.reminderSet];
        } else {
            spot = [[CarManager sharedCarManager] parkWithCar:self.car location:self.location notes:self.notes reminder:self.reminderSet]; 
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
        
        if ([self meterIsSet]) {
            CHMeterView *meterView = (CHMeterView *)[tabBar.viewControllers objectAtIndex:0];
            meterView.initialTime = self.timeLabel;
            meterView.isReminderOn = self.reminderSet;
            tabBar.selectedViewController = meterView;
        } else if ([self calendarReminderIsSet]) {
            CHReminderView *reminderView = (CHReminderView *)[tabBar.viewControllers objectAtIndex:1];
            reminderView.initialDate = self.endDate;
            tabBar.selectedViewController = reminderView;
            reminderView.isReminderOn = self.reminderSet;
        }
               
    } else if ([[segue identifier] isEqualToString:@"tapMapView"]) { 
        CHParkingMapSelectLocation *view = (CHParkingMapSelectLocation *)[segue destinationViewController];
        view.delegate = self;
        if (self.userSetLocation && self.location != nil) {
            view.currentSelectedLocation = [[CHLocationAnnotation alloc] initWithCoordinate:self.location.coordinate];
        }
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

-(void)didPickTimeLimitWithEndDate:(NSDate *)endDate label:(NSString *)label reminder:(BOOL)isSet{
    self.reminderSet = isSet;
    self.endDate = endDate;
    self.timeLabel = label;
    
    //clear the time limit
    self.timeLimit = 0;
    
    NSArray *path = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]];
    [[self tableView] reloadRowsAtIndexPaths:path withRowAnimation:UITableViewRowAnimationNone];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)didPickMeterTimeLimit:(NSInteger)meterTime label:(NSString *)label reminder:(BOOL)isSet{
    self.timeLimit = meterTime;
    self.timeLabel = label;
    self.reminderSet = isSet;
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
    self.userSetLocation = YES;
    //Set our new location
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    self.location = location;
    [self toggleParkButton];
        
    //TODO create member variable initiated during viewDidLoad to handle where cells are
    NSArray *paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]];
    [[self tableView] reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationNone];
    
    //dismiss view
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)editDidFinish:(NSDictionary *)result {
    NSString *key = (NSString*)[result objectForKey:@"key"];
    if ([key isEqualToString:self.NOTES_KEY]){
        NSString *notes = (NSString *)[result objectForKey:@"value"];
        self.notes = notes;
    }
}

-(void)textFieldBecameFirstResponder:(UITextField *)firstResponder{
    self.textField = firstResponder;
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
    static NSString *NotesCellIdentifier = @"NotesCell";
    
    UITableViewCell *cell = nil;
    if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:MapCellIdentifier];
    } else {
        if (indexPath.row == 0) {
            cell = cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        } else if (indexPath.row == 1) {
            cell = cell = [tableView dequeueReusableCellWithIdentifier:TimerCellIdentifier];
        } else if (indexPath.row == 2) {
            cell = [tableView dequeueReusableCellWithIdentifier:NotesCellIdentifier];
        }
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSString *labelText = (NSString *)[[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
                
        if (indexPath.row == 0) {
            cell.textLabel.text = labelText;
            if (self.car != nil) {
                cell.detailTextLabel.text = self.car.carLabel;
            } else {
                cell.detailTextLabel.text = @"Pick a Car";
            }
        } else if (indexPath.row == 1) { //TIME LIMIT
            UILabel *label = (UILabel *)[cell viewWithTag:1];
            label.text = [self labelForTimeCell];
            UIImageView *imageView = (UIImageView *)[cell viewWithTag:3];
            imageView.hidden = !self.reminderSet;
            //cell.detailTextLabel.text = self.timeLabel;
        } else if (indexPath.row == 2) {
            //don't do anything yet
            CHEditTableViewCell *chCell = (CHEditTableViewCell *)cell;
            //chCelll.label.text = NOTES_LABEL;
            chCell.key = self.NOTES_KEY;
            chCell.delegate = self;
            chCell.textField.text = self.notes;
            chCell.textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            chCell.maxCharLength = 25;
        }
    }
    
    if (indexPath.section == 1) {
        CHParkingMapCell *mapCell = (CHParkingMapCell *)cell;
        mapCell.cellDelegate = self;
        mapCell.userDidPickLocation = self.userSetLocation;
        
        [mapCell configureMapViewCell];
        
        if (self.location != nil && self.userSetLocation) {
            //Get our map cell, tell it to add the pin
            [((CHParkingMapCell *)cell) setUserPickedLocation:self.location.coordinate];
            
        }
        
    }
}

-(NSString *)labelForTimeCell {
    if (self.endDate != nil) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"EEE MM/dd 'at' HH:mm"];
        return [df stringFromDate:self.endDate];
    } else {
        return self.timeLabel;
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
        return 180.0;
    } else {
        return 44.0;
    }
}

- (void) toggleParkButton {
    UIBarButtonItem *parkButton = self.navigationItem.rightBarButtonItem;
    parkButton.enabled = (self.car != nil && self.location != nil);
}
             
-(BOOL) meterIsSet {
    return self.timeLimit > 0;
}

-(BOOL) calendarReminderIsSet {
    return self.endDate != nil;
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
    
    self.parkingAttrs = [NSArray arrayWithObjects:@"Car", @"Time Limit", @"Notes", nil];
    self.locationAttrs = [NSArray arrayWithObjects:@"Location", nil];
    self.dataSource = [NSArray arrayWithObjects:self.parkingAttrs, self.locationAttrs, nil];
    
    self.navigationItem.title = @"Your Spot";
    self.tableView.delegate = self;
    
    self.timeLabel = @"None";
    self.reminderSet = NO;

    self.car = [[CarManager sharedCarManager] getDefaultCar];
    self.NOTES_KEY = @"Notes";
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self toggleParkButton];
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
