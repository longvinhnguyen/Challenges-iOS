//
//  BNRConnection.m
//  NerdFeed
//
//  Created by Long Vinh Nguyen on 2/16/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import "BNRConnection.h"

static NSMutableArray *sharedConnectionList = nil;

@implementation BNRConnection
@synthesize request, completionBlock, xmlRootObject;
@synthesize jsonRootObject;

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
    // Initializer container for data collected from NSURLConnection
    container = [[NSMutableData alloc] init];
    
    // Spawn connection
    internalConnection = [[NSURLConnection alloc] initWithRequest:[self request] delegate:self startImmediately:YES];
    
    if (!sharedConnectionList) {
        sharedConnectionList = [[NSMutableArray alloc] init];
        
        // Add the connection to the array so it doesn't get destroyed
        [sharedConnectionList addObject:self];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [container appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    id rootObject = nil;
    // If there is a root object
    if ([self xmlRootObject]) {
        // Create a parser with the incoming data and let the root object parse its contents
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:container];
        
        [parser setDelegate:[self xmlRootObject]];
        [parser parse];
        rootObject = [self xmlRootObject];
    } else if ([self jsonRootObject]) {
        // Turn jason data into basic model objects
        NSDictionary *d = [NSJSONSerialization JSONObjectWithData:container options:0 error:nil];
        
        // Have the root object construct itself from basic model objects
        [[self jsonRootObject] readFromJSONDictionary:d];
        rootObject = [self jsonRootObject];
        NSLog(@"\t JSON Data: %@", d);
    }
    
    // Then, pass the root object to the completion block - remember,
    // this is the block that the controller supplied
    if ([self completionBlock]) {
        [self completionBlock](rootObject, nil);
        
    }
    // Now destroyed this connection
    [sharedConnectionList removeObject:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // Pass the error from the conneciton to the completionBlock
    if ([self completionBlock]) {
        [self completionBlock](nil, error);
    }
    // Destroy this connection
    [sharedConnectionList removeObject:self];
}










@end