//
//  ListViewController.m
//  NerdFeed
//
//  Created by Long Vinh Nguyen on 2/13/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import "ListViewController.h"
#import "RSSChannel.h"
#import "RSSItem.h"
#import "WebViewController.h"
#import "ChannelViewController.h"
#import "ThreadViewController.h"

@implementation ListViewController
@synthesize webViewController, masterButton;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@"Info" style:UIBarButtonItemStyleBordered target:self action:@selector(showInfo:)];
        [[self navigationItem] setRightBarButtonItem:bbi];
        [[self navigationItem] setTitle:@"NERDFEED"];
        
        [self fetchEntries];
    }
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[channel parentPosts] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
    }
    
    // Gold Challenge: Showing Threads
    RSSItem *item = [[channel parentPosts] objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[item title]];
    [[cell detailTextLabel] setText:[item subForum]];
    [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    return cell;
}

-(void)connection:(NSURLConnection *)con didReceiveData:(NSData *)data
{
    // Add the incoming chunk of data to the container we are keeping
    // The data always comes in the correct order
    [xmlData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)con
{
    // Create a parser object with the data received from the web service
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
    
    // Give it a delegate - ignore the warning here for now
    [parser setDelegate:self];
    
    // Tell it to start parsing - the document will be parsed and
    // the delegate of NSXMLParser will get all of its delegate messages
    // sent tot it before this line finishes execution - it is blocking
    [parser parse];
    
    // Get rid of the XML data as we no longer need it
    xmlData = nil;
    
    // Get rid of the connection, no longer need it
    connection = nil;
    
    // Reload the table
    [[self tableView] reloadData];
    
    WSLog(@"%@\n %@\n %@\n", channel, [channel title], [channel infoString]);

    
}

- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error
{
    // Release the connection object, we are done with it
    connection = nil;
    
    // Release the xmlData object, we are done with it
    xmlData = nil;
    
    // Grab the description of the error object passed to us
    NSString *errorString = [NSString stringWithFormat:@"Fetched failed: %@",[error localizedDescription]];
    
    // Create and show an alert view with this error displayed
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [av show];
}

- (void)fetchEntries
{
    // Create a new data container for the stuff that comes from the service
    xmlData = [[NSMutableData alloc] init];
    
    // Construct a URL that will ask the service for what you want
    // note we can concatenate literal strings together on multiple
    // lines in this way - this results in a single NSString instance
    NSURL *url = [NSURL URLWithString:@"http://forums.bignerdranch.com/smartfeed.php?" @"limit=1_DAY&sort_by=standard&feed_type=RSS2.0&feed_style=COMPACT"];
    
    // For Apple's Hot News feed, replace the line above with
    // NSURL *url = [NSURL URLWithString:@"http://images.apple.com/main/rss/hotnews/hotnews.rss"];
    // Put that URL into an NSURLRequest
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    // Create a connection that will exchange this request for data from the URL
    connection = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:YES];
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    WSLog(@"%@ found a %@ element", self, elementName);
    if ([elementName isEqual:@"channel"]) {
        // If the parser saw a channel, create a new instance, store in our ivar
        channel = [[RSSChannel alloc] init];
        
        // Give the channel object a pointer back to ourselves for later
        [channel setParentParserDelegate:self];
        
        // Set the parser's delegate to the channel object
        // There will be a warning here
        [parser setDelegate:channel];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self splitViewController]) {
        // Create the web view controller's view the first time through
        [[self navigationController] pushViewController:webViewController animated:YES];
    } else {
        // We have to create a new navigation controller, as the old one
        // was only retained by the split view controller and is now gone
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webViewController];
        if (UIInterfaceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
            NSLog(@"Master 1:%@", masterButton);
            if (masterButton) {
                [[webViewController navigationItem] setLeftBarButtonItem:masterButton];
            }
        } else {
            [[webViewController navigationItem] setLeftBarButtonItem:nil];
        }

        NSArray *vcs = [NSArray arrayWithObjects:[self navigationController], nav, nil];
        [[self splitViewController] setViewControllers:vcs];
        
        [[self splitViewController] setDelegate:webViewController];

    }
    
    // Grab the selected item
    RSSItem *entry = [[channel items] objectAtIndex:[indexPath row]];
    [webViewController listViewController:self handleObject:entry];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ) {
        return UIInterfaceOrientationLandscapeLeft;
    }
    return UIInterfaceOrientationPortrait;
}

- (void)showInfo:(id)sender
{
    // Create the channel view controller
    ChannelViewController *channelViewController = [[ChannelViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [channelViewController setCompletionBlock:^(UIBarButtonItem *bbi){
        if (![self masterButton]) {
            masterButton = bbi;
        }
    }];
    
    if ([self splitViewController]) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:channelViewController];
        
        if (UIInterfaceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
            if (masterButton) {
                NSLog(@"Master 2:%@", masterButton);
                [[channelViewController navigationItem] setLeftBarButtonItem:masterButton];
            }
        }
        
        // Create an array with our nav controller and this new VC's nav controller
        NSArray *vcs = [NSArray arrayWithObjects:[self navigationController], nav, nil];
        
        // Grab a pointer to the split view controller
        // and reset its view controller array
        [[self splitViewController] setViewControllers:vcs];
        
        // Make the detail view controller the delegate of the split view controller
        [[self splitViewController] setDelegate:channelViewController];
        
        NSIndexPath *selectedRow = [[self tableView] indexPathForSelectedRow];
        if (selectedRow) {
            [[self tableView] deselectRowAtIndexPath:selectedRow animated:YES];
        }
    } else {
        [[self navigationController] pushViewController:channelViewController animated:YES];
    }
    
    // Give the VC the channel object through the protocol message
    [channelViewController listViewController:self handleObject:channel];

}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *parentPosts = [channel parentPosts];
    RSSItem *selectedPost = [parentPosts objectAtIndex:[indexPath row]];
    NSArray *threads = [self findingThreadsForParentPost:selectedPost];
    if ([threads count] > 0) {
        ThreadViewController *threadvc = [[ThreadViewController alloc] initWithStyle:UITableViewStyleGrouped withThreads:threads];
        [threadvc setLvc:self];
        [[self navigationController] pushViewController:threadvc animated:YES];
    }    
}

- (NSArray *)findingThreadsForParentPost:(RSSItem *)i
{
    NSMutableArray *threads = [[NSMutableArray alloc] init];
    for (RSSItem *item in [channel items]) {
        if ([[item parentPost] isEqual:i]) {
            [threads addObject:item];
        }
    }
    return [threads copy];
}













@end
