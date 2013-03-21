//
//  RSSChannel.m
//  NerdFeed
//
//  Created by Long Vinh Nguyen on 2/13/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import "RSSChannel.h"
#import "RSSItem.h"

@implementation RSSChannel
@synthesize infoString, title, items, parentParserDelegate;

- (id)init
{
    self = [super init];
    if (self) {
        // Create the container for the RSSItems this channel has;
        // we will create the RSSItem class shortly
        items = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    currentString = [[NSMutableString alloc] init];
    if ([elementName isEqual:@"title"])
    {
        [self setTitle:currentString];
    } else if ([elementName isEqual:@"description"]) {
        [self setInfoString:currentString];
    } else if ([elementName isEqual:@"item"] || [elementName isEqual:@"entry"]) {
        // When we find an item, create an instance of RSSItem
        RSSItem *entry = [[RSSItem alloc] init];
        // Set up its parent as ourselves so we can regain control of the parser
        [entry setParentParserDelegate:self];
        
        // Turn the parser to the RSSItem
        [parser setDelegate:entry];
        
        // Add the item to our array and release our hold on it
        [items addObject:entry];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [currentString appendString:string];
    NSLog(@"%@",currentString);
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    // If we were in an element that we were collecting the string for,
    // this appropriately releases our hold on it and the permanent ivar keeps
    // ownership of it. If we weren't parsing such an element, currentString
    // is nil already
    currentString = nil;
    
    // If the element that ended was the channel, give up control to
    // who gave us control in the first place
    if ([elementName isEqual:@"channel"]) {
        [parser setDelegate:parentParserDelegate];
        [self trimItemTitles];
    }
}

- (void)trimItemTitles
{
    // Create a regular expression with the pattern: Author
    NSRegularExpression *reg = [[NSRegularExpression alloc] initWithPattern:@"(.*) :: (.*) :: .*" options:0 error:nil];
    
    // Loop through everty title of the items in channel
    for (RSSItem *i in items) {
        NSString *itemTitle = [i title];
        
        // Find matches in the title string. The range
        // argument specifies how much of the title to search;
        // in this case, all of it
        NSArray *matches = [reg matchesInString:itemTitle options:0 range:NSMakeRange(0, [itemTitle length])];
        
        if ([matches count] > 0) {
            // Print the location of the match in the string and the string
            NSTextCheckingResult *result = [matches objectAtIndex:0];
            // NSRange r = [result range];
            
            // One capture group, so two ranges
            if ([result numberOfRanges] == 3) {
                
                NSRange r = [result rangeAtIndex:1];
                [i setSubForum:[itemTitle substringWithRange:r]];
                
                
                // Pull out the 2nd range, which will be capture group
                r = [result rangeAtIndex:2];
                
                // Set the title of the item to the string within the capture group
                [i setTitle:[itemTitle substringWithRange:r]];
                
                
            }
        }
    }
}

- (void)readFromJSONDictionary:(NSDictionary *)d
{
    // The top-level object contains a "feed" object, which is the channel
    NSDictionary *feed = [d objectForKey:@"feed"];
    
    // The feed has a title property, make this the title of our channel
    [self setTitle:[[feed objectForKey:@"title"] objectForKey:@"label"]];
    [self setInfoString:[[feed objectForKey:@"rights"] objectForKey:@"label"]];
    
    // The feed also has an array of entries, for each one, make a new RSSItem
    NSArray *entries = [feed objectForKey:@"entry"];
    for (NSDictionary *entry in entries) {
        RSSItem *i = [[RSSItem alloc] init];
    
        // Pass the entry dicitonary to the item so it can grab its ivars
        [i readFromJSONDictionary:entry];
        [items addObject:i];
    }
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:items forKey:@"items"];
    [aCoder encodeObject:title forKey:@"title"];
    [aCoder encodeObject:infoString forKey:@"infoString"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        items = [aDecoder decodeObjectForKey:@"items"];
        [self setInfoString:[aDecoder decodeObjectForKey:@"infoString"]];
        [self setTitle:[aDecoder decodeObjectForKey:@"title"]];
    }
    return self;
}

- (void)addItemsFromChannel:(RSSChannel *)otherChannel
{
    // If self's item does not contain this item, add it
    for (RSSItem *i in [otherChannel items]) {
        // If self's items does not contain this item, add it
        if (![[self items] containsObject:i]) {
            [[self items] addObject:i];
        }
    }
    
    // Sort the array of items by publication date
    [[self items] sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj2 publicationDate] compare:[obj1 publicationDate]];
    }];
}

- (id)copyWithZone:(NSZone *)zone
{
    RSSChannel *c = [[[self class] alloc] init];
    
    [c setTitle:[self title]];
    [c setInfoString:[self infoString]];
    c->items = [items mutableCopy];
    return c;
}

- (NSDictionary *)writeToJSONDictionary:(NSString *)path
{
    NSMutableDictionary *feed = [[NSMutableDictionary alloc] init];
    [feed setObject:[NSDictionary dictionaryWithObject:[self title] forKey:@"label"] forKey:@"title"];
    [feed setObject:[NSDictionary dictionaryWithObject:[self infoString] forKey:@"label"] forKey:@"rights"];
    NSMutableArray *entries = [[NSMutableArray alloc] init];
    for (RSSItem *item in items) {
        NSDictionary *entry = [item writeToJSONDictionary:path];
        [entries addObject:entry];
    }
    [feed setObject:entries forKey:@"entry"];

    NSMutableDictionary *root = [[NSMutableDictionary alloc] init];
    [root setObject:feed forKey:@"feed"];
    if ([root writeToFile:path atomically:YES]) {
        
    }
    return root;
}
















@end
