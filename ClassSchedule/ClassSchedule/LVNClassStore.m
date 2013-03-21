//
//  LVNClassStore.m
//  ClassSchedule
//
//  Created by Long Vinh Nguyen on 2/18/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import "LVNClassStore.h"
#import "LVNConnection.h"
#import "RSSSchedule.h"

@implementation LVNClassStore

+ (LVNClassStore *)sharedStore
{
    static LVNClassStore *shareStored = nil;
    if (!shareStored) {
        shareStored = [[super alloc] init];
    }
    return shareStored;
}

-(void)fetchClassScheduleWithCompletion:(void (^)(RSSSchedule *, NSError *))block
{
    NSURL *url = [NSURL URLWithString:@"http://www.bignerdranch.com/json/schedule"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    LVNConnection *connection = [[LVNConnection alloc] initWithRequest:request];
    RSSSchedule *schedule = [[RSSSchedule alloc] init];
    [connection setJsonRootObject:schedule];
    [connection setCompletionBlock:block];
    [connection start];
}

@end
