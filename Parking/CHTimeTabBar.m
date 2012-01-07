//
//  CHTimeTabBar.m
//  Parking
//
//  Created by Charles Hagman on 1/3/12.
//  Copyright (c) 2012 Deloitte. All rights reserved.
//

#import "CHTimeTabBar.h"
#import "CHMeterView.h"
#import "CHReminderView.h"
#import "CHGlowLabel.h"

@implementation CHTimeTabBar

@synthesize meterDelegate=_meterDelegate;

-(IBAction)setTime:(id)sender{
    NSLog(@"Did set time");
    
    UIViewController *visableViewController = self.selectedViewController;
    if([CHMeterView class] ==  [visableViewController class]) {
        CHMeterView *meter = (CHMeterView *)visableViewController;
        [self.meterDelegate didPickMeterTimeLimit:meter.meterTimeInSeconds label:meter.clockLabel.text];
    } else if ([CHReminderView class] == [visableViewController class]) {
        CHReminderView *meter = (CHReminderView *)visableViewController;
        [self.meterDelegate didPickTimeLimitWithEndDate:meter.picker.date label:meter.clockLabel.text];
    }
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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

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
