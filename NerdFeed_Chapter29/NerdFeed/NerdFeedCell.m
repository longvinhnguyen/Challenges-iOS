//
//  NerdFeedCell.m
//  NerdFeed
//
//  Created by Long Vinh Nguyen on 3/10/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import "NerdFeedCell.h"

@implementation NerdFeedCell
@synthesize backViewTitle, backViewSubForum,delegate, backgroundView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code

        // topView
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width + 40, self.contentView.bounds.size.height)];
        // set up title
        _title = [[UILabel alloc] initWithFrame:CGRectMake(3, 3, 250, 25)];
        [_title setBackgroundColor:[UIColor clearColor]];
        [_title setFont:[UIFont fontWithName:@"Baskerville-Bold" size:18]];
        [_title setTextColor:[UIColor blackColor]];
        
        _subforum = [[UILabel alloc] initWithFrame:CGRectMake(3, 28, 250, 12)];
        [_subforum setFont:[UIFont fontWithName:@"Papyrus" size:12]];
        [_subforum setTextColor:[UIColor grayColor]];
        [_subforum setBackgroundColor:[UIColor clearColor]];
        
        [_topView setBackgroundColor:[UIColor whiteColor]];
        [_topView addSubview:_title];
        [_topView addSubview:_subforum];
        
        // backView
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width + 40, self.contentView.bounds.size.height)];
        backViewTitle = [[UILabel alloc] initWithFrame:CGRectMake(3, 3, 250, 25)];
        [backViewTitle setBackgroundColor:[UIColor clearColor]];
        [backViewTitle setFont:[UIFont fontWithName:@"Courier-Bold" size:18]];
        [backViewTitle setTextColor:[UIColor yellowColor]];
        
        backViewSubForum = [[UILabel alloc] initWithFrame:CGRectMake(3, 28, 250, 12)];
        [backViewSubForum setBackgroundColor:[UIColor clearColor]];
        [backViewSubForum setFont:[UIFont fontWithName:@"AppleColorEmoji" size:12]];
        [backViewSubForum setTextColor:[UIColor whiteColor]];
        
        backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"corkboard.png"]];
        [backgroundView setFrame:_backView.frame];
        [backgroundView setAlpha:0.5];
        
        

        
        [_backView addSubview:backViewTitle];
        [_backView addSubview:backViewSubForum];
        [_backView addSubview:backgroundView];
        [_backView setBackgroundColor:[UIColor blackColor]];
        
        [self.contentView addSubview:_backView];
        [self.contentView addSubview:_topView];
        
        // Add swipe gestures to cell
        UISwipeGestureRecognizer *swipeRightDirection = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didRightSwipeInCell:)];
        [swipeRightDirection setDirection:UISwipeGestureRecognizerDirectionRight];
        [self addGestureRecognizer:swipeRightDirection];
        
        UISwipeGestureRecognizer *swipeLeftDirection = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didLeftSwipeInCell:)];
        [swipeLeftDirection setDirection:UISwipeGestureRecognizerDirectionLeft];
        [self addGestureRecognizer:swipeLeftDirection];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected) {
        [_title setTextColor:[UIColor redColor]];
        [_subforum setTextColor:[UIColor redColor]];
        if (CGPointEqualToPoint(_topView.frame.origin, CGPointZero)) {
            [_backView setHidden:YES];
        } else {
            [_topView setHidden:YES];
        }

    } else {
        [_title setTextColor:[UIColor blackColor]];
        [_subforum setTextColor:[UIColor grayColor]];
        [self setSelectedBackgroundView:nil];
    }
}

- (void)didRightSwipeInCell:(UISwipeGestureRecognizer*) sender
{
    [delegate didSwipeRigthCellWithIndexPath:_indexPath];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView animateWithDuration:1.0 animations:^{
        [_topView setFrame:CGRectMake(self.contentView.bounds.size.width + 40, 0, self.contentView.bounds.size.width + 40, 44)];
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.15 animations:^{
            [_backView setHidden:NO];
            [_backView setFrame:CGRectMake(10, 0, self.contentView.bounds.size.width + 40, 44)];
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.15 animations:^{
                [_backView setFrame:CGRectMake(0, 0, self.contentView.bounds.size.width + 40, 44)];
            }];
        }];
    }];

}

- (void) didLeftSwipeInCell:(UISwipeGestureRecognizer *)sender
{
    [delegate didSwipeLeftCellWithIndexPath:_indexPath];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView animateWithDuration:1.0 animations:^{
        [_topView setFrame:CGRectMake(-10, 0, self.contentView.bounds.size.width + 40, 44)];
    } completion:^(BOOL finsihed){
        [_topView setFrame:CGRectMake(0, 0, self.contentView.bounds.size.width + 40, 44)];
    }];
}

@end
