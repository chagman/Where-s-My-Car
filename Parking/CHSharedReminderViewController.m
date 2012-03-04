//
//  CHSharedReminderViewController.m
//  Parking
//
//  Created by Charles Hagman on 1/20/12.
//  Copyright (c) 2012 Deloitte. All rights reserved.
//

#import "CHSharedReminderViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation CHSharedReminderViewController

@synthesize onLabel=_onLabel, offLabel=_offLabel, reminderImageView=_reminderImageView, reminderSwitchBkgd=_reminderSwitchBkgd, isReminderOn=_isReminderOn;

-(void)setUpReminderView {
    self.reminderSwitchBkgd.layer.cornerRadius = 10.0;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    CGRect frame = CGRectMake(0,0, self.reminderSwitchBkgd.bounds.size.width, self.reminderSwitchBkgd.bounds.size.height);
    gradient.frame = frame;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor darkGrayColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
    gradient.opacity = 1.0;
    gradient.cornerRadius = 10.0;
    
    //CGRect glossFrame = CGRectMake(0,0, self.reminderSwitchBkgd.bounds.size.width, self.reminderSwitchBkgd.bounds.size.height/2.0);
    //CAGradientLayer *glossGradient = [CHDrawingCommon glossGradientLayerWithFrame:glossFrame opacity:.5];
    
    [self.reminderSwitchBkgd.layer insertSublayer:gradient atIndex:0];
    //[self.reminderSwitchBkgd.layer insertSublayer:glossGradient above:0];
    
    self.onLabel.textColor = [UIColor colorWithRed:0.20 green:0.70 blue:1.0 alpha:1.0];
    self.offLabel.textColor = [UIColor colorWithRed:0.20 green:0.70 blue:1.0 alpha:1.0];
    
    if (self.isReminderOn) {
        self.offLabel.alpha = .4;
        self.onLabel.alpha = 1.0;
        self.reminderImageView.alpha = 1.0;
    } else {
        self.onLabel.alpha = .4;
        self.offLabel.alpha = 1.0;
        self.reminderImageView.alpha = .4;
    }
    
    //Add the gesture recognizer
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleReminder:)];
    tapGesture.numberOfTapsRequired = 1;
    self.reminderSwitchBkgd.userInteractionEnabled = YES;
    [self.reminderSwitchBkgd addGestureRecognizer:tapGesture];
    
    self.reminderSwitchBkgd.layer.cornerRadius = 10.0;
    self.reminderSwitchBkgd.layer.borderWidth = 5.0;
    self.reminderSwitchBkgd.layer.borderColor = [UIColor blackColor].CGColor;
}


-(void)toggleReminder:(UIGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
        return;
    }
    
    BOOL reminder = self.isReminderOn;
    self.isReminderOn = !self.isReminderOn;
    [UIView animateWithDuration:.5 
                     animations:^{
                         if (reminder) {
                             //was on, turn it off
                             self.onLabel.alpha = 0.4;
                             self.offLabel.alpha = 1.0;
                             self.reminderImageView.alpha = 0.4;
                         } else {
                             //was off, turn it on
                             self.onLabel.alpha = 1.0;
                             self.offLabel.alpha = 0.4;
                             self.reminderImageView.alpha = 1.0;
                         }
                     }];
}


@end
