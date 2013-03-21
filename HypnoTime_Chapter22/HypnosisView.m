//
//  HypnosisView.m
//  Hypnosister
//
//  Created by Long Vinh Nguyen on 1/24/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import "HypnosisView.h"

@implementation HypnosisView
@synthesize circleColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // All HypnosisterView start with a clear background color
        [self setBackgroundColor:[UIColor clearColor]];
        [self setCircleColor:[UIColor lightGrayColor]];
        
        // Create a new layer object
        boxLayer = [[CALayer alloc] init];
        
        [boxLayer setBounds:CGRectMake(0.0, 0.0,85, 85)];
        [boxLayer setPosition:CGPointMake(160, 100)];
        
        UIColor *reddish = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.5];
        
        [boxLayer setBackgroundColor:[reddish CGColor]];
        
        // Create a UIImage
        UIImage *layerImage = [UIImage imageNamed:@"Hypno.png"];
        
        // Get the underlying CGImage
        CGImageRef image = [layerImage CGImage];
        
        // Put the CGImage on the layer
        [boxLayer setContents:(__bridge id)image];
        
        // Insert the image a bit on each side
        [boxLayer setContentsRect:CGRectMake(-0.1, -0.1, 1.2, 1.2)];
        [boxLayer setCornerRadius:5.0];
        
        // Let the image resize (without changing the aspect ratio)
        // to fill the contentRect
        [boxLayer setContentsGravity:kCAGravityResizeAspect];
        
        // Gold Challenge: Shadowing
        [boxLayer setShadowColor:[[UIColor blackColor] CGColor]];
        [boxLayer setShadowOpacity:0.5];
        [boxLayer setShadowOffset: CGSizeMake(5.0, 3.0)];
        [boxLayer setShadowRadius:0.0];
        
        
        [[self layer] addSublayer:boxLayer];
        
        // Broze Challenge: Another layer
        anotherLayer = [[CALayer alloc] init];
        [anotherLayer setBackgroundColor:[[UIColor clearColor] CGColor]];

        
        UIImage *layerSlogan = [UIImage imageNamed:@"BlueGlass.jpg"];
        
        CGImageRef slogan = [layerSlogan CGImage];
        [anotherLayer setContents:((__bridge id)slogan)];
        [anotherLayer setContentsGravity:kCAGravityResizeAspect];
        
        [boxLayer addSublayer:anotherLayer];
        
        
        CGPoint center;
        center.x = [boxLayer bounds].size.width / 2;
        center.y = [boxLayer bounds].size.height / 2;

        [anotherLayer setBounds:CGRectMake(0.0, 0.0, [[anotherLayer superlayer] bounds].size.width / 2, [[anotherLayer superlayer] bounds].size.width / 2)];
        
        [anotherLayer setPosition:center];
        [anotherLayer setCornerRadius:5.0];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGRect bounds = [self bounds];
    
    // Figure out the center of the bounds rectangle
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width / 2.0;
    center.y = bounds.origin.y + bounds.size.height/ 2.0;
    
    NSLog(@"%f %f",bounds.origin.x, bounds.origin.y);
    NSLog(@"%f %f",[self frame].origin.x,[self frame].origin.y);
    
    // The radius of the circle shoul be as nearly as big as the view
    float maxRadius = hypot(bounds.size.width, bounds.size.height) / 2.0;
    
    // The thickness of the line should be 10 points wide
    CGContextSetLineWidth(ctx, 10);
    
    // The color of the line should be gray (red, blue, green)

    [[self circleColor] setStroke];
    
    // Draw concentric circles from the outside in
    for (float currentRadius = maxRadius; currentRadius > 0; currentRadius -= 20)
    {
        // Add a path to the context
        CGContextAddArc(ctx, center.x, center.y, currentRadius, 0.0, M_PI * 2.0, YES);
        
        // Performing drawing instruction; remove path
        CGContextStrokePath(ctx);
    }
    
    // Create a string
    NSString *text = @"You are getting sleepy.";
    
    // Get a font to draw it in
    UIFont *font = [UIFont boldSystemFontOfSize:28];
    
    CGRect textRect;
    
    // How big is this string when draw in this font?
    textRect.size = [text sizeWithFont:font];
    
    // Let put that string in the center of the view
    textRect.origin.x = center.x - textRect.size.width / 2.0;
    textRect.origin.y = center.y - textRect.size.height / 2.0;
    
    // Set the fill color of the current context to black
    [[UIColor blackColor] setFill];
    
    // The shadow will move 4 points to the right and 3 points down from the text
    CGSize offset = CGSizeMake(4, 3);
    
    // The shadow will be dark gray in color
    CGColorRef color = [[UIColor darkGrayColor] CGColor];
    
    // Set the shadow of the context with these parameters,
    // all subsequent drawing will be shadowed
    
    CGContextSetShadowWithColor(ctx, offset, 2.0, color);
    
    // Draw the String
    [text drawInRect:textRect withFont:font];

}


- (BOOL)canBecomeFirstResponder
{
    return YES;
    
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{

    if (motion == UIEventSubtypeMotionShake) {
        NSLog(@"Device started shaking");
        [self setCircleColor:[UIColor redColor]];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *t = [touches anyObject];
    CGPoint p = [t locationInView:self];
    [boxLayer setPosition:p];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *t = [touches anyObject];
    CGPoint p = [t locationInView:self];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [boxLayer setPosition:p];
    [CATransaction commit];
    
}

- (void)setCircleColor:(UIColor *)clr
{
    circleColor = clr;
    [self setNeedsDisplay];
}








@end
