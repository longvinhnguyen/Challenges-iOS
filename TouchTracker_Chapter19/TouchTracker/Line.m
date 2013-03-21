//
//  Line.m
//  TouchTracker
//
//  Created by Long Vinh Nguyen on 2/5/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import "Line.h"

@implementation Line
@synthesize begin, end;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    [self setBegin:CGPointMake([aDecoder decodeFloatForKey:@"beginX"],[aDecoder decodeFloatForKey:@"beginY"])];
    [self setEnd:CGPointMake([aDecoder decodeFloatForKey:@"endX"],[aDecoder decodeFloatForKey:@"endY"])];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeFloat:begin.x forKey:@"beginX"];
    [aCoder encodeFloat:begin.y forKey:@"beginY"];
    [aCoder encodeFloat:end.x forKey:@"endX"];
    [aCoder encodeFloat:end.y forKey:@"endY"];
}

@end
