//
//  CHMeterView.m
//  Parking
//
//  Created by Charles Hagman on 12/31/11.
//  Copyright (c) 2011 Deloitte. All rights reserved.
//

#import "CHMeterView.h"
#import <QuartzCore/QuartzCore.h>
#import "CHGlowLabel.h"

@interface CHMeterView()
-(void)didSetTime;
@end

@implementation CHMeterView

@synthesize picker=_picker, clockLabel=_clockLabel, dateFormatter=_dateFormatter;


-(IBAction)valueDidChange:(id)sender {
    NSLog(@"Value changed");
    
    //df.dateStyle = NSDateFormatterShortStyle;
    self.clockLabel.text = [self.dateFormatter stringFromDate:self.picker.date];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterFullStyle];
    
    NSLog(@"%@", [df stringFromDate:self.picker.date]);
    NSLog(@"Time since 1970: %d", [self meterTimeInSeconds]);
	
}

-(NSDate *)currentTime {
    return [self.dateFormatter dateFromString:self.clockLabel.text];
}

-(NSInteger)meterTimeInSeconds {
    //NSTimeInterval interval = [self.picker.date timeIntervalSince1970];
    //return [NSNumber numberWithDouble:interval];
    
    NSDateFormatter *hourFmt = [[NSDateFormatter alloc] init];
    [hourFmt setDateFormat:@"H"];
    
    NSDateFormatter *minFmt = [[NSDateFormatter alloc] init];
    [minFmt setDateFormat:@"m"];
    
    NSString *h = [hourFmt stringFromDate:self.picker.date];
    NSString *m = [minFmt stringFromDate:self.picker.date];
    
    NSInteger hours = [h integerValue];
    NSInteger mins = [m integerValue];
    
    return hours*60*60 + mins*60;
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


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    /*if(![self.navigationController isNavigationBarHidden]) {
        self.navigationController.navigationBar.hidden = YES;
    }*/
}

-(void)viewDidDisappear:(BOOL)animated {
    /*if([self.navigationController isNavigationBarHidden]) {
        self.navigationController.navigationBar.hidden = NO;
    }*/
    
    [super viewDidDisappear:animated];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:METER_DATE_FORMAT];
    
    self.clockLabel.text = @"02:00";
    self.picker.date = [self.dateFormatter dateFromString:self.clockLabel.text];
    
    //UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    CGRect frame = CGRectMake(0,0, self.clockLabel.bounds.size.width, self.clockLabel.bounds.size.height);
    gradient.frame = frame;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
    gradient.opacity = .3;
    
    [self.view.layer insertSublayer:gradient above:0];
    //[self.clockLabel.layer insertSublayer:gradient atIndex:0];
    
    //Set the label properties and glow params
    //self.clockLabel.textColor = ;
    [self.clockLabel setNewGlowColor:[UIColor colorWithRed:0.20 green:0.70 blue:1.0 alpha:1.0]];
    self.clockLabel.glowOffset = CGSizeMake(0.0, 0.0);
    self.clockLabel.glowAmount = 20.0;
    
    
    //self.navigationItem.;
}


-(void)didSetTime {
    NSLog(@"Set time");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
