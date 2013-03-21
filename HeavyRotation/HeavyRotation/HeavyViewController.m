//
//  HeavyViewController.m
//  HeavyRotation
//
//  Created by Long Vinh Nguyen on 1/27/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import "HeavyViewController.h"


@implementation HeavyViewController

-(void)viewDidLoad
{
    originalPoint = goldButton.center;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        NSLog(@"In WillAutoRotate");
        
        // Silver Challenge: Programmatically Setting Autoresizing Masks
        [topSlider setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth];
        [leftButton setAutoresizingMask: UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin];
        [rightButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin];
        [imageView setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        
        
        // Gold Challenge: Overriding Autorotation
        
        
        CGPoint landScapePoint;
        landScapePoint.x = [[self view] bounds].size.width - originalPoint.x;
        landScapePoint.y = [[self view] bounds].size.height - ([[UIScreen mainScreen] bounds].size.height - originalPoint.y);
        
        [goldButton setCenter:landScapePoint];
    }
    
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        [goldButton setCenter:originalPoint];
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}


@end
