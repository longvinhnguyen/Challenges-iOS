//
//  HomepwnerItemCellWithStepperCell.m
//  Homepwner
//
//  Created by Long Vinh Nguyen on 2/28/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import "HomepwnerItemCellWithStepper.h"

@implementation HomepwnerItemCellWithStepper

@synthesize valueStepper;

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


- (IBAction)showImage:(id)sender {
    [self forwardAction:_cmd fromSender:sender];
}

- (IBAction)changeValue:(UIStepper *)sender {
    [self forwardAction:_cmd fromSender:sender];
}

@end
