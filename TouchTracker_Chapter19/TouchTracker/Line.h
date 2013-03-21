//
//  Line.h
//  TouchTracker
//
//  Created by Long Vinh Nguyen on 2/5/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Line : NSObject<NSCoding>

@property (nonatomic) CGPoint begin;
@property (nonatomic) CGPoint end;

@end
