//
//  LVNClassStore.h
//  ClassSchedule
//
//  Created by Long Vinh Nguyen on 2/18/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RSSSchedule;

@interface LVNClassStore : NSObject

+ (LVNClassStore *)sharedStore;

- (void)fetchClassScheduleWithCompletion:(void (^)(RSSSchedule *schedule, NSError *err))block;

@end
