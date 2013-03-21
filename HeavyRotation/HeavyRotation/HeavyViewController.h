//
//  HeavyViewController.h
//  HeavyRotation
//
//  Created by Long Vinh Nguyen on 1/27/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeavyViewController : UIViewController
{
    IBOutlet UIImageView *imageView;
    IBOutlet UIButton *leftButton;
    IBOutlet UIButton *rightButton;
    IBOutlet UIButton *goldButton;
    IBOutlet UISlider *topSlider;
    CGPoint originalPoint;
}

@end
