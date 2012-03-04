//
//  CHCountdownViewController.h
//  Parking
//
//  Created by Charles Hagman on 1/11/12.
//  Copyright (c) 2012 Deloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHGlowLabel.h"

#define SECONDS_PER_DAY 86400
#define SECONDS_PER_HOUR 3600
#define SECONDS_PER_MINUTE 60
#define MINUTES_PER_HOUR 60
#define METER_CLOCK_QUEUE "com.charleshagman.clock"

@interface CHCountdownViewController : UIViewController <UIScrollViewDelegate>{
    CHGlowLabel *_timeLabel;
    CHGlowLabel *_colon;
    NSInteger _timeRemaining;
    
    CHGlowLabel *_onLabel;
    CHGlowLabel *_offLabel;
    
    UILabel *_onOffBackground;
    
    UIImageView *_reminderIconView;
    
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
}

@property (strong, nonatomic) IBOutlet CHGlowLabel *timeLabel;
@property (strong, nonatomic) IBOutlet CHGlowLabel *colon;
@property (nonatomic) NSInteger timeRemaining;
@property (strong, nonatomic) IBOutlet CHGlowLabel *onLabel;
@property (strong, nonatomic) IBOutlet CHGlowLabel *offLabel;
@property (strong, nonatomic) IBOutlet UIImageView *reminderIconView;
@property (strong, nonatomic) IBOutlet UILabel *onOffBackground;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

-(void)startTimer;
-(void)stopTimer;
-(IBAction)backToMap:(id)sender;

@end
