//
//  CHCountdownView.m
//  Parking
//
//  Created by Charles Hagman on 1/13/12.
//  Copyright (c) 2012 Deloitte. All rights reserved.
//

#import "CHCountdownView.h"
#import <QuartzCore/QuartzCore.h>
#import "CHDrawingCommon.h"

@implementation CHCountdownView

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
- (void)drawRect:(CGRect)rect {

    UIView *toolbar = [self viewWithTag:10];
    float dividerHeight = (self.frame.size.height + toolbar.bounds.size.height)/3.0;
    
    NSLog(@"Divider Height: %f", dividerHeight);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPoint startPoint = CGPointMake(0, dividerHeight);
    CGPoint endPoint = CGPointMake(320, dividerHeight);
    CGColorRef color = [[UIColor blackColor] CGColor];
    
    // Drawing code
    CGContextSaveGState(context);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetStrokeColorWithColor(context, color);
    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, startPoint.x + 0.5, startPoint.y + 0.5);
    CGContextAddLineToPoint(context, endPoint.x + 0.5, endPoint.y + 0.5);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
    
    // Drawing code
    CGRect gradientRect = CGRectMake(0, 0, self.bounds.size.width, dividerHeight);
    drawLinearGradient(context, gradientRect, [[UIColor lightGrayColor] CGColor], [[UIColor grayColor] CGColor]);

}


@end
