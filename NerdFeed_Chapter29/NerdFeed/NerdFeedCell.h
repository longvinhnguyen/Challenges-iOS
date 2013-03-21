//
//  NerdFeedCell.h
//  NerdFeed
//
//  Created by Long Vinh Nguyen on 3/10/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NerdFeedCellDelegate.h"

@interface NerdFeedCell : UITableViewCell

@property (nonatomic, strong)  UILabel *title;
@property (nonatomic, strong)  UILabel *subforum;

@property (nonatomic, strong) UILabel *backViewTitle;
@property (nonatomic, strong) UILabel *backViewSubForum;
@property (nonatomic, strong) UIImageView *backgroundView;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, retain) NSIndexPath *indexPath;
@property (nonatomic, weak) id<NerdFeedCellDelegate> delegate;

-(IBAction) didRightSwipeInCell:(id) sender;
-(IBAction) didLeftSwipeInCell:(id) sender;

@end
