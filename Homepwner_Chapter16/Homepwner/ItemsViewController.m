//
//  ItemsViewController.m
//  Homepwner
//
//  Created by Long Vinh Nguyen on 1/28/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import "ItemsViewController.h"
#import "BNRItemStore.h"
#import "BNRItem.h"
#import "DetailViewController.h"
#import "HomepwnerItemCell.h"
#import "BNRImageStore.h"
#import "ImageViewController.h"

#define kHomepwnerItemCell @"HomepwnerItemCell"
#define kSearchItemCell @"SearchItemCell"

@implementation ItemsViewController
@synthesize filteredItems;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[self navigationItem] setTitle:@"Homepwner"];
        
        // Create a new bar button item that will send
        // addNewItem: to ItemsViewController
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        [[self navigationItem] setRightBarButtonItem:bbi];
        [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
        filteredItems = [[NSMutableArray alloc] init];
    }
    return self;
}

-(id)init
{
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        [[self navigationItem] setTitle:@"Homepwner"];
        
        // Create a new bar button item that will send
        // addNewItem: to ItemsViewController
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        [[self navigationItem] setRightBarButtonItem:bbi];
        [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
    }
    return self;
}

-(id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchDisplayController.searchResultsTableView == tableView) {
        return [self.filteredItems count];
    } else
        return [[[BNRItemStore sharedStore] allItems] count];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    // Load the nib file
    UINib *nib = [UINib nibWithNibName:@"HomepwnerItemCell" bundle:nil];
    
    
    // Register this NIB which contains the cell
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"HomepwnerItemCell"];
    [self.searchDisplayController.searchResultsTableView registerNib:nib forCellReuseIdentifier:@"SearchItemCell"];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    
    // Set the text on the cell with the description of the item
    // that is at the nth index of items, where = row this cell
    // will appear in on the tableview
    // HomepwnerItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomepwnerItemCell"];
    HomepwnerItemCell *cell;
    BNRItem *p;
    if (self.searchDisplayController.searchResultsTableView == tableView) {
        cell = (HomepwnerItemCell *)[[[NSBundle mainBundle] loadNibNamed:kHomepwnerItemCell owner:nil options:nil] objectAtIndex:0];
        //[cell.valueStepper setHidden:YES];
        p =[self.filteredItems objectAtIndex:indexPath.row];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:kHomepwnerItemCell];
        [cell.valueStepper setHidden:NO];
        p = [[[BNRItemStore sharedStore] allItems] objectAtIndex:[indexPath row]];
    }

    
    [cell setController:self];
    [cell setTableView:tableView];
    
    // Configure the cell with the BNRItem
    [[cell nameLabel] setText:[p itemName]];
    [[cell serialNumberLabel] setText:[p serialNumber]];
    
    NSString *currencySymbol = [[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol];
    [[cell valueLabel] setText: [NSString stringWithFormat:@"%@%d",currencySymbol, [p valueInDollars]]];
    [[cell thumbnailView] setImage:[p thumbnail]];
    [cell.valueStepper setValue:(double)p.valueInDollars];
    
    if ([p valueInDollars] > 500) {
        [[cell valueLabel] setTextColor:[UIColor greenColor]];
    } else [[cell valueLabel] setTextColor:[UIColor redColor]];    
    
    return cell;
}


- (void)addNewItem:(id)sender
{
    // Make a new index path for the 0th section, last row
    BNRItem *newItem = [[BNRItemStore sharedStore] createItem];
    
    DetailViewController *detailViewController = [[DetailViewController alloc] initForNewItem:YES];
    [detailViewController setDismissBlock:^{
        [[self tableView] reloadData];
    }];
    [detailViewController setItem:newItem];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    [navController setModalPresentationStyle:UIModalPresentationFormSheet];
    [navController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    [self presentViewController:navController animated:YES completion:nil];
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If the table view is askig to commit a delete command
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        BNRItemStore *ps = [BNRItemStore sharedStore];
        NSArray *items = [ps allItems];
        BNRItem *p = [items objectAtIndex:[indexPath row]];
        [ps removeItem:p];
        
        // We also remove that row from the table view with an animation
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[BNRItemStore sharedStore] moveItemAtIndex:[sourceIndexPath row] toIndex:[destinationIndexPath row]];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailViewController = [[DetailViewController alloc] initForNewItem:NO];
    BNRItem *selectedItem;
    if (self.searchDisplayController.searchResultsTableView == tableView) {
        selectedItem = [self.filteredItems objectAtIndex:[indexPath row]];
    } else {
        selectedItem = [[[BNRItemStore sharedStore] allItems] objectAtIndex:[indexPath row]];
    }

    [detailViewController setItem:selectedItem];

    
    
    [[self navigationController] pushViewController:detailViewController animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self tableView] reloadData];
    [self.searchDisplayController.searchResultsTableView reloadData];
}


-(NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else return UIInterfaceOrientationPortrait;
}

-(BOOL)shouldAutorotate
{
    return YES;
}

-(void)showImage:(id)sender atIndexPath:(NSIndexPath *)ip
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        // Get the item for the index path
        BNRItem *i = [[[BNRItemStore sharedStore] allItems] objectAtIndex:[ip row]];
        
        NSString *imageKey = [i imageKey];
        
        // If there is no image, we don't need to display anything
        UIImage *img = [[BNRImageStore sharedStore]imageForKey:imageKey];
        if (!img) {
            return;
        }
        
        // Make a rectangle that the frame of the button relative to our table view
        CGRect rect = [[self view] convertRect:[sender bounds] fromView:sender];
        
         // Create a new ImageViewController and set its image
        ImageViewController *ivc = [[ImageViewController alloc] init];
        [ivc setImage:img];
        
        // Present a 600 x 600 popover from the rect
        imagePopover = [[UIPopoverController alloc] initWithContentViewController:ivc];
        [imagePopover setDelegate:self];
        [imagePopover setPopoverContentSize:CGSizeMake(600, 600)];
        [imagePopover presentPopoverFromRect:rect inView:[self view] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

-(void)changeValue:(id)sender atIndexPath:(NSIndexPath *)ip withTableView:(UITableView *)tableView
{
    BNRItem *item = nil;
    if (self.searchDisplayController.searchResultsTableView == tableView) {
        item = [self.filteredItems objectAtIndex:ip.row];
    } else {
        item = [[[BNRItemStore sharedStore] allItems] objectAtIndex:ip.row];
    }
    
    UIStepper *stepper = (UIStepper *)sender;
    [item setValueInDollars:stepper.value];
    [tableView reloadData];
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [imagePopover dismissPopoverAnimated:YES];
    imagePopover =nil;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForString:[self.searchDisplayController.searchBar text]];
    return YES;
}

- (void)filterContentForString:(NSString *)searchString
{
    // clear items in filter
    [self.filteredItems removeAllObjects];
    
    for (BNRItem *item in [[BNRItemStore sharedStore] allItems]) {
        NSComparisonResult result = [item.itemName compare:searchString options: (NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchString length])];
        if (result == NSOrderedSame) {
            [self.filteredItems addObject:item];
        }
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.tableView reloadData];
}


- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView
{
    [self.tableView reloadData];
}


















@end
