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
    WSLog(@"\t%@ found a %@ element", self, elementName);
    
    if ([elementName isEqual:@"title"])
    {
        currentString = [[NSMutableString alloc] init];
        [self setTitle:currentString];
    } else if ([elementName isEqual:@"description"]) {
        currentString = [[NSMutableString alloc] init];
        [self setInfoString:currentString];
    } else if ([elementName isEqual:@"item"]) {
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

    NSRegularExpression *reg = [[NSRegularExpression alloc] initWithPattern:@"(.*) :: (.*) :: .*" options:0 error:nil];

    // Bronze Challenge: Finding the Subforum
    NSRegularExpression *replyReg = [[NSRegularExpression alloc] initWithPattern:@"Re: " options:0 error:nil];
    
    // Loop through everty title of the items in channel
    for (RSSItem *i in items) {
        NSLog(@"%@",[i title]);
        NSString *itemTitle = [[i title] mutableCopy];
        
        // Find matches in the title string. The range
        // argument specifies how much of the title to search;
        // in this case, all of it
        NSArray *matches = [reg matchesInString:itemTitle options:0 range:NSMakeRange(0, [itemTitle length])];
        
        if ([matches count] > 0) {
            // Print the location of the match in the string and the string
            NSTextCheckingResult *result = [matches objectAtIndex:0];
            
            // One capture group, so two ranges
            if ([result numberOfRanges] == 3) {
                NSRange r = [result rangeAtIndex:1];
                [i setSubForum:[itemTitle substringWithRange:r]];
                
                // Silver Challenge: Processing the Reply
                // Pull out the 2nd range, which will be capture group
                r = [result rangeAtIndex:2];
                // Set the title of the item to the string within the capture group
                NSMutableString *newTitle = [[itemTitle substringWithRange:r] mutableCopy];
                NSTextCheckingResult *ms = [replyReg firstMatchInString:newTitle options:0 range:NSMakeRange(0,[newTitle length])];
                if (ms) {
                    NSRange range = [ms range];
                    [newTitle deleteCharactersInRange:range];
                    [i setTitle:newTitle];
                } else {
                    [i setTitle:newTitle];
                }
                [self setParentPostForChild:i];
            }

        }
    }
}

- (BOOL)setParentPostForChild:(RSSItem *)i
{
    for (RSSItem *item in [self items]) {
        if ([item  isChild]) {
            continue;
        }
        if (![i isEqual:item] && [[i title] isEqualToString:[item title]]) {
            [i setParentPost:item];
            return YES;
        }
    }
    return NO;
}

- (NSMutableArray *)parentPosts
{
    NSMutableArray *parentPosts = [[NSMutableArray alloc] init];
    for (RSSItem* i in items) {
        if (![i isChild]) {
            [parentPosts addObject:i];
        }
    }
    return parentPosts;
}

















@end
