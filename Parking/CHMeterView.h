//
//  CHMeterView.h
//  Parking
//
//  Created by Charles Hagman on 12/31/11.
//  Copyright (c) 2011 Deloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHGlowLabel.h"

#define METER_DATE_FORMAT @"HH:mm"
#define REMINDER_DATE_FORMAT @"EEE MMM dd 'at\n' hh:mm a"

@interface CHMeterView : UIViewController {
    UIDatePicker *_picker;
    CHGlowLabel *_clockLabel;
    
    NSDateFormatter *_dateFormatter;
    
}

@property (strong, nonatomic) IBOutlet UIDatePicker *picker;
@property (strong, nonatomic) IBOutlet CHGlowLabel *clockLabel;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

-(IBAction)valueDidChange:(id)sender;
-(NSDate *)currentTime;
-(NSInteger)meterTimeInSeconds;

@end
