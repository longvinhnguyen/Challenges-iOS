//
//  CameraOverlayView.m
//  Homepwner
//
//  Created by Long Vinh Nguyen on 1/30/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import "CameraOverlayView.h"

@implementation CameraOverlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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
    
    UIBezierPath *crossHair = [UIBezierPath bezierPathWithArcCenter:center radius: 10 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    [crossHair setLineWidth:2];
    [[UIColor yellowColor] setStroke];
    [crossHair stroke];
    
    CGContextRestoreGState(ctx);
    
    CGContextMoveToPoint(ctx, center.x, center.y - 10);
    CGContextAddLineToPoint(ctx, center.x, center.y +10 );
    
    CGContextMoveToPoint(ctx, center.x - 10, center.y);
    CGContextAddLineToPoint(ctx, center.x + 10, center.y);
    
    CGContextSetLineWidth(ctx, 2.0);
    [[UIColor blackColor] setStroke];
    
    CGContextStrokePath(ctx);    
    
    
}
@end
