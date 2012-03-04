//
//  CHCountdownViewController.m
//  Parking
//
//  Created by Charles Hagman on 1/11/12.
//  Copyright (c) 2012 Deloitte. All rights reserved.
//

#import "CHCountdownViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CHDrawingCommon.h"

@interface CHCountdownViewController() {
    
    BOOL _isRunningTimer;
    BOOL _isReminderOn;
    dispatch_queue_t _clock;
    
    //Variable that sets how many minutes to switch to counting down seconds
    NSInteger _countdownTimeInMinutes;
    
    UIColor *_glowColor;
    UIColor *_onTextColor;
    UIColor *_offTextColor;
}

@property (nonatomic) BOOL isRunningTimer;
@property (nonatomic) BOOL isReminderOn;
@property (nonatomic) NSInteger countdownTimeInMinutes;
@property (nonatomic, strong) UIColor *glowColor;
@property (nonatomic, strong) UIColor *onTextColor;
@property (nonatomic, strong) UIColor *offTextColor;

-(void)updateTime;
-(void)runTimer;
-(NSString *)textForTimeLabel;
-(void)blinkColonWithSecondsLeft:(NSInteger)seconds shouldStop:(BOOL)stop;
-(double)toggleColonAlpha;
-(void)setUpGlowLabels;
-(void)setUpGradients;
-(void)setUpReminderViews;
-(void)toggleReminder;
-(void)addGlowToLabel:(CHGlowLabel *)label withRadius:(double)glowAmount;
-(void)removeGlowFromLabel:(CHGlowLabel *)label;
-(void)addGestureRecognizers;
-(void)handleTap:(UIGestureRecognizer *)gestureRecognizer;
-(void)setUpScrollView;
-(void)updatePageNumber;


@end

@implementation CHCountdownViewController

@synthesize timeLabel=_timeLabel, colon=_colon, timeRemaining=_timeRemaining, isRunningTimer=_isRunningTimer, countdownTimeInMinutes=_countdownTimeInMinutes, onLabel=_onLabel, offLabel=_offLabel, reminderIconView=_reminderIconView, onOffBackground=_onOffBackground, glowColor=_glowColor, onTextColor=_onTextColor, offTextColor=_offTextColor, isReminderOn=_isReminderOn;

@synthesize scrollView=_scrollView, pageControl=_pageControl;

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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set the initial time
    self.timeRemaining = 609;
    self.countdownTimeInMinutes = 10;
    self.onOffBackground.layer.cornerRadius = 10.0;
    self.glowColor = [UIColor colorWithRed:0.20 green:0.70 blue:1.0 alpha:1.0];
    self.onTextColor = self.glowColor;
    self.offTextColor = [UIColor colorWithRed:0.20 green:0.70 blue:1.0 alpha:1.0];
    self.isReminderOn = YES;
    
    self.timeLabel.text = [self textForTimeLabel];
    
    [self setUpGlowLabels];
    [self setUpGradients];
    [self addGestureRecognizers];
    [self setUpReminderViews];
    [self setUpScrollView];
    
    [self updatePageNumber];
     
}

-(void)setUpScrollView {
    
    float width = self.scrollView.bounds.size.width;
    float height = self.scrollView.bounds.size.height;
    
    CGSize scrollViewContentSize = CGSizeMake(width*2, height);
    self.scrollView.contentSize = scrollViewContentSize;
    
    CGRect rectTwo = CGRectMake(width + 5, 5, 100, 50);
    UILabel *pageTwo = [[UILabel alloc] initWithFrame:rectTwo];
    pageTwo.text = @"Page 2";
    pageTwo.backgroundColor = [UIColor clearColor];
    
    [self.scrollView addSubview:pageTwo];
    self.scrollView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    [self startTimer];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    
    [self stopTimer];
}

-(void)startTimer {
    
    if (self.isRunningTimer) {
        return;
    }
    
    dispatch_queue_t clock_queue = dispatch_queue_create(METER_CLOCK_QUEUE, NULL);
    dispatch_retain(clock_queue);
    _clock = clock_queue;
    
    [self runTimer];    

}

-(void)runTimer {
    
    if (self.timeRemaining > 0) {
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, _clock, ^(void){
            
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self updateTime];
                if (self.timeRemaining%2 == 0 && self.timeRemaining >= (SECONDS_PER_MINUTE*self.countdownTimeInMinutes - 2)) {
                    //only blink the seconds if we're not counting down seconds
                     BOOL stop = (self.timeRemaining < SECONDS_PER_MINUTE*self.countdownTimeInMinutes);
                    [self blinkColonWithSecondsLeft:self.timeRemaining shouldStop:stop];
                }
            });
            
            self.timeRemaining = self.timeRemaining - 1;
            [self runTimer];
        });
    } else {
        
    }
}

-(void)stopTimer {
    dispatch_suspend(_clock);
    dispatch_release(_clock);
    self.isRunningTimer = NO;
    
}

-(NSString *)textForTimeLabel {
    NSInteger hours = self.timeRemaining/SECONDS_PER_HOUR;
    NSInteger mins = (((self.timeRemaining)/SECONDS_PER_MINUTE)%MINUTES_PER_HOUR);
    NSInteger secs = self.timeRemaining%SECONDS_PER_MINUTE;
    
    if (hours == 0 && mins < self.countdownTimeInMinutes)
        return [NSString stringWithFormat:@"%02d %02d",mins, secs];
    else {
        return [NSString stringWithFormat:@"%02d %02d", hours, mins];
    }
}

/*
-(NSString *)textForSecondsLabel {
    return [NSString stringWithFormat:@"%02d", (self.timeRemaining%SECONDS_PER_MINUTE)];
}*/


-(void)updateTime {
    self.timeLabel.text = [self textForTimeLabel];
}

-(double)toggleColonAlpha {
    if (self.colon.alpha == 0.0) {
        return 1.0;
    } else {
        return 0.0;
    }
}

-(void)blinkColonWithSecondsLeft:(NSInteger)seconds shouldStop:(BOOL)stop {
    [UIView animateWithDuration:1.0
                     animations:^{
                         if (stop && self.colon.alpha != 1.0) {
                             self.colon.alpha = 1.0;
                         } else if (!stop) {
                             self.colon.alpha = [self toggleColonAlpha];
                         }
                     }];
    
}

-(void)setUpGlowLabels {
    //Set the label properties and glow params
    [self addGlowToLabel:self.timeLabel withRadius:20.0];
    [self addGlowToLabel:self.colon withRadius:20.0];
    [self addGlowToLabel:self.onLabel withRadius:10.0];
    
    self.timeLabel.layer.cornerRadius = 10.0;
    self.onLabel.textColor = self.glowColor;
    self.offLabel.textColor = self.offTextColor;
}

-(void)setUpGradients {
    
    //Gloss for clock
    CGRect timerGlossFrame = CGRectMake(0,0, self.timeLabel.bounds.size.width, self.timeLabel.bounds.size.height/2.0);
    CAGradientLayer *timerGloss = [CHDrawingCommon glossGradientLayerWithFrame:timerGlossFrame opacity:.5];
    
    //Gloss for onOff
    CGRect onOffFrame = CGRectMake(0, 0, self.onOffBackground.bounds.size.width, self.onOffBackground.bounds.size.height/2.0);
    CAGradientLayer *onOffGradient = [CHDrawingCommon glossGradientLayerWithFrame:onOffFrame opacity:.5];

    [self.timeLabel.layer insertSublayer:timerGloss above:0];
    [self.onOffBackground.layer insertSublayer:onOffGradient above:0];
    
}

-(void)setUpReminderViews {
    if (self.isReminderOn) {
        self.onLabel.alpha =1.0;
        self.offLabel.alpha = 0.4;
        self.reminderIconView.alpha = 1.0;
    } else {
        self.onLabel.alpha = 0.4;
        self.offLabel.alpha = 1.0;
        self.reminderIconView.alpha = 0.4;
    }
    
}

-(void)addGestureRecognizers {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGesture.numberOfTapsRequired = 1;
    [self.onOffBackground addGestureRecognizer:tapGesture];
}

-(void)toggleReminder {
    [UIView animateWithDuration:.5 
                     animations:^{
                         if (self.isReminderOn) {
                             self.isReminderOn = NO;
                             [self removeGlowFromLabel:self.onLabel];
                             [self addGlowToLabel:self.offLabel withRadius:10.0];
                             self.reminderIconView.alpha = 0.4;
                         } else {
                             self.isReminderOn = YES;
                             [self removeGlowFromLabel:self.offLabel];
                             [self addGlowToLabel:self.onLabel withRadius:10.0];
                             self.reminderIconView.alpha = 1.0;
                         }
                     }];
}

-(void)handleTap:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self toggleReminder];
    }
}

-(void)addGlowToLabel:(CHGlowLabel *)label withRadius:(double)glowAmount{
    label.alpha = 1.0;
}

-(void)removeGlowFromLabel:(CHGlowLabel *)label {
    label.alpha = .4;
}

-(IBAction)backToMap:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

-(void)updatePageNumber {
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    [self updatePageNumber];
}

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

-(void)dealloc {
    //make sure it has stopped
    dispatch_suspend(_clock);
    dispatch_release(_clock);
}

@end
