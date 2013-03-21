//
//  ListViewController.h
//  ClassSchedule
//
//  Created by Long Vinh Nguyen on 2/18/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RSSSchedule;

@interface ListViewController : UITableViewController
{
    RSSSchedule *schedule;
}



- (void)fetchEntries;

@end

@protocol ListViewControllerProtocol

- (void)listViewControllerHandle:(ListViewController *)vc withObject:(id)obj;

@end
