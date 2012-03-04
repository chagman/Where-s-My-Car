//
//  CHDrawingCommon.m
//  Parking
//
//  Created by Charles Hagman on 1/13/12.
//  Copyright (c) 2012 Deloitte. All rights reserved.
//

#import "CHDrawingCommon.h"

void draw1PxStroke(CGContextRef context, CGPoint startPoint, CGPoint endPoint, 
                   CGColorRef color) {
    drawStroke(context, startPoint, endPoint, 1.0, color);
}

void drawStroke(CGContextRef context, CGPoint startPoint, CGPoint endPoint, CGFloat width,
                CGColorRef color) {
    
    //CGContextMoveToPoint(context, startPoint.x + width/2.0, startPoint.y + width/2.0);
    //CGContextAddLineToPoint(context, endPoint.x + width/2.0, endPoint.y + width/2.0);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
}

void drawRectWithCornerRadius(CGContextRef context, CGRect rect, CGFloat strokeWidth, CGFloat cornerRadius, CGColorRef color) {
    CGFloat x = rect.origin.x;
    CGFloat y = rect.origin.y;
    CGFloat w = rect.size.width;
    CGFloat h = rect.size.height;
    CGFloat r = cornerRadius;
    
    CGContextSaveGState(context);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetStrokeColorWithColor(context, color);
    CGContextSetLineWidth(context, strokeWidth);
    
    //Draw line 1
    drawStroke(context, CGPointMake(x+r, y), CGPointMake(x+w-r, y), strokeWidth, color);
    //draw corner
    CGContextAddArcToPoint(context, x+w, y, x+w, y+r, r);
    
    //Draw line 2   
    drawStroke(context, CGPointMake(x+w, y+r), CGPointMake(x+w, y+h-r), strokeWidth, color);
    //draw corner
    CGContextAddArcToPoint(context, x+w, y + h, x+w-r, y+h, r);
    
    //draw line 3
    drawStroke(context, CGPointMake(x+r, y+h), CGPointMake(x+w-r, y+h), strokeWidth, color);
    //draw corner
    CGContextAddArcToPoint(context, x, y + h, x, y+h-r, r);
    
    //draw line 4
    drawStroke(context, CGPointMake(x, y+r), CGPointMake(x, y+h-r), strokeWidth, color);
    //draw corner
    CGContextAddArcToPoint(context, x, y, x+r, y, r);
    
    //Conect the corners
    CGContextStrokePath(context);
    CGContextRestoreGState(context);  
    //CGContextAddArcToPoint(context, x, y+r, x+r, y, r);
    
    //CGContextAddArcToPoint(context, x, y+r, x+r, y, r);
}

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, 
                        CGColorRef endColor) {
    CGFloat locations[] = { 0.0, 1.0 };
    
    // make a gradient
    CGColorRef colorsRef[] = { startColor, endColor };
    CFArrayRef colors = CFArrayCreate(NULL, (const void**)colorsRef, sizeof(colorsRef) / sizeof(CGColorRef), &kCFTypeArrayCallBacks);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    //  Draw a linear gradient from top to bottom
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, colors, locations);
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    CFRelease(colors);
    
}


@implementation CHDrawingCommon

+(CAGradientLayer *)glossGradientLayerWithFrame:(CGRect)frame opacity:(double)opacity {
    UIColor *glossColor1 = [UIColor colorWithRed:1.0 green:1.0 
                                            blue:1.0 alpha:0.35];
    UIColor *glossColor2 = [UIColor colorWithRed:1.0 green:1.0 
                                            blue:1.0 alpha:0.1];
    
    CAGradientLayer *glossGraident = [CAGradientLayer layer];
    glossGraident.frame = frame;
    glossGraident.colors = [NSArray arrayWithObjects:(id)[glossColor1 CGColor], (id)[glossColor2 CGColor], nil];
    glossGraident.opacity = opacity;
    return glossGraident;
}

@end
