//
//  CHUIMeterView.m
//  Parking
//
//  Created by Charles Hagman on 1/14/12.
//  Copyright (c) 2012 Deloitte. All rights reserved.
//

#import "CHUIMeterView.h"
#import "CHDrawingCommon.h"

static inline double radians (double degrees) { return degrees * M_PI/180; }

@implementation CHUIMeterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Drawing code
    UIView *pickerView = [self viewWithTag:10];
    float pHeight = pickerView.frame.size.height;
    
    CGRect gradientRect = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - pHeight);
    drawLinearGradient(context, gradientRect, [[UIColor lightGrayColor] CGColor], [[UIColor grayColor] CGColor]);
    
    /*
    //Draw around the clock label
    UIView *clockLabel = [self viewWithTag:11];
    CGFloat strokeWidth = 5.0;
    CGRect clockLabelRect = CGRectMake(clockLabel.frame.origin.x - strokeWidth/2.0, 
                                       clockLabel.frame.origin.y - strokeWidth/2.0, 
                                       clockLabel.frame.size.width + strokeWidth, 
                                       clockLabel.frame.size.height + strokeWidth);
    drawRectWithCornerRadius(context, clockLabelRect, strokeWidth, 13.0, [[UIColor blackColor] CGColor]);
    
    //Draw around the reminder label
    UIView *reminderLabel = [self viewWithTag:12];
    CGRect reminderLabelRect = CGRectMake(reminderLabel.frame.origin.x - strokeWidth/2.0, 
                                       reminderLabel.frame.origin.y - strokeWidth/2.0, 
                                       reminderLabel.frame.size.width + strokeWidth, 
                                       reminderLabel.frame.size.height + strokeWidth);
    drawRectWithCornerRadius(context, reminderLabelRect, strokeWidth, 13.0, [[UIColor blackColor] CGColor]);
     */
}



@end
