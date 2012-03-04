//
//  CHSharedReminderViewController.h
//  Parking
//
//  Created by Charles Hagman on 1/20/12.
//  Copyright (c) 2012 Deloitte. All rights reserved. 
//

#import <UIKit/UIKit.h>
#import "CHGlowLabel.h"

@interface CHSharedReminderViewController : UIViewController {
    CHGlowLabel *_onLabel;
    CHGlowLabel *_offLabel;
    UIImageView *_reminderImageView;
    UILabel *_reminderSwitchBkgd;
    
    BOOL _isReminderOn;

}

@property (strong, nonatomic) IBOutlet CHGlowLabel *onLabel;
@property (strong, nonatomic) IBOutlet CHGlowLabel *offLabel;
@property (strong, nonatomic) IBOutlet UIImageView *reminderImageView;
@property (strong, nonatomic) IBOutlet UILabel *reminderSwitchBkgd;
@property (nonatomic) BOOL isReminderOn;

-(void)setUpReminderView;
-(void)toggleReminder:(UIGestureRecognizer *)gestureRecognizer;

@end
