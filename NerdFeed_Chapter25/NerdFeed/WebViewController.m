//
//  WebViewController.m
//  NerdFeed
//
//  Created by Long Vinh Nguyen on 2/13/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import "WebViewController.h"
#import "NerdFeedWebView.h"


@implementation WebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSLog(@"Loaded nib file successfully");
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    [goBackButton setEnabled:[wv canGoBack]];
    [goForwardButton setEnabled:[wv canGoForward]];
}



- (UIWebView *)webView
{
    return (UIWebView *)wv;
}

- (IBAction)goBack:(id)sender {
    [[self webView] goBack];
}

- (IBAction)goForward:(id)sender {
    [[self webView] goForward];
}

@end
