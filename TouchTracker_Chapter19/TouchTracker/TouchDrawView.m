//
//  TouchDrawView.m
//  TouchTracker
//
//  Created by Long Vinh Nguyen on 2/5/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import "TouchDrawView.h"
#import "Line.h"
#import "LineStore.h"

@implementation TouchDrawView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        lineInProcess = [[NSMutableDictionary alloc] init];
        circleInProcess = [[NSMutableDictionary alloc] init];
        
        completeLines = [[LineStore sharedStore] lineStore];
        if (!completeLines) {
            completeLines = [[NSMutableArray alloc] init];
        }
        
        circleCompletes = [[NSMutableArray alloc] init];

        [self setBackgroundColor:[UIColor whiteColor]];
        
        [self setMultipleTouchEnabled:YES];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 10.0);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    // Draw complete lines in black
    // [[UIColor redColor] set];
    
    // Silver Challenge - Colors
 
    
    for (Line *line in completeLines) {
        float angleVal = atan2([line end].x - [line begin].x, [line end].y - [line begin].y);
        if (angleVal > 1) {
            [[UIColor purpleColor] set];
        } else if (angleVal < 0)
        {
            [[UIColor cyanColor] set];
        } else {
            [[UIColor redColor] set];
        }

        CGContextMoveToPoint(context, [line begin].x, [line begin].y);
        CGContextAddLineToPoint(context, [line end].x, [line end].y);
        CGContextStrokePath(context);
    }
    
    
    // Draw lines in process in black
    [[UIColor blackColor] set];
    for (NSValue *v in lineInProcess) {
        Line *l = [lineInProcess objectForKey:v];
        CGContextMoveToPoint(context, [l begin].x, [l begin].y);
        CGContextAddLineToPoint(context, [l end].x, [l end].y);
        CGContextStrokePath(context);
    }
    
    // Draw a circle
    [[UIColor yellowColor] set];
    if ([circleInProcess count] == 2) {
        NSMutableArray *circlePoints = [[NSMutableArray alloc] init];
        for (NSValue *v in circleInProcess) 
            [circlePoints addObject:[circleInProcess objectForKey:v]];
        Line *point1 = [circlePoints objectAtIndex:0];
        Line *point2 = [circlePoints objectAtIndex:1];
        
        CGFloat radius = hypotf([point1 end].x - [point2 end].x, [point1 end].y - [point2 end].y) / 2;
        CGPoint center;
        center.x = ([point1 end].x + [point2 end].x) / 2;
        center.y = ([point1 end].y + [point2 end].y) / 2;
        
        CGContextAddArc(context, center.x, center.y, radius, 0, M_PI * 2, YES);
        CGContextStrokePath(context);
        
    }

    [[UIColor redColor]set];
    for (int i = 0; i < [circleCompletes count]; i += 2) {
        Line *point1 = [circleCompletes objectAtIndex:i];
        Line *point2 = [circleCompletes objectAtIndex:i+1];
    
        
        CGFloat radius = hypotf([point1 end].x - [point2 end].x, [point1 end].y - [point2 end].y) / 2;
        CGPoint center;
        center.x = ([point1 end].x + [point2 end].x) / 2;
        center.y = ([point1 end].y + [point2 end].y) / 2;
        
        CGContextAddArc(context, center.x, center.y, radius, 0, M_PI * 2, YES);
        CGContextStrokePath(context);
    }

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesBegan");
    {
        for (UITouch *t in touches) {
            // Is this double tap
            if ([t tapCount] > 1 && [touches count] != 2) {
                NSLog(@"Clear");
                [self clearAll];
                return;
            }
            
            // Use the touch object (packed in an NSValue) as the key
            NSValue *key = [NSValue valueWithNonretainedObject:t];
            
            // Create a line for the value
            CGPoint loc = [t locationInView:self];
            Line *newLine = [[Line alloc] init];
            [newLine setBegin:loc];
            [newLine setEnd:loc];
            if ([touches count] == 2) {
                [circleInProcess setObject:newLine forKey:key];
            } else {
                // Put pair in dictionary
                [lineInProcess setObject:newLine forKey:key];
            }
            

        }
    }
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Update linesInProcess with moved touches
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        Line *l;
        // Update the line
        CGPoint loc = [t locationInView:self];
        
        if ([touches count] == 2) {
            l = [circleInProcess objectForKey:key];
        } else {
            // Fine the linw for this touch
            l = [lineInProcess objectForKey:key];
        }
        
        [l setEnd:loc];
    }
    
    // Redraw
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endTouches:touches];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endTouches:touches];
}

-(void)endTouches:(NSSet *)touches
{
    // Remove ending touches from dictionary
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        Line *line;
        
        // If this a double tap, 'line' will be nil
            if ([touches count] == 2) {
                line = [circleInProcess objectForKey:key];
                [circleCompletes addObject:line];
                [circleInProcess removeObjectForKey:key];
            } else {
                line = [lineInProcess objectForKey:key];
                [completeLines addObject:line];
                [lineInProcess removeObjectForKey:key];
            }
        
        
        // Redraw
        [self setNeedsDisplay];
    }
}

- (void)clearAll
{
    [lineInProcess removeAllObjects];
    [completeLines removeAllObjects];
    
    // Redrawn
    [self setNeedsDisplay];
}











@end
