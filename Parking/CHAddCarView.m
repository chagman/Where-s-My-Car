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

@implementation CHAddCarView

@synthesize attributes=_attributes, labels=_labels, datasource=_datasource, editingRow=_editingRow, delegate=_delegate;

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
}

#pragma mark - save

- (IBAction)save:(id)sender {
    
    //Create the car
    NSString *make = [self.datasource objectForKey:[self.labels objectAtIndex:0]];
    NSString *model = [self.datasource objectForKey:[self.labels objectAtIndex:1]];
    NSString *year = [self.datasource objectForKey:[self.labels objectAtIndex:2]];
    NSString *color = [self.datasource objectForKey:[self.labels objectAtIndex:3]];
    
    CHCar *car = [[CarManager sharedCarManager] addCarWithMake:make model:model year:year color:color];
    [self.delegate addedCar:car];
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
    
    NSArray *emptyValues = [NSArray arrayWithObjects:@"", @"", @"", @"", nil];
    self.datasource = [NSMutableDictionary dictionaryWithObjects:emptyValues forKeys:self.labels];
    
    self.navigationItem.title = @"Enter Details";
    
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
    if ([cell.key isEqualToString:@"Year"]) {
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
