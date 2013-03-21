//
//  DatePickerViewController.h
//  Homepwner
//
//  Created by Long Vinh Nguyen on 1/30/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BNRItem;

@interface DatePickerViewController : UIViewController
{
    IBOutlet UIDatePicker *datePicker;
}

@property (nonatomic, strong)BNRItem *item;

@end
