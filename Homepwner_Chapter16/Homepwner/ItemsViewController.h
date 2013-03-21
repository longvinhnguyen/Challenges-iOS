//
//  ItemsViewController.h
//  Homepwner
//
//  Created by Long Vinh Nguyen on 1/28/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemsViewController : UITableViewController <UIPopoverControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate>
{
    UIPopoverController *imagePopover;
}

@property (nonatomic, strong) NSMutableArray *filteredItems;


- (IBAction)addNewItem:(id)sender;
- (void)filterContentForString:(NSString *) searchString;



@end
