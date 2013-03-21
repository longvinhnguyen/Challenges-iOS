//
//  FavoritesViewController.m
//  NerdFeed
//
//  Created by Long Vinh Nguyen on 2/22/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import "FavoritesViewController.h"
#import "RSSItem.h"
#import "ListViewController.h"
#import "WebViewController.h"
#import "BNRFeedStore.h"

@interface FavoritesViewController ()

@end

@implementation FavoritesViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    [NSException raise:@"Failed to init" format:@"Please use initializer initWithStyle: andFavList:"];
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style andFavList:(NSArray *)favlist
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        favoriteList = [[NSMutableArray alloc] init];
        UITabBarItem *tbi = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:1];
        [[self tabBarController] setTabBarItem:tbi];
        [[self navigationItem] setTitle:@"Favorites"];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [favoriteList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    RSSItem *item = [favoriteList objectAtIndex:[indexPath row]];
    if (indexPath.row % 2 == 0) {
        [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"red-ginham"]]];
    } else [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"steel-diamond"]]];

    [cell.backgroundView setAlpha:0.5];
    [[cell textLabel] setText:[item title]];
    [cell.textLabel setTextColor:[UIColor purpleColor]];
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    [cell.textLabel setFont:[UIFont fontWithName:@"Noteworthy-Bold" size:20]];
    
    [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WebViewController *wvc = [[WebViewController alloc] init];
    if (![self splitViewController]) {
        [[self navigationController] pushViewController:wvc animated:YES];
    } else {
        // We have to create a new navigation controller, as the old one
        // was only retained by the split view controller and is now gone
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:wvc];
        NSArray *vcs = [NSArray arrayWithObjects:[self tabBarController], nav, nil];
        [[self splitViewController] setViewControllers:vcs];
        [[self splitViewController] setDelegate:wvc];
    }
    RSSItem *item = [favoriteList objectAtIndex:[indexPath row]];
    // Grab the info from the item and push it into the appropriate views
    NSURL *url = [NSURL URLWithString:[item link]];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [[wvc webView] loadRequest:req];
    [[wvc navigationItem] setTitle:[item title]];
    
}

- (void)setFavoriteList:(NSArray *)fl
{
    favoriteList = fl;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    favoriteList = [[BNRFeedStore sharedStore] favList];
    [[self tableView] reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait) || UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}





@end
