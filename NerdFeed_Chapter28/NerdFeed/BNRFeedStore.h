//
//  BNRFeedStore.h
//  NerdFeed
//
//  Created by Long Vinh Nguyen on 2/16/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RSSChannel;

@interface BNRFeedStore : NSObject

+ (BNRFeedStore *)sharedStore;

- (void)fetchTopSongs:(int)count withCompletion:(void (^)(RSSChannel *obj, NSError *error))block;
- (void)fetchRSSFeedWithCompletion:(void (^)(RSSChannel * obj, NSError *error))block;

@end
