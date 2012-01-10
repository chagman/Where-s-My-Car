//
//  CHReminderView.m
//  Parking
//
//  Created by Charles Hagman on 12/31/11.
//  Copyright (c) 2011 Deloitte. All rights reserved.
//

#import "CHReminderView.h"
#import "CHMeterView.h"
#import <QuartzCore/QuartzCore.h>

@implementation CHReminderView

@synthesize picker=_picker, clockLabel=_clockLabel, dateFormatter=_dateFormatter, initialDate=_initialDate;

-(IBAction)valueDidChange:(id)sender {
    NSLog(@"Value changed!");
    
    self.initialDate = self.picker.date;
    //df.dateStyle = NSDateFormatterShortStyle;
    self.clockLabel.text = [self.dateFormatter stringFromDate:self.picker.date];
	
}

-(NSDate *)currentTime {
    return [self.dateFormatter dateFromString:self.clockLabel.text];
}

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

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:REMINDER_DATE_FORMAT];
    
    NSDate *date = (self.initialDate != nil) ? self.initialDate : [[NSDate alloc] init];
    self.picker.date = date;
    self.clockLabel.text = [self.dateFormatter stringFromDate:self.picker.date];
    
    //UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    CGRect frame = CGRectMake(0,0, self.clockLabel.bounds.size.width, self.clockLabel.bounds.size.height);
    gradient.frame = frame;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
    gradient.opacity = .3;
    
    [self.view.layer insertSublayer:gradient above:0];
    [self.clockLabel setNewGlowColor:[UIColor colorWithRed:0.20 green:0.70 blue:1.0 alpha:1.0]];
    self.clockLabel.glowOffset = CGSizeMake(0.0, 0.0);
    self.clockLabel.glowAmount = 20.0;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
