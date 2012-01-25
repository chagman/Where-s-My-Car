//
//  CHAddCarView.m
//  Parking
//
//  Created by Charles Hagman on 12/28/11.
//  Copyright (c) 2011 Deloitte. All rights reserved.
//

#import "CHAddCarView.h"
#import "CHParkingView.h"
#import "CarManager.h"
#import "CHCar.h"
#import "CHEditTableViewCell.h"

@interface CHAddCarView() {
    UITextField *_textField;
}

@property (strong, nonatomic) UITextField *textField;
-(BOOL)enableSaveButton;
@end

@implementation CHAddCarView

@synthesize attributes=_attributes, labels=_labels, datasource=_datasource, editingRow=_editingRow, delegate=_delegate, car=_car, textField=_textField;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

#pragma mark - tableviewcelldelegate

-(void)editDidFinish:(NSDictionary *)result {
    NSLog(@"delegate called with key %@ and value %@", [result objectForKey:@"key"], [result objectForKey:@"value"]);
    [self.datasource setObject:[result objectForKey:@"value"] forKey:[result objectForKey:@"key"]];
    self.navigationItem.rightBarButtonItem.enabled = [self enableSaveButton];
}

-(void)textFieldBecameFirstResponder:(UITextField *)firstResponder {
    self.textField = firstResponder;
}

#pragma mark - save

- (IBAction)save:(id)sender {
    
    [self.textField resignFirstResponder];
    
    //Create the car
    NSString *make = [self.datasource objectForKey:[self.labels objectAtIndex:0]];
    NSString *model = [self.datasource objectForKey:[self.labels objectAtIndex:1]];
    NSString *year = [self.datasource objectForKey:[self.labels objectAtIndex:2]];
    NSString *color = [self.datasource objectForKey:[self.labels objectAtIndex:3]];
    
    
    if (self.car != nil) {
        self.car.make = make;
        self.car.model = model;
        self.car.year = year;
        self.car.color = color;
        NSError *error = nil;
        if (![self.car.managedObjectContext save:&error]){
            //TODO handle error
        }
        
    } else {
        CHCar *car = [[CarManager sharedCarManager] addCarWithMake:make model:model year:year color:color];
        self.car = car;
    }
    
    [self.delegate addedCar:self.car];
}

-(IBAction)valueChangedinCell:(id)sender {
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.labels = [NSArray arrayWithObjects:@"Make", @"Model", @"Year", @"Color", nil];
    //Create sample data for user to view
    NSArray *exampleAttrs = [NSArray arrayWithObjects:@"e.g. DeLorean", @"e.g. DMC-12", @"1985", @"Gray", nil];
    self.attributes = [NSDictionary dictionaryWithObjects:exampleAttrs forKeys:self.labels];
    
    if (self.car != nil) {
        NSArray *carAttrs = [NSArray arrayWithObjects:self.car.make, self.car.model, self.car.year, self.car.color, nil];
        self.datasource = [NSMutableDictionary dictionaryWithObjects:carAttrs forKeys:self.labels];
    } else {
        NSArray *emptyValues = [NSArray arrayWithObjects:@"", @"", @"", @"", nil];
        self.datasource = [NSMutableDictionary dictionaryWithObjects:emptyValues forKeys:self.labels];
    }
    
    self.navigationItem.title = @"Enter Details";
    self.navigationItem.rightBarButtonItem.enabled = [self enableSaveButton];
    
}

-(BOOL)enableSaveButton {
    
    //TODO fix this to require all the fields to be filled in
    if (self.car != nil) {
        return YES;
    }
    
    NSArray *values = [self.datasource objectsForKeys:self.labels notFoundMarker:@"EMPTY"];
    for (NSString *data in values) {
        if ([data isEqualToString:@""]) {
            return NO;
        }
    }
    return YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.labels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CarInfoCell";
    
    CHEditTableViewCell *cell = (CHEditTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CHEditTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.label.text = [self.labels objectAtIndex:indexPath.row];
    cell.key =  cell.label.text;
    cell.textField.placeholder = [self.attributes objectForKey:cell.key];
    cell.delegate = self;
    cell.maxCharLength = 25;
    if ([cell.key isEqualToString:@"Year"]) {
        cell.maxCharLength = 4;
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    cell.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    
    if (self.car != nil) {
        cell.textField.text = [self.datasource objectForKey:cell.key];
    }
    
    return cell;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected row %d", indexPath.row);
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
