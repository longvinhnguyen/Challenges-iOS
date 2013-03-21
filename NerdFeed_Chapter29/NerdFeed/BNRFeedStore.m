//
//  BNRFeedStore.m
//  NerdFeed
//
//  Created by Long Vinh Nguyen on 2/16/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import "BNRFeedStore.h"
#import "RSSChannel.h"
#import "BNRConnection.h"
#import "RSSItem.h"

@implementation BNRFeedStore
@synthesize favList;

- (id)init
{
    self  = [super init];
    if (self) {
        model = [NSManagedObjectModel mergedModelFromBundles:nil];
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        NSError *error = nil;
        NSString *dbpath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        dbpath = [dbpath stringByAppendingPathComponent:@"feed.db"];
        NSURL *dbURL = [NSURL fileURLWithPath:dbpath];
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:dbURL options:nil error:&error]) {
            [NSException raise:@"Open failed" format:@"Reason: %@",[error localizedDescription]];
        }
        
        context = [[NSManagedObjectContext alloc] init];
        [context setPersistentStoreCoordinator:psc];
        [context setUndoManager:nil];
        
        NSString *favPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        favPath = [favPath stringByAppendingPathComponent:@"favorites.archive"];
        favList = [NSKeyedUnarchiver unarchiveObjectWithFile:favPath];
        if (!favList) favList = [[NSMutableArray alloc] init];
        
    }
    return self;
}

+ (BNRFeedStore *)sharedStore
{
    static BNRFeedStore *feedStore = nil;
    if (!feedStore) {
        feedStore = [[BNRFeedStore alloc] init];
    }
    return feedStore;
}

- (RSSChannel *)fetchRSSFeedWithCompletion:(void (^)(RSSChannel *, NSError *))block
{
    NSURL *url = [NSURL URLWithString:@"http://forums.bignerdranch.com/" @"smartfeed.php?limit=1_DAY&sort_by=standard" @"&feed_type=RSS2.0&feed_style=COMPACT"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // Create an empty channel
    RSSChannel *channel = [[RSSChannel alloc] init];
    
    // Create a connection "actor" object that will transfer data from the server
    BNRConnection *connection = [[BNRConnection alloc] initWithRequest:request];
    
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    cachePath = [cachePath stringByAppendingPathComponent:@"nerd.archive"];
    // Load the cache channel
    RSSChannel *cachedChannel = [NSKeyedUnarchiver unarchiveObjectWithFile:cachePath];
    
    // If one hasn't already been cached, create a blank one to fill up
    if (!cachedChannel) {
        cachedChannel = [[RSSChannel alloc] init];
    }
    
    RSSChannel *channelCopy = [cachedChannel copy];
            
    
    // When the connection completes, this block from the controller will be called
    [connection setCompletionBlock:^(RSSChannel *obj, NSError *err) {
        // This is the store's callback code
        if (!err) {
            if (![channelCopy title]) {
                [channelCopy setTitle:[obj title]];
                [channelCopy setInfoString:[obj infoString]];
            }
            // Bronze Challenge - Pruning the cache
            [channelCopy addItemsFromChannel:obj];

            RSSChannel *savedCopy = [channelCopy copy];
            if ([[savedCopy items] count] > 100) {
                [[savedCopy items] removeObjectsInRange:NSMakeRange(0, [[channelCopy items]count] - 100)];
            }
            [NSKeyedArchiver archiveRootObject:savedCopy toFile:cachePath];

        }
        

        // This is the controller's callback code
        block(channelCopy, err);
    }];
    
    // Let the channel parse the returning data from the web service
    [connection setXmlRootObject:channel];
    
    // Begin the connection
    [connection start];
    
    return cachedChannel;
}

- (void)fetchTopSongs:(int)count withCompletion:(void (^)(RSSChannel *, NSError *))block
{
    // Construce the cache path
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    cachePath = [cachePath stringByAppendingPathComponent:@"apple.archive"];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    path = [path stringByAppendingPathComponent:@"apple.json"];
    
    // Make sure that we have cached at least once before by checking to see
    // if this date exists
    NSDate *tscDate = [self topSongCacheDate];
    if (tscDate) {
        // How old is the cache
        NSTimeInterval cacheAge = [tscDate timeIntervalSinceNow];
        if (cacheAge > -300.0) {
            // If it is less than 300 seconds (5 minutes) old, return cache in completion block
            // RSSChannel *cachedChannel = [NSKeyedUnarchiver unarchiveObjectWithFile:cachePath];
            RSSChannel *cachedChannel = [[RSSChannel alloc] init];
            [cachedChannel readFromJSONDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];

            
            if ([[cachedChannel items] count] > 0) {
                // Execute the controller's completion block to reload its table
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    block(cachedChannel, nil);
                }];
                
                // Don't need to make the request, just get out this method
                return;
            }
        }
    }
    
    // Prepare a request URL, including the argument from the controller
    NSString *requestString = [NSString stringWithFormat:@"http://itunes.apple.com/us/rss/topsongs/limit=%d/json",count];
    NSURL *url = [NSURL URLWithString:requestString];
    
    // Set up the connection as normal
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    RSSChannel *channel = [[RSSChannel alloc] init];
    
    BNRConnection *conneciton = [[BNRConnection alloc] initWithRequest:req];
    [conneciton setCompletionBlock:^void(RSSChannel *obj, NSError *err){
        // This is the store's completion code:
        // If everything went smoothly, save the channel to disk and set cache date
        if (!err) {
            [self setTopSongCacheDate:[NSDate date]];
            // Gold Challenge:JSON Cache
        
            [obj writeToJSONDictionary:path];
            
            [NSKeyedArchiver archiveRootObject:obj toFile:cachePath];
        }
        
        // This is the controller's completion code
        block(obj,err);
    }];
    [conneciton setJsonRootObject:channel];
    [conneciton start];
}

- (void)setTopSongCacheDate:(NSDate *)topSongCacheDate
{
    [[NSUserDefaults standardUserDefaults] setObject:topSongCacheDate forKey:@"topSongsCacheDate"];
}

- (NSDate *)topSongCacheDate
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"topSongsCacheDate"];
}

- (void)markItemAsRead:(RSSItem *)item
{
    // If the item is already in CoreData, no need to duplicate
    if ([self hasItemBeenRead:item]) {
        return;
    }
    
    // Create a new link object and insert it into the context
    NSManagedObject *obj = [NSEntityDescription insertNewObjectForEntityForName:@"Link" inManagedObjectContext:context];
    
    // Set the Link's urlString from the RSSItem
    [obj setValue:[item link] forKey:@"urlString"];
    
    // Immediately save the changes
    [context save:nil];
}

- (BOOL)hasItemBeenRead:(RSSItem *)item
{
    // Create a request to fetch all Link's with the same urlString as this items link
    NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:@"Link"];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"urlString like %@",[item link]];
    [req setPredicate:pre];
    
    // If there is at least one Link, then this item has been read before
    NSArray *entries = [context executeFetchRequest:req error:nil];
    if ([entries count] > 0) {
        return YES;
    }
    
    // If CoreData has never seen this link, then it hasn't been read
    return NO;
}

- (BOOL)saveFavorites
{
    NSString *favPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    favPath = [favPath stringByAppendingPathComponent:@"favorites.archive"];
    if ([NSKeyedArchiver archiveRootObject:favList toFile:favPath]) {
        return YES;
    }
    return NO;
}









@end
