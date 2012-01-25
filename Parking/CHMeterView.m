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
#import "CHDrawingCommon.h"

@interface CHMeterView()
-(void)didSetTime;
-(void)setUpClockLabel;
@end

@implementation CHMeterView

@synthesize picker=_picker, clockLabel=_clockLabel, dateFormatter=_dateFormatter, initialTime=_initialTime;


-(IBAction)valueDidChange:(id)sender {
    NSLog(@"Value changed");
    
    //df.dateStyle = NSDateFormatterShortStyle;
    self.clockLabel.text = [self.dateFormatter stringFromDate:self.picker.date];
    self.initialTime = self.clockLabel.text;
    
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
    
    UITabBarController *tabBarController = [self tabBarController];
    if (tabBarController != nil) {
        tabBarController.navigationItem.title = @"Meter";
    }
    
    if (self.isReminderOn) {
        self.offLabel.alpha = .4;
        self.onLabel.alpha = 1.0;
        self.reminderImageView.alpha = 1.0;
    } else {
        self.onLabel.alpha = .4;
        self.offLabel.alpha = 1.0;
        self.reminderImageView.alpha = .4;
    }
    
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
    
    if (self.dateFormatter == nil) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:METER_DATE_FORMAT];
    }
    
    if (self.initialTime == nil) {
        self.isReminderOn = YES;
    }
    //self.clockLabel.textColor = [UIColor colorWithRed:0.20 green:0.70 blue:1.0 alpha:.8];
    
    [self setUpClockLabel];
    [self setUpReminderView];
   
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height - self.picker.frame.size.height;
    
    NSLog(@"Width: %f, Height: %f", width, height);
    NSLog(@"Width: %f, Height: %f", self.view.frame.size.width, self.view.frame.size.height);
    
    CAGradientLayer *silverGradient = [CAGradientLayer layer];
    CGRect silverFrame = CGRectMake(0,0, 320, 367- 216);
    
    silverGradient.frame = silverFrame;
    silverGradient.colors = [NSArray arrayWithObjects:(id)[[UIColor darkGrayColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
    silverGradient.opacity = 1.0;
    
    CGRect glossFrame = CGRectMake(silverFrame.origin.x, silverFrame.origin.x, silverFrame.size.width, silverFrame.size.height/2.0);
    CAGradientLayer *glossGradient = [CHDrawingCommon glossGradientLayerWithFrame:glossFrame opacity:.7];
    
    [self.view.layer insertSublayer:glossGradient above:0];
    //[self.view.layer insertSublayer:silverGradient atIndex:0];
    
}

-(void)setTimeWithString:(NSString *)time {
    self.clockLabel.text = time; 
    self.picker.date = [self.dateFormatter dateFromString:self.clockLabel.text];
}

-(void)setUpClockLabel {
    NSString *label = (self.initialTime != nil) ? self.initialTime : @"02:00";
    self.clockLabel.text = label;
    self.picker.date = [self.dateFormatter dateFromString:self.clockLabel.text];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    CGRect frame = CGRectMake(self.clockLabel.frame.origin.x,self.clockLabel.frame.origin.y, self.clockLabel.frame.size.width, self.clockLabel.frame.size.height);
    gradient.frame = frame;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor darkGrayColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
    gradient.opacity = 1.0;
    gradient.cornerRadius = 10.0;
    
    //CGRect glossFrame = CGRectMake(0,0, self.clockLabel.bounds.size.width, self.clockLabel.bounds.size.height/2.0);
    //CAGradientLayer *glossGradient = [CHDrawingCommon glossGradientLayerWithFrame:glossFrame opacity:.5];
    
    [self.view.layer insertSublayer:gradient atIndex:0];
    //[self.clockLabel.layer insertSublayer:glossGradient above:0];
    
    [self.clockLabel setNewGlowColor:[UIColor colorWithRed:0.20 green:0.70 blue:1.0 alpha:1.0]];
    self.clockLabel.glowOffset = CGSizeMake(0.0, 0.0);
    self.clockLabel.glowAmount = 20.0;
    self.clockLabel.layer.cornerRadius = 10.0;
    self.clockLabel.layer.borderWidth = 5.0;
    self.clockLabel.layer.borderColor = [UIColor blackColor].CGColor;
       

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
