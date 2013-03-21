//
//  HomepwnerItemCell.m
//  Homepwner
//
//  Created by Long Vinh Nguyen on 2/2/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import "HomepwnerItemCell.h"
#import "ItemsViewController.h"

@implementation HomepwnerItemCell
@synthesize tableView, controller;

- (IBAction)showImage:(id)sender
{
    
    // Get this name of this method, "showImage:"
    NSString *selector = NSStringFromSelector(_cmd);
    selector = [selector stringByAppendingString:@"atIndexPath:"];
    
    // Prepare a new selector from this string
    SEL newSelector = NSSelectorFromString(selector);
    
    NSIndexPath *indexPath = [[self tableView] indexPathForCell:self];
    if (indexPath) {
        if ([[self controller] respondsToSelector:newSelector]) {
            [[self controller] performSelector:newSelector withObject:sender withObject:indexPath];
        }
    }
}

- (IBAction)changeValue:(id)sender {
    // Get this name of this method, "showImage:"
    NSString *selector = NSStringFromSelector(_cmd);
    selector = [selector stringByAppendingString:@"atIndexPath:withTableView:"];
    
    // Prepare a new selector from this string
    SEL newSelector = NSSelectorFromString(selector);
    UITableView *tblv = self.tableView;
    
    NSIndexPath *indexPath = [[self tableView] indexPathForCell:self];
    if (indexPath) {
        if ([[self controller] respondsToSelector:newSelector]) {
            //[[self controller] performSelector:newSelector withObject:sender withObject:indexPath];
            NSMethodSignature *mySignature = [self.controller methodSignatureForSelector:newSelector];
            NSInvocation *myInvocation = [NSInvocation invocationWithMethodSignature:mySignature];
            [myInvocation setSelector:newSelector];
            [myInvocation setTarget:self.controller];
            [myInvocation setArgument:&sender atIndex:2];
            [myInvocation setArgument:&indexPath atIndex:3];
            [myInvocation setArgument:&tblv atIndex:4];
            [myInvocation invoke];
        }
    }
}

@end
