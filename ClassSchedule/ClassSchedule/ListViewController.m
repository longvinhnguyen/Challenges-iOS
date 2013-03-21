//
//  ListViewController.m
//  ClassSchedule
//
//  Created by Long Vinh Nguyen on 2/18/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import "ListViewController.h"
#import "LVNClassStore.h"
#import "RSSSchedule.h"
#import "RSSClass.h"
#import "DetailViewController.h"

@interface ListViewController ()

@end

@implementation ListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self fetchEntries];
        [[self navigationItem] setTitle:@"BNR Schedule"];
    }
    return self;
}

- (void)fetchEntries
{
    void (^completionBlock)(RSSSchedule *sd, NSError *err) = ^void(RSSSchedule *sd, NSError *err){
        if (!err) {
            schedule = sd;
            [[self tableView] reloadData];
        } else {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:[err localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
        } 
    };
    [[LVNClassStore sharedStore] fetchClassScheduleWithCompletion:completionBlock];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[schedule items] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
    RSSClass * classDetail = [[schedule items] objectAtIndex:[indexPath row]];
    [[cell textLabel] setText: [classDetail title]];
    [[cell detailTextLabel] setText:[classDetail region]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *dvc;
    if (![self splitViewController]) {
        dvc = [[DetailViewController alloc] init];
        [[self navigationController] pushViewController:dvc animated:YES];
    } else {
        dvc =[[[[[self splitViewController] viewControllers] objectAtIndex:1] viewControllers] objectAtIndex:0];

    }
    RSSClass *selectedClass = [[schedule items] objectAtIndex:[indexPath row]];
    [dvc listViewControllerHandle:self withObject:selectedClass];
}










@end
