//
//  ThreadViewController.m
//  NerdFeed
//
//  Created by Long Vinh Nguyen on 2/27/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import "ThreadViewController.h"
#import "RSSItem.h"
#import "WebViewController.h"


@implementation ThreadViewController
@synthesize threads, lvc;


- (id)initWithStyle:(UITableViewStyle)style withThreads:(NSArray *)ts
{
    self  = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        threads = ts;
    }
    return self;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
    RSSItem *item = [threads objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[item title]];
    [[cell detailTextLabel] setText:[item subForum]];
    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self threads] count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RSSItem *item = [threads objectAtIndex:[indexPath row]];
    if (![self splitViewController]) {
        [[self navigationController] pushViewController:[lvc webViewController]  animated:YES];
    } else {
        // We have to create a new navigation controller, as the old one
        // was only retained by the split view controller and is now gone
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[lvc webViewController]];
        if (UIInterfaceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
            if ([lvc masterButton]) {
                [[self navigationItem] setLeftBarButtonItem:[lvc masterButton]];
            }
        } else {
            [[self navigationItem] setLeftBarButtonItem:nil];
        }
        
        NSArray *vcs = [NSArray arrayWithObjects:[self navigationController], nav, nil];
        [[self splitViewController] setViewControllers:vcs];
        
        [[self splitViewController] setDelegate:[lvc webViewController]];
    }
    [[lvc webViewController] listViewController:lvc handleObject:item];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


@end
