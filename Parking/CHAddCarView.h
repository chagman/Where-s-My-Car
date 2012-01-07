//
//  CHAddCarView.h
//  Parking
//
//  Created by Charles Hagman on 12/28/11.
//  Copyright (c) 2011 Deloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHEditTableViewCell.h"

@class CHCar;

@protocol CHAddCarViewDelegate <NSObject>

- (void)addedCar:(CHCar *)car;

@end

@interface CHAddCarView : UITableViewController <CHEditTableViewCellDelegate>{
    NSDictionary *_attributes;
    NSArray *_labels;
    NSMutableDictionary *_datasource;
    
    NSNumber *_editingRow;
    
    __weak id<CHAddCarViewDelegate> _delegate;
}

@property (strong, nonatomic) NSDictionary *attributes;
@property (strong, nonatomic) NSArray *labels;
@property (strong, nonatomic) NSMutableDictionary *datasource;
@property (strong, nonatomic) NSNumber *editingRow;
@property (weak) id<CHAddCarViewDelegate> delegate;

-(IBAction)save:(id)sender;
-(IBAction)valueChangedinCell:(id)sender;

@end
