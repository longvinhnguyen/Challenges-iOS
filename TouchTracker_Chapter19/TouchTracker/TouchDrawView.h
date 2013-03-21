//
//  TouchDrawView.h
//  TouchTracker
//
//  Created by Long Vinh Nguyen on 2/5/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TouchDrawView : UIView
{
    NSMutableDictionary *lineInProcess;
    NSMutableArray *completeLines;
    NSMutableDictionary *circleInProcess;
    NSMutableArray *circleCompletes;
}

- (void)clearAll;
- (void)endTouches:(NSSet *)touches;


@end
