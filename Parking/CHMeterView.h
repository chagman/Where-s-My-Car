//
//  CHMeterView.h
//  Parking
//
//  Created by Charles Hagman on 12/31/11.
//  Copyright (c) 2011 Deloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHGlowLabel.h"
#import "CHSharedReminderViewController.h"

#define METER_DATE_FORMAT @"HH:mm"
#define REMINDER_DATE_FORMAT @"EEE MMM dd 'at\n' hh:mm a"

@interface CHMeterView : CHSharedReminderViewController {
    UIDatePicker *_picker;
    CHGlowLabel *_clockLabel;
    
    NSDateFormatter *_dateFormatter;
    NSString *_initialTime;
}

@property (strong, nonatomic) IBOutlet UIDatePicker *picker;
@property (strong, nonatomic) IBOutlet CHGlowLabel *clockLabel;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSString *initialTime;

-(IBAction)valueDidChange:(id)sender;
-(NSDate *)currentTime;
-(NSInteger)meterTimeInSeconds;
-(void)setTimeWithString:(NSString *)time;

@end
