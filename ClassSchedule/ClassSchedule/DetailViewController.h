//
//  DetailViewController.h
//  ClassSchedule
//
//  Created by Long Vinh Nguyen on 2/19/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewController.h"

@class RSSClass;

@interface DetailViewController : UIViewController<UISplitViewControllerDelegate, ListViewControllerProtocol>
{
    __weak IBOutlet UITextField *tbTextField;

    __weak IBOutlet UITextField *teTextField;
    __weak IBOutlet UITextField *instructorTextField;
    __weak IBOutlet UITextField *priceTextField;
    
    __weak IBOutlet UITextField *locTextField;
}

@property (nonatomic, strong) RSSClass *item;



@end
