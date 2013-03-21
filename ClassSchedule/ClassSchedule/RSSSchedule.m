//
//  RSSSchedule.m
//  ClassSchedule
//
//  Created by Long Vinh Nguyen on 2/18/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import "RSSSchedule.h"
#import "RSSClass.h"


@implementation RSSSchedule
@synthesize title, items, infoString;

- (id)init
{
    self = [super init];
    if (self) {
        items= [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)readFromJSONDictionary:(NSDictionary *)d
{
    [self setTitle:@"Big Nerd Ranch Schedule"];
    [self setInfoString:@"International Programming Class"];
    
    NSDictionary *europeEntries = [d objectForKey:@"EUROPE"];
    for (NSString *key in [europeEntries allKeys]) {
        NSDictionary *classDict = [europeEntries objectForKey:key];
        RSSClass *class = [[RSSClass alloc] init];
        [class setRegion:@"EUROPE"];
        [class readFromJSONDictionary:classDict];
        [items addObject:class];
    }
    
    NSDictionary *usaEntries = [d objectForKey:@"UNITED STATES"];
    for (NSString *key in [usaEntries allKeys]) {
        NSDictionary *classDict = [usaEntries objectForKey:key];
        RSSClass *class = [[RSSClass alloc] init];
        [class setRegion:@"UNITED STATES"];
        [class readFromJSONDictionary:classDict];
        [items addObject:class];
    }
    
    
}

@end
