//
//  FlipClockViewController.h
//  Parking
//
//  Created by Charles Hagman on 1/21/12.
//  Copyright (c) 2012 Deloitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlipClockViewController : UIViewController  {
    UILabel *_flipLabel;
    NSInteger _count;
}

@property (nonatomic, strong) IBOutlet UILabel *flipLabel;
@property (nonatomic) NSInteger count;

-(IBAction)buttonPressed:(id)sender;

@end
