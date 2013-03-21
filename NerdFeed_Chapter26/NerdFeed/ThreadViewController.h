//
//  ThreadViewController.h
//  NerdFeed
//
//  Created by Long Vinh Nguyen on 2/27/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ListViewController;

@interface ThreadViewController : UITableViewController
{
    
}

@property (nonatomic, readonly) NSArray* threads;
@property (nonatomic, weak) ListViewController *lvc;


- (id)initWithStyle:(UITableViewStyle)style withThreads:(NSArray *)ts;

@end
