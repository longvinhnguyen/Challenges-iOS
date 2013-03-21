//
//  RSSClass.h
//  ClassSchedule
//
//  Created by Long Vinh Nguyen on 2/18/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"

@interface RSSClass : NSObject<JSONSerializable>

@property (nonatomic, strong)NSDate *timeBegin;
@property (nonatomic, strong)NSDate *timeEnd;
@property (nonatomic, strong)NSString *instructor;
@property (nonatomic, strong)NSString *location;
@property (nonatomic) int price;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *region;



@end
