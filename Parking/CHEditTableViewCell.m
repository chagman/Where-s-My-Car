//
//  CHEditTableViewCell.m
//  Parking
//
//  Created by Charles Hagman on 12/28/11.
//  Copyright (c) 2011 Deloitte. All rights reserved.
//

#import "CHEditTableViewCell.h"

@implementation CHEditTableViewCell

@synthesize label=_label, key=_key, delegate=_delegate, textField=_textField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.textField.delegate =self;
        self.textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)editingDidFinish:(id)sender{
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.key, @"key", self.textField.text, @"value", nil];
    
    //NSDictionary *dict = [NSDictionary dictionaryWithObject:self.textField.text forKey:self.key];
    
    [self.delegate editDidFinish:dict];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.textField) {
        [self editingDidFinish:nil];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.textField) {
        [theTextField resignFirstResponder];
    }
    return YES;
}

@end
