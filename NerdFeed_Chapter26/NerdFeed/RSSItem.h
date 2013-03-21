//
//  RSSItem.h
//  NerdFeed
//
//  Created by Long Vinh Nguyen on 2/13/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSSItem : NSObject <NSXMLParserDelegate>
{
    
    NSMutableString *currentString;
    __weak RSSItem *parentPost;
    
}

@property (nonatomic, weak) id parentParserDelegate;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subForum;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, weak) RSSItem *parentPost;

- (BOOL)isChild;

@end
