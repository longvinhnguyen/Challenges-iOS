//
//  NerdFeedCell.h
//  NerdFeed
//
//  Created by Long Vinh Nguyen on 2/14/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NerdFeedCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@end
