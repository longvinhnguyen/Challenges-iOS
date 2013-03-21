//
//  HomepwnerItemCellWithStepperCell.h
//  Homepwner
//
//  Created by Long Vinh Nguyen on 2/28/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomepwnerItemBaseCell.h"

@interface HomepwnerItemCellWithStepper : HomepwnerItemBaseCell



@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIStepper *valueStepper;


- (IBAction)showImage:(id)sender;
- (IBAction)changeValue:(UIStepper *)sender;

@end
