//
//  CHCarPickerView.h
//  Parking
//
//  Created by Charles Hagman on 12/27/11.
//  Copyright (c) 2011 Deloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CHAddCarView.h"

@class CHCar;

@protocol CHCarPickerDelegate 

-(void)didPickCar:(CHCar *)car;

@end

@interface CHCarPickerView : UITableViewController <NSFetchedResultsControllerDelegate, CHAddCarViewDelegate> {
    __weak id <CHCarPickerDelegate> _carDelegate;
}

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) id <CHCarPickerDelegate> carDelegate;

-(IBAction)saveCarChoice:(id)sender;
-(IBAction)popView:(id)sender;

@end
