//
//  HomepwnerItemBaseCell.h
//  Homepwner
//
//  Created by Long Vinh Nguyen on 2/28/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomepwnerItemBaseCell : UITableViewCell
@property (weak, nonatomic) id controller;
@property (weak, nonatomic) UITableView *tableView;

- (void)forwardAction:(SEL)action fromSender:(id)sender;

@end
