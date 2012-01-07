//
//  CHTimeTabBar.h
//  Parking
//
//  Created by Charles Hagman on 1/3/12.
//  Copyright (c) 2012 Deloitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CHMeterViewDelegate <NSObject>

-(void)didPickTimeLimitWithEndDate:(NSDate *)endDate label:(NSString *)label;
-(void)didPickMeterTimeLimit:(NSInteger)meterTime label:(NSString *)label;

@end

@interface CHTimeTabBar : UITabBarController {
    __weak id<CHMeterViewDelegate> _meterDelegate;
}

@property (weak) id<CHMeterViewDelegate> meterDelegate;
-(IBAction)setTime:(id)sender;

@end
