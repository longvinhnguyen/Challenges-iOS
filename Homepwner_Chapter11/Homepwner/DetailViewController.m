//
//  DetailViewController.m
//  Homepwner
//
//  Created by Long Vinh Nguyen on 1/29/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import "DetailViewController.h"
#import "BNRItem.h"
#import "DatePickerViewController.h"


@implementation DetailViewController
@synthesize item;

-(void)viewDidLoad
{
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [nameField setText:[item itemName]];
    [serialNumberField setText:[item serialNumber]];
    [valueField setText:[NSString stringWithFormat:@"%d",[item valueInDollars]]];
    
    // Create a NSDateFormatter that will turn a date into a simple date string
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    // Use filtered NSDate object to set dateLabel contents
    [dateLabel setText:[dateFormatter stringFromDate:[item dateCreated]]];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Clear first responder
    [[self view] endEditing:YES];
    
    // "Save" changes to item
    [item setItemName:[nameField text]];
    [item setSerialNumber:[serialNumberField text]];
    [item setValueInDollars:[[valueField text] intValue]];
}

-(void)setItem:(BNRItem *)i
{
    item = i;
    [[self navigationItem] setTitle:[item itemName]];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [valueField resignFirstResponder];
}



- (IBAction)changeDate:(id)sender
{
    DatePickerViewController *dpViewController = [[DatePickerViewController alloc] init];
    [dpViewController setItem:[self item]];
    [[self navigationController] pushViewController:dpViewController animated:YES];
}











@end
