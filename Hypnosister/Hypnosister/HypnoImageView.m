//
//  HypnoImageView.m
//  Hypnosister
//
//  Created by Long Vinh Nguyen on 1/28/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import "HypnoImageView.h"

@implementation HypnoImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    CGPoint center;
    center.x = rect.size.width / 2;
    center.y = rect.size.height / 2;
    
    float maxRadius = hypotf(rect.size.width, rect.size.height) / 3;
    
    // Gold challenge - Another View and Curves
    
    // Image clip

    
    UIBezierPath *circleImage = [UIBezierPath bezierPathWithArcCenter: center radius:maxRadius startAngle:0.0 endAngle:M_PI *2 clockwise:YES];
    [circleImage setLineWidth:2.0];
    [[UIColor blackColor] setStroke];

    // Offset
    // Set the fill color of the current context to black
    [[UIColor blackColor] setFill];
    // The shadow will move 4 points to the right and 3 points down from the text
    CGSize offset = CGSizeMake(4, 3);
    // The shadow will be dark gray in color
    CGColorRef color = [[UIColor darkTextColor] CGColor];
    // Set the shadow of the context with these parameters,
    // all subsequent drawing will be shadowed
    CGContextSetShadowWithColor(ctx, offset, 2.0, color);
    [circleImage stroke];
    CGContextRestoreGState(ctx);
    
    [circleImage addClip];
    UIImage *img = [UIImage imageNamed:@"Icon.png"];
    [img drawInRect:rect];
    
    
    
    // Gradient
    CGColorSpaceRef colorSpace;
    colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[2] = {0.0, 1.0};
    CGFloat components[8] = {1.0, 0.0, 1.0, 0.0, // start color
        0.0, 1.0, 0.0, 1.0}; // end color
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
    CGPoint startPoint, endPoint;
    startPoint = rect.origin;
    endPoint.x = rect.origin.x;
    endPoint.y = rect.origin.y + rect.size.height / 2;
    CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
}

@end
