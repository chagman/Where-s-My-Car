//
//  CHGlowLabel.m
//  Parking
//
//  Created by Charles Hagman on 1/7/12.
//  Copyright (c) 2012 Deloitte. All rights reserved.
//

#import "CHGlowLabel.h"

@interface CHGlowLabel()
- (void)initialize;
@end

@implementation CHGlowLabel

@synthesize glowColor, glowOffset, glowAmount;

- (void)setNewGlowColor:(UIColor *)newGlowColor {
    if (newGlowColor != _glowColor) {
        CGColorRelease(_glowColorRef);
        self.glowColor = newGlowColor;
        _glowColorRef = CGColorCreate(_colorSpaceRef, CGColorGetComponents(self.glowColor.CGColor));
    }
}

- (void)initialize {
    _colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    
    self.glowOffset = CGSizeMake(0.0, 0.0);
    self.glowAmount = 0.0;
    self.glowColor = [UIColor clearColor];
}

- (void)awakeFromNib {
    [self initialize];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self != nil) {
        [self initialize];
    }
    return self;
}

-(void)clearGlow {
    self.glowOffset = CGSizeMake(0.0, 0.0);
    self.glowAmount = 0.0;
    self.glowColor = [UIColor clearColor];
}

- (void)drawTextInRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextSetShadow(context, self.glowOffset, self.glowAmount);
    CGContextSetShadowWithColor(context, self.glowOffset, self.glowAmount, _glowColorRef);
    
    [super drawTextInRect:rect];
    
    CGContextRestoreGState(context);
}



- (void)dealloc {
    CGColorRelease(_glowColorRef);
    CGColorSpaceRelease(_colorSpaceRef);
}

@end
