//
//  DetailViewController.h
//  Homepwner
//
//  Created by Long Vinh Nguyen on 1/29/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BNRItem;

@interface DetailViewController : UIViewController
{
    __weak IBOutlet UITextField *nameField;
    __weak IBOutlet UITextField *serialNumberField;
    __weak IBOutlet UITextField *valueField;
    __weak IBOutlet UILabel *dateLabel;
}

@property (nonatomic, strong)BNRItem *item;
- (IBAction)changeDate:(id)sender;
                              

@end

