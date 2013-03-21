//
//  RSSClass.m
//  ClassSchedule
//
//  Created by Long Vinh Nguyen on 2/18/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import "RSSClass.h"

@implementation RSSClass
@synthesize timeBegin, timeEnd, instructor, location, price, title, region;

- (void)readFromJSONDictionary:(NSDictionary *)d
{
    
    [self setTimeBegin:[d objectForKey:@"class_begins"]];
    
    // NSDate *te = [df dateFromString:[d objectForKey:@"class_ends"]];
    [self setTimeEnd:[d objectForKey:@"class_ends"]];
    
    [self setInstructor:[d objectForKey:@"instructor_one"]];
    [self setTitle:[d objectForKey:@"title"]];
    
    [self setPrice:[[d objectForKey:@"price"] intValue]];
    [self setLocation:[d objectForKey:@"locality"]];
    

}


@end
