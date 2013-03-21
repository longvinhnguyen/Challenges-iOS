//
//  DatePickerViewController.m
//  Homepwner
//
//  Created by Long Vinh Nguyen on 1/30/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import "DatePickerViewController.h"
#import "BNRItem.h"

@implementation DatePickerViewController
@synthesize item;

- (id)init
{
    self = [super init];
    if (self) {
        [[self navigationItem] setTitle:@"DatePicker"];
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    NSDate *dp = [datePicker date];
    [[self item] setDateCreated:dp];
}


@end
