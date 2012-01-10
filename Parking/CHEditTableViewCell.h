//
//  CHEditTableViewCell.h
//  Parking
//
//  Created by Charles Hagman on 12/28/11.
//  Copyright (c) 2011 Deloitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CHEditTableViewCellDelegate <NSObject>

-(void)editDidFinish:(NSDictionary *)result;

@optional  
// and the other one is optional (this function has not been used in this tutorial)  
- (void)editStarted:(UITextField *)field;

@end

@interface CHEditTableViewCell : UITableViewCell <UITextFieldDelegate> {
    UITextField *_textField;  
    __weak id <CHEditTableViewCellDelegate> _delegate;
    UILabel *_label;
    NSString *_key; 
}

@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) id <CHEditTableViewCellDelegate> delegate;
@property (copy, nonatomic) NSString *key;

-(IBAction)editingDidFinish:(id)sender;


@end
