//
//  BNRImageStore.m
//  Homepwner
//
//  Created by Long Vinh Nguyen on 1/30/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import "BNRImageStore.h"

@implementation BNRImageStore

- (id)init
{
    self = [super init];
    if (self) {
        dictionary = [[NSMutableDictionary alloc] init];
    }
    return  self;
}

+(BNRImageStore *)sharedStore
{
    static BNRImageStore* sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:NULL] init];
    }
    return sharedStore;
}

+(id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

-(void)setImage:(UIImage *)i forKey:(NSString *)s
{
    [dictionary setObject:i forKey:s];
}

-(UIImage *)imageForKey:(NSString *)s
{
    return [dictionary objectForKey:s];
}

- (void)deleteImageForKey:(NSString *)s
{
    if (!s) return;
    [dictionary removeObjectForKey:s];
}






@end
