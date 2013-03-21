//
//  LVNConnection.h
//  ClassSchedule
//
//  Created by Long Vinh Nguyen on 2/18/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"

@interface LVNConnection : NSURLConnection<NSURLConnectionDataDelegate, NSURLConnectionDelegate>
{
    NSMutableData *container;
    NSURLConnection *internalConnection;
}
- (id)initWithRequest:(NSURLRequest *)req;
@property (nonatomic, copy)NSURLRequest *request;
@property (nonatomic, strong)id<JSONSerializable> jsonRootObject;
@property (nonatomic, copy)void (^completionBlock)(id rootObject, NSError *err);

@end
