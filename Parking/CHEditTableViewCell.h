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
-(void)textFieldBecameFirstResponder:(UITextField *)firstResponder;

@end

@interface CHEditTableViewCell : UITableViewCell <UITextFieldDelegate> {
    UITextField *_textField;  
    __weak id <CHEditTableViewCellDelegate> _delegate;
    UILabel *_label;
    NSString *_key;
    
    NSInteger _maxCharLength;
}

@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) id <CHEditTableViewCellDelegate> delegate;
@property (copy, nonatomic) NSString *key;
@property (nonatomic) NSInteger maxCharLength;

-(IBAction)editingDidFinish:(id)sender;


@end
