//
//  AssetTypePicker.m
//  Homepwner
//
//  Created by Long Vinh Nguyen on 2/3/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import "AssetTypePicker.h"
#import "BNRItemStore.h"
#import "BNRItem.h"

@implementation AssetTypePicker
@synthesize item, assetPopover, typeIndexPath;

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        UIBarButtonItem *addNewStyleButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewStyle:)];
        [[self navigationItem] setRightBarButtonItem:addNewStyleButton];
        [self.navigationItem setLeftBarButtonItem:[self editButtonItem]];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
            return [[[BNRItemStore sharedStore] allAssetTypes] count];
    } else return [[[BNRItemStore sharedStore] findItemsHasSameAsset:item] count];

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) return;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    if ([indexPath compare: typeIndexPath] !=  NSOrderedSame) {
        [[tableView cellForRowAtIndexPath:typeIndexPath] setAccessoryType:UITableViewCellAccessoryNone];
    }
    typeIndexPath = indexPath;
    
    NSArray *allAssets = [[BNRItemStore sharedStore] allAssetTypes];
    NSManagedObject *assetType = [allAssets objectAtIndex:[indexPath row]];
    [item setAssetType:assetType];
    [[self navigationController] popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell ==  nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    if ([indexPath section] == 0) {
        NSArray *allAssetTypes = [[BNRItemStore sharedStore] allAssetTypes];
        NSManagedObject *assetType = [allAssetTypes objectAtIndex:[indexPath row]];
        
        
        // Use key value coding to get the asset t
        NSString *assetLabel = [assetType valueForKey:@"label"];
        [[cell textLabel] setText:assetLabel];
        
        // Checkmark the one that is currently selected
        if (assetType == [item assetType]) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            typeIndexPath = indexPath;
        } else {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
    }
    
    if ([indexPath section] == 1) {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        NSArray *items = [[BNRItemStore sharedStore] findItemsHasSameAsset:item];
        BNRItem *i = [items objectAtIndex:indexPath.row];
        [[cell textLabel] setText:[i itemName]];
    }
    
    return cell;
}

- (void)addNewStyle:(id)sender
{
    UIAlertView *newStyleView = [[UIAlertView alloc] initWithTitle:@"Add New Style" message:@"Enter a new style for item" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
    [newStyleView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [newStyleView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSManagedObject *newStyle = [[BNRItemStore sharedStore] addNewStyle];
        [newStyle setValue:[[alertView textFieldAtIndex:0]text] forKey:@"label"];
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [[self tableView] reloadData];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Asset Types";
    } else return @"Assets has same type";
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObject *asset = [[[BNRItemStore sharedStore] allAssetTypes] objectAtIndex:indexPath.row];
        [[BNRItemStore sharedStore] removeAssetType:asset];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath compare:typeIndexPath] == NSOrderedSame) {
        return NO;
    } else if (indexPath.section != 0) return NO;
    return YES;
}



@end
