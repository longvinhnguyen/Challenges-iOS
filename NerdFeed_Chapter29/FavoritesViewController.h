//
//  FavoritesViewController.h
//  NerdFeed
//
//  Created by Long Vinh Nguyen on 2/22/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoritesViewController : UITableViewController
{
    NSArray *favoriteList;
}

- (id)initWithStyle:(UITableViewStyle)style andFavList:(NSArray *)favlist;
- (void)setFavoriteList:(NSArray *)fl;

@end
