//
//  DetailViewController.m
//  ClassSchedule
//
//  Created by Long Vinh Nguyen on 2/19/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import "DetailViewController.h"
#import "RSSClass.h"


@implementation DetailViewController
@synthesize item;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSLog(@"%@",[dateFormatter stringFromDate:[[NSDate alloc] init]]);
    
    // [tbTextField setText:[NSString stringWithFormat:@"%@",[item timeBegin]]];
    [tbTextField setText:[dateFormatter stringFromDate:[[NSDate alloc] init]]];
    [teTextField setText:[NSString stringWithFormat:@"%@",[item timeEnd]]];
    [instructorTextField setText:[item instructor]];
    NSLocale *cl = [NSLocale currentLocale];
    [priceTextField setText:[NSString stringWithFormat:@"%d%@",[item price],[cl objectForKey:NSLocaleCurrencySymbol]]];
    [locTextField setText:[item location]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setItem:(RSSClass *)i
{
    item = i;
    [[self navigationItem] setTitle:[NSString stringWithFormat:@"%@:%@",[item title],[item region]]];
}


- (void)listViewControllerHandle:(ListViewController *)vc withObject:(id)obj
{
    RSSClass *i = obj;
    // Make sure that the ListViewController gave the right object
    if (![i isKindOfClass:[RSSClass class]]) {
        return;
    }
    item = i;
    [[self navigationItem] setTitle:[item title]];
    [self viewWillAppear:YES];
}

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    [barButtonItem setTitle:@"List"];
    [[self navigationItem] setLeftBarButtonItem:barButtonItem];
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [[self navigationItem] setLeftBarButtonItem:nil];
}



@end
