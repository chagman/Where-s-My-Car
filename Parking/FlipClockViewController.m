//
//  FlipClockViewController.m
//  Parking
//
//  Created by Charles Hagman on 1/21/12.
//  Copyright (c) 2012 Deloitte. All rights reserved.
//

#import "FlipClockViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation FlipClockViewController

@synthesize flipLabel=_flipLabel, count=_count;

-(IBAction)buttonPressed:(id)sender {
    
    //NSUInteger options = UIViewAnimationOptionTransitionFlipFromTop;
    
    /*[UIView animateWithDuration:.5 
                          delay:0 
                        options:UIViewAnimationOptionTransitionFlipFromTop 
                     animations:^{
                         NSLog(@"animate");
                         CGRect frame = self.flipLabel.frame;
                         CGRect rect = CGRectMake(frame.origin.x, frame.origin.y + frame.size.height , frame.size.width, frame.size.height);
                         self.flipLabel.frame = rect;
                    } 
                     completion:NULL]; 
    */
    
    
    CATransform3D aTransform = CATransform3DIdentity;
    float zDistance = 1000;
    aTransform.m34 = 2.0 / -zDistance;	
    self.view.layer.sublayerTransform = aTransform;
    
    self.flipLabel.layer.anchorPoint = CGPointMake(0.5, 1.0);
    self.flipLabel.layer.anchorPointZ = .5;
    NSNumber *fromValue = [NSNumber numberWithInt:0];
    NSNumber *toValue = [NSNumber numberWithFloat:-M_PI];
    
    self.flipLabel.layer.transform = CATransform3DMakeRotation(-M_PI, 1, 0, 0);
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.values = [NSArray arrayWithObjects:fromValue, 
                                                 toValue, nil];
    animation.valueFunction = [CAValueFunction functionWithName:kCAValueFunctionRotateX];
    animation.duration = 1.0;
    [self.flipLabel.layer addAnimation:animation forKey:@"transform"];
    
    
    
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

-(void)animationDidStart:(CAAnimation *)anim {
    NSLog(@"Started");
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSLog(@"Stopped");
}

@end
