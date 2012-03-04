//
//  CHDrawingCommon.h
//  Parking
//
//  Created by Charles Hagman on 1/13/12.
//  Copyright (c) 2012 Deloitte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

void draw1PxStroke(CGContextRef context, CGPoint startPoint, CGPoint endPoint, 
                   CGColorRef color);
void drawRectWithCornerRadius(CGContextRef context, CGRect rect, CGFloat strokeWidth, CGFloat cornerRadius, CGColorRef color);
void drawStroke(CGContextRef context, CGPoint startPoint, CGPoint endPoint, CGFloat width,
                CGColorRef color);

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, 
                        CGColorRef endColor);

@interface CHDrawingCommon : NSObject

+(CAGradientLayer *)glossGradientLayerWithFrame:(CGRect)frame opacity:(double)opacity;

@end
