//
//  LVNConnection.m
//  ClassSchedule
//
//  Created by Long Vinh Nguyen on 2/18/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import "LVNConnection.h"
static NSMutableArray *sharedConnection;

@implementation LVNConnection
@synthesize request, jsonRootObject, completionBlock;

- (id)initWithRequest:(NSURLRequest *)req
{
    self = [super init];
    if (self) {
        [self setRequest:req];
    }
    return self;
}

- (void)start
{
    container = [[NSMutableData alloc] init];
    
    internalConnection = [[NSURLConnection alloc] initWithRequest:[self request] delegate:self startImmediately:YES];
    
    if (!sharedConnection) {
        sharedConnection = [[NSMutableArray alloc] init];
        [sharedConnection addObject:self];
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [container appendData:data];
}



- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{

    NSDictionary *d = [NSJSONSerialization JSONObjectWithData:container options:0 error:nil];
    if (jsonRootObject) {
        [jsonRootObject readFromJSONDictionary:d];
    }
    
    // Callback tableview to update
    if ([self completionBlock]) {
        completionBlock(jsonRootObject, nil);
    }
    
    // Now destroy the connection
    [sharedConnection removeObject:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{

    // Print the error
    NSLog(@"%@", [error localizedDescription]);
    
    // Destroy this connection
    [sharedConnection removeObject:self];
}











@end
