//
//  CHReminderView.h
//  Parking
//
//  Created by Charles Hagman on 12/31/11.
//  Copyright (c) 2011 Deloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHGlowLabel.h"
#import "CHSharedReminderViewController.h"

@interface CHReminderView : CHSharedReminderViewController {

    UIDatePicker *_picker;
    CHGlowLabel *_clockLabel;

    NSDateFormatter *_dateFormatter;
    NSDate *_initialDate;

}

@property (strong, nonatomic) IBOutlet UIDatePicker *picker;
@property (strong, nonatomic) IBOutlet CHGlowLabel *clockLabel;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDate *initialDate;



-(IBAction)valueDidChange:(id)sender;
-(NSDate *)currentTime;

@end
