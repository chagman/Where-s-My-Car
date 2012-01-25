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
#import "CHDrawingCommon.h"

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

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UITabBarController *tabBarController = [self tabBarController];
    if (tabBarController != nil) {
        tabBarController.navigationItem.title = @"Date & Time";
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
}

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
    
    if (self.initialDate == nil) {
        self.isReminderOn = YES;
    }
    
    NSDate *date = (self.initialDate != nil) ? self.initialDate : [[NSDate alloc] init];
    self.picker.date = date;
    self.clockLabel.text = [self.dateFormatter stringFromDate:self.picker.date];
    
    [self setUpReminderView];
    
    CGFloat width = self.view.frame.size.width;
    CGFloat height = 367- 216;
    
    NSLog(@"Width: %f, Height: %f", width, height);
    NSLog(@"Width: %f, Height: %f", self.view.frame.size.width, self.view.frame.size.height);
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    CGRect frame = CGRectMake(self.clockLabel.frame.origin.x,self.clockLabel.frame.origin.y, self.clockLabel.frame.size.width, self.clockLabel.frame.size.height);
    gradient.frame = frame;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor darkGrayColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
    gradient.opacity = 1.0;
    gradient.cornerRadius = 10.0;
    
    //CGRect glossFrame = CGRectMake(0,0, self.clockLabel.bounds.size.width, self.clockLabel.bounds.size.height/2.0);
    //CAGradientLayer *glossGradient = [CHDrawingCommon glossGradientLayerWithFrame:glossFrame opacity:.5];
    
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    
    CGRect glossFrame = CGRectMake(0, 0, width, height/2.0);
    CAGradientLayer *glossGradient = [CHDrawingCommon glossGradientLayerWithFrame:glossFrame opacity:.7];
    
    [self.view.layer insertSublayer:glossGradient above:0];
    
    [self.clockLabel setNewGlowColor:[UIColor colorWithRed:0.20 green:0.70 blue:1.0 alpha:1.0]];
    self.clockLabel.glowOffset = CGSizeMake(0.0, 0.0);
    self.clockLabel.glowAmount = 20.0;
    self.clockLabel.layer.cornerRadius = 10.0;
    self.clockLabel.layer.borderWidth = 5.0;
    self.clockLabel.layer.borderColor = [UIColor blackColor].CGColor;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
