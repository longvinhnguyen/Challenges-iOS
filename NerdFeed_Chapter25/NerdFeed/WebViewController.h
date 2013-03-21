//
//  WebViewController.h
//  NerdFeed
//
//  Created by Long Vinh Nguyen on 2/13/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NerdFeedWebView;

@interface WebViewController : UIViewController
{
    __weak IBOutlet NerdFeedWebView *wv;
    __weak IBOutlet UIBarButtonItem *goBackButton;
    __weak IBOutlet UIBarButtonItem *goForwardButton;
    
}


- (UIWebView *)webView;
- (IBAction)goBack :(id)sender;
- (IBAction)goForward :(id)sender;

@end
