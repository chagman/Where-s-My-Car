//
//  CHGlowLabel.h
//  Parking
//
//  Created by Charles Hagman on 1/7/12.
//  Copyright (c) 2012 Deloitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHGlowLabel : UILabel {

    CGSize _glowOffset;
    UIColor *_glowColor;
    CGFloat _glowAmount;

    CGColorSpaceRef _colorSpaceRef;
    CGColorRef _glowColorRef;
}

@property (nonatomic, assign) CGSize glowOffset;
@property (nonatomic, assign) CGFloat glowAmount;
@property (nonatomic, retain) UIColor *glowColor;

- (void)setNewGlowColor:(UIColor *)newGlowColor;
//Removes the glow from the label
- (void)clearGlow;

@end
