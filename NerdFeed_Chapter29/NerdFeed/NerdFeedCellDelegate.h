//
//  NerdFeedCellDelegate.h
//  NerdFeed
//
//  Created by Long Vinh Nguyen on 3/11/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NerdFeedCellDelegate <NSObject>

- (void)didSwipeLeftCellWithIndexPath:(NSIndexPath *)indexPath;
- (void)didSwipeRigthCellWithIndexPath:(NSIndexPath *)indexPath;


@end
