//
//  NerdFeedWebView.m
//  NerdFeed
//
//  Created by Long Vinh Nguyen on 2/14/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import "NerdFeedWebView.h"

@implementation NerdFeedWebView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (BOOL)canGoBack
{
    return NO;
}

- (BOOL)canGoForward
{
    return NO;
}

@end
