//
//  CHEditTableViewSwitchCell.m
//  Parking
//
//  Created by Charles Hagman on 12/29/11.
//  Copyright (c) 2011 Deloitte. All rights reserved.
//

#import "CHEditTableViewSwitchCell.h"

@implementation CHEditTableViewSwitchCell

@synthesize defaultSwitch=_defaultSwitch;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)toggle:(id)sender{
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.key, @"key", self.defaultSwitch.isOn, @"value", nil];
    
    //NSDictionary *dict = [NSDictionary dictionaryWithObject:self.textField.text forKey:self.key];
    
    [self.delegate editDidFinish:dict];
}

@end
