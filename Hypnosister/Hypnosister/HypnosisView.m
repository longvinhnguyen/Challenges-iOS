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
    
    // Draw concentric circles from the outside in
    int changeColor = 0;
    for (float currentRadius = maxRadius; currentRadius > 0; currentRadius -= 20)
    {
        // Bronze Challenge
        if (changeColor == 3) {
            changeColor = 0;
        }
        switch (changeColor) {
            case 0:
                [self setCircleColor:[UIColor lightGrayColor]];
                break;
            case 1:
                [self setCircleColor:[UIColor brownColor]];
                break;
            case 2:
                [self setCircleColor:[UIColor blueColor]];
                break;
                
            default: [self setCircleColor:[UIColor redColor]];
                break;
        }
        [[self circleColor] setStroke];
        // Add a path to the context
        CGContextAddArc(ctx, center.x, center.y, currentRadius, 0.0, M_PI * 2.0, YES);
        
        // Performing drawing instruction; remove path
        CGContextStrokePath(ctx);
        changeColor ++;
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
    
    // Silver challenge - Crosshair
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:center radius:30 startAngle:0.0 endAngle:M_PI * 2.0 clockwise:YES];
    [circlePath setLineWidth:5.0];
    [[UIColor greenColor] setStroke];
    [circlePath stroke];
    
    CGContextMoveToPoint(ctx, center.x  - 30, center.y);
    CGContextAddLineToPoint(ctx, center.x + 30, center.y);
    
    CGContextMoveToPoint(ctx, center.x, center.y - 30);
    CGContextAddLineToPoint(ctx, center.x, center.y + 30);
    
    [[UIColor redColor] setStroke];
    CGContextSetLineWidth(ctx, 2);
    CGContextStrokePath(ctx);
    

    
    

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

- (void)setCircleColor:(UIColor *)clr
{
    circleColor = clr;
    [self setNeedsDisplay];
}






@end
