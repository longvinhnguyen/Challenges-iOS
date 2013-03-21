//
//  ListViewController.h
//  NerdFeed
//
//  Created by Long Vinh Nguyen on 2/13/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RSSItem;

@class RSSChannel;
@class WebViewController;

@interface ListViewController : UITableViewController<NSURLConnectionDelegate, NSURLConnectionDataDelegate, NSXMLParserDelegate>
{
    NSURLConnection *connection;
    NSMutableData *xmlData;
    
    RSSChannel *channel;
}

@property (nonatomic, strong) WebViewController* webViewController;
@property (nonatomic, strong) UIBarButtonItem *masterButton;
@property (nonatomic, strong) NSIndexPath *swipedCell;




- (void)fetchEntries;
- (NSArray *)findingThreadsForParentPost:(RSSItem *)i;





@end

// Add new protocol named ListViewControllerDelegate
@protocol ListViewControllerDelegate

// Classes that conform to this protocol must implement this method
- (void)listViewController:(ListViewController *)lvc handleObject:(id)object;

@end
