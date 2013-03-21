//
//  DetailViewController.h
//  Homepwner
//
//  Created by Long Vinh Nguyen on 1/29/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

@class BNRItem;

@interface DetailViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>
{
    __weak IBOutlet UITextField *nameField;
    __weak IBOutlet UITextField *serialNumberField;
    __weak IBOutlet UITextField *valueField;
    __weak IBOutlet UILabel *dateLabel;
    __weak IBOutlet UIImageView *imageView;
}

@property (nonatomic, strong)BNRItem *item;

- (IBAction)takePicture:(id)sender;
- (IBAction)backGroundTapped:(id)sender;
- (IBAction)clearImage:(id)sender;
                              

@end
