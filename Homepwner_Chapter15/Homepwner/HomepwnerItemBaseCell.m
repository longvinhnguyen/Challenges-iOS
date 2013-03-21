//
//  HomepwnerItemBaseCell.m
//  Homepwner
//
//  Created by Long Vinh Nguyen on 2/28/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import "HomepwnerItemBaseCell.h"

@implementation HomepwnerItemBaseCell
@synthesize controller, tableView;


- (void)forwardAction:(SEL)action fromSender:(id) sender {
    SEL selector = NSSelectorFromString([NSStringFromSelector(action) stringByAppendingString:@"atIndexPath:"]);
    if ([controller respondsToSelector:selector]) {
        [controller performSelector:selector withObject:sender withObject:[tableView indexPathForCell:self]];
    }
}

@end
