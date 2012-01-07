//
//  CHEditTableViewSwitchCell.h
//  Parking
//
//  Created by Charles Hagman on 12/29/11.
//  Copyright (c) 2011 Deloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHEditTableViewCell.h"

@interface CHEditTableViewSwitchCell : CHEditTableViewCell {
    UISwitch *_defaultSwitch;     
}

@property (strong, nonatomic) IBOutlet UISwitch *defaultSwitch;

-(void)toggle:(id)sender;

@end
