//
//  LineStore.m
//  TouchTracker
//
//  Created by Long Vinh Nguyen on 2/7/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import "LineStore.h"
#import "Line.h"

@implementation LineStore
@synthesize lineStore;

- (id)init
{
    self = [super init];
    if (self) {
        lineStore = [NSKeyedUnarchiver unarchiveObjectWithFile:[self archiveLinePath]];
        if (!lineStore) {
            lineStore = [[NSMutableArray alloc] init];
        }
    }
    return self;
}


+ (LineStore *)sharedStore
{
    static LineStore* shareStore = nil;
    if (!shareStore) {
        shareStore = [[super allocWithZone:nil] init];
    }
    return shareStore;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}


- (void)addLine:(Line *)l
{
    [lineStore addObject:l];
}

- (NSString *)archiveLinePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"lineStore.archive"];
}

- (BOOL)save
{
    BOOL success = [NSKeyedArchiver archiveRootObject:lineStore toFile:[self archiveLinePath]];
    return success;
}


@end
