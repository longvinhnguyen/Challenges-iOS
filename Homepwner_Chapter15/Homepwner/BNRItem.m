//
//  BNRItem.m
//  RandomPossesions
//
//  Created by Long Vinh Nguyen on 1/21/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import "BNRItem.h"

@implementation BNRItem
@synthesize itemName;
@synthesize valueInDollars, serialNumber, dateCreated, imageKey;
@synthesize thumbnail, thumbnailData;

+ (id)randomItem
{
    // Create an array of three adjectives
    NSArray *randomAdjectiveList = [[NSArray alloc] initWithObjects:@"Fluffy",@"Rusty",@"Shiny", nil];
    
    // Create an array of three nouns
    NSArray *randomNounList = [[NSArray alloc] initWithObjects:@"Bear",@"Spork", @"Mac",nil];
    
    // Get the index of a random adjective/noun from the lists
    // Note: The % oprator, called the modulo operator, gives you the reminder, So ajectives is a random number from 0 to 2 inclusive
    NSInteger adjectiveIndex = rand() % [randomAdjectiveList count];
    NSInteger nounIndex = rand() % [randomNounList count];
    
    
    NSString *randomName = [NSString stringWithFormat:@"%@ %@", [randomAdjectiveList objectAtIndex:adjectiveIndex], [randomNounList objectAtIndex:nounIndex]];
    
    int randomValue = rand() % 100;
    
    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c",'0' + rand() % 10, 'A' + rand() % 26,'0' + rand() % 10, 'A' + rand() % 26, '0' + rand() % 10];
    
    BNRItem *newItem = [[self alloc] initWithItemName:randomName valueInDollars:randomValue serialNumber:randomSerialNumber];
    return newItem;
}

- (NSString *)description
{
    NSString *descriptionString = [[NSString alloc] initWithFormat:@"%@ (%@): Worth $%d, recorded on %@", itemName, serialNumber, valueInDollars, dateCreated];

    return descriptionString;
}

- (id)initWithItemName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *)sNumber
{
    // Call the superclass 's designated initializer
    self = [super init];
    
    // Did the superclass's designated initializer succeed?
    if (self) {
        // Give the instance variables initial values
        [self setItemName:name];
        [self setSerialNumber:sNumber];
        [self setValueInDollars:value];
        dateCreated = [[NSDate alloc] init];
    }

    
    return self;
}

- (id)initWithItemName:(NSString *)name serialNumber:(NSString *)sNumber
{
    return [self initWithItemName:name valueInDollars:0 serialNumber:sNumber];
}

- (id)init
{
    return [self initWithItemName:@"Item" valueInDollars:0 serialNumber:@""];
}

- (void)dealloc
{
    NSLog(@"Destroyed: %@",self);
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:itemName forKey:@"itemName"];
    [aCoder encodeObject:serialNumber forKey:@"serialNumber"];
    [aCoder encodeObject:dateCreated forKey:@"dateCreated"];
    [aCoder encodeObject:imageKey forKey:@"imageKey"];
    
    [aCoder encodeInt:valueInDollars forKey:@"valueInDollars"];
    [aCoder encodeObject:thumbnailData forKey:@"thumbnailData"];
    
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self setItemName:[aDecoder decodeObjectForKey:@"itemName"]];
        [self setSerialNumber:[aDecoder decodeObjectForKey:@"serialNumber"]];
        [self setImageKey: [aDecoder decodeObjectForKey:@"imageKey"]];
        
        [self setValueInDollars:[aDecoder decodeIntForKey:@"valueInDollars"]];
        
        dateCreated = [aDecoder decodeObjectForKey:@"dateCreated"];
        [self setThumbnailData:[aDecoder decodeObjectForKey:@"thumbnailData"]];
    }
    return self;
}

- (UIImage *)thumbnail
{
    // If there is no thumbnailData, then I have no thumbnail to return
    if (!thumbnailData)
    {
        return nil;
    }
    
    // If I hvae not yet created my thumbnail image from my data, do so now

    if (!thumbnail)
    {
        // Create thumbnail from data
        thumbnail = [UIImage imageWithData:thumbnailData];
    }
    return thumbnail;

}

- (void)setThumbnailDataFromImage:(UIImage *)image
{
    // The rectangle of thumbnail
    CGRect newRect = CGRectMake(0, 0, 40, 40);
    
    
    // Figure out a scaling ratio to make sure we maintain the same aspect ratio
    float ratio = MAX(newRect.size.width / image.size.width, newRect.size.height / image.size.height);
    
    // Create a transparent bitmap context with a scaling ratio
    // equal to that of the screen
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    
    // Create a path that is rounded rectangle
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:5.0];

    // Make all susequent drawing clip to this rounded rectangle
    [path addClip];

    // Center the imgae in the thumbnail rectangle
    CGRect projectRect;
    projectRect.size.width = ratio * image.size.width;
    projectRect.size.height = ratio * image.size.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.x = (newRect.size.height - projectRect.size.height) / 2.0;
    
    // Draw the image on it
    [image drawInRect:projectRect];

    // Get the image from the image context, keep it as our thumbnail
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    
    [self setThumbnail:smallImage];
    
    NSData *data = UIImagePNGRepresentation(smallImage);
    [self setThumbnailData:data];
    
    // Clean uup image context resource, we're done
    
    
    



    
}













@end
