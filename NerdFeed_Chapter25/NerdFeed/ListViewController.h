//
//  ListViewController.h
//  NerdFeed
//
//  Created by Long Vinh Nguyen on 2/13/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RSSChannel;
@class WebViewController;

@interface ListViewController : UITableViewController<NSURLConnectionDelegate, NSURLConnectionDataDelegate, NSXMLParserDelegate, UIWebViewDelegate>
{
    NSURLConnection *connection;
    NSMutableData *xmlData;
    
    RSSChannel *channel;
}

@property (nonatomic, strong) WebViewController* webViewController;



- (void)fetchEntries;

@end
