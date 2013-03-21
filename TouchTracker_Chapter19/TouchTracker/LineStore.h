//
//  LineStore.h
//  TouchTracker
//
//  Created by Long Vinh Nguyen on 2/7/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Line;

@interface LineStore : NSObject
{

}

@property (nonatomic, strong) NSMutableArray *lineStore;

+ (LineStore *)sharedStore;
- (void) addLine: (Line *)l;
- (NSString *)archiveLinePath;
- (BOOL)save;

@end
