//
//  ItemsViewController.m
//  Homepwner
//
//  Created by Long Vinh Nguyen on 1/28/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import "ItemsViewController.h"
#import "BNRItemStore.h"
#import "BNRItem.h"

@implementation ItemsViewController

-(id)init
{
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        for (int i = 0; i < 5; i++) {
            [[BNRItemStore sharedStore] createItem];
            NSPredicate *valuePredicate1 = [NSPredicate predicateWithFormat:@"valueInDollars > 50"];
            NSPredicate *valuePredicate2 = [NSPredicate predicateWithFormat:@"valueInDollars <= 50"];
            moreThan50 = [[[BNRItemStore sharedStore] allItems] filteredArrayUsingPredicate:valuePredicate1];
            lessThan50 = [[[BNRItemStore sharedStore] allItems] filteredArrayUsingPredicate:valuePredicate2];
            UIImage *img = [UIImage imageNamed:@"background.jpg"];
            UIImageView *bgView = [[UIImageView alloc] initWithImage:img];
            [[self tableView] setBackgroundView:bgView];
        }
    }
    return self;
}

-(id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [moreThan50 count];
    } else {
        return [[[BNRItemStore sharedStore] allItems] count] - [moreThan50 count] + 1;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Check for a reusable cell first, use that if it exists
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    
    // Set the text on the cell with the description of the item
    // that is at the nth index of items, where = row this cell
    // will appear in on the tableview
    BNRItem *p;
    UIFont *new = [[UIFont alloc] fontWithSize:20];
    switch ([indexPath section]) {
        case 0:
            p = [moreThan50 objectAtIndex:[indexPath row]];
            [[cell textLabel] setText:[p description]];
            [[cell textLabel] setFont:new];
            break;
        case 1:
            if ([indexPath row] < ([lessThan50 count])) {
                p = [lessThan50 objectAtIndex:[indexPath row]];
                [[cell textLabel] setText:[p description]];
                [[cell textLabel] setFont:new];
            } else {
                [[cell textLabel] setText:@"No more items!"];
            }
            break;
        default:
            break;
    }

    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 1 && !([indexPath row] < [lessThan50 count])) {
        return 44;
    }
    return 60;
}













@end
