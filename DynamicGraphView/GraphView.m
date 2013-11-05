//
//  GraphView.m
//  DynamicGraphView
//
//  Created by Bastian Kohlbauer on 08.06.13.
//  Copyright (c) 2013 Bastian Kohlbauer. All rights reserved.
//
/*
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "GraphView.h"

@implementation GraphView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupGraph];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupGraph];
    }
    
    return self;
}

- (void)setupGraph
{
    // Initialization code
    
    self.backgroundColor = [UIColor yellowColor];
    
    fillGraph = YES;
    
    spacing = 10;
    
    strokeColor = [UIColor redColor];
    
    fillColor = [UIColor orangeColor];
    
    zeroLineStrokeColor = [UIColor greenColor];
    
    lineWidth = 2;
    
    max = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 25, 16)];
    [max setAdjustsFontSizeToFitWidth:YES];
    [max setBackgroundColor:[UIColor clearColor]];
    [max setTextColor:[UIColor blackColor]];
    [max setText:@"10"];
    [self addSubview:max];
    
    zero = [[UILabel alloc] initWithFrame:CGRectMake(2, CGRectGetMidY(self.frame) - 7.5, 25, 16)];
    [zero setAdjustsFontSizeToFitWidth:YES];
    [zero setBackgroundColor:[UIColor clearColor]];
    [zero setTextColor:[UIColor blackColor]];
    [self addSubview:zero];
    
    min = [[UILabel alloc] initWithFrame:CGRectMake(2, CGRectGetHeight(self.frame)-15, 25, 16)];
    [min setAdjustsFontSizeToFitWidth:YES];
    [min setBackgroundColor:[UIColor clearColor]];
    [min setTextColor:[UIColor blackColor]];
    [min setText:@"0"];
    [self addSubview:min];
    
    dx = 50; // number of points shown in graph
    dy = 100; // default value for dy
    
    pointArray = [[NSMutableArray alloc]init]; //stores the energy values
    for (int i = 0; i < dx; i++) {
        [pointArray addObject:@0.0f];
    }
}

-(void)setPoint:(float)point {
    
    [pointArray insertObject:@(point) atIndex:0];
    [pointArray removeObjectAtIndex:[pointArray count] - 1];
    
    [self setNeedsDisplay];
}

-(void)resetGraph {
    
    pointArray = [[NSMutableArray alloc]init]; //stores the energy values
    for (int i = 0; i < dx; i++) {
        [pointArray addObject:@0.0f];
    }
    
    [self setNeedsDisplay];
    
}

-(void)setArray:(NSArray*)array {
    
    pointArray = [[NSMutableArray alloc]initWithArray:array];
    
    dx = [pointArray count];
    
    [self setNeedsDisplay];
}

-(void)setSpacing:(int)space {
    
    spacing = space;
    
    [self setNeedsDisplay];
}

-(void)setFill:(BOOL)fill {
    
    fillGraph = fill;
    
    [self setNeedsDisplay];
}

-(void)setStrokeColor:(UIColor*)color {
    
    strokeColor = color;
    
    [self setNeedsDisplay];
}

-(void)setZeroLineStrokeColor:(UIColor*)color {
    
    zeroLineStrokeColor = color;
    
    [self setNeedsDisplay];
}

-(void)setFillColor:(UIColor*)color {
    
    fillColor = color;
    
    [self setNeedsDisplay];
}

-(void)setLineWidth:(int)width {
    
    lineWidth = width;
    
    [self setNeedsDisplay];
}

-(void)setNumberOfPointsInGraph:(int)numberOfPoints {
    
    dx = numberOfPoints;
    
    if ([pointArray count] < dx) {
        
        int dCount = dx - [pointArray count];
        
        for (int i = 0; i < dCount; i++) {
            [pointArray addObject:@(0.0f)];
        }
        
    }
    
    if ([pointArray count] > dx) {
        
        int dCount = [pointArray count] - dx;
        
        for (int i = 0; i < dCount; i++) {
            [pointArray removeLastObject];
        }
        
    }
    
    [self setNeedsDisplay];
    
}

-(void)setCurvedLines:(BOOL)curved {
    
    //the granularity value sets "curviness" of the graph depending on amount wanted and precission of the graph
    
    if (curved == YES) {
        granularity = 20;
    }else{
        granularity = 0;
    }
}

// here the graph is actually being drawn
- (void)drawRect:(CGRect)rect {
    
    [self calculateHeight];
    
    // draw null line in the middle
    if (setZero == 2) {
        
        [zeroLineStrokeColor setStroke];
        
        UIBezierPath *zeroLine = [UIBezierPath bezierPath];
        [zeroLine moveToPoint:CGPointMake(0, self.frame.size.height/2)];
        [zeroLine addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height/2)];
        zeroLine.lineWidth = lineWidth; // line width
        [zeroLine stroke];
    }
    
    CGPoint leftBottom = CGPointMake(0, self.frame.size.height);
    CGPoint rightBottom = CGPointMake(self.frame.size.width, self.frame.size.height);
    
    NSMutableArray *points = [[self arrayOfPoints] mutableCopy];
    
    // Add control points to make the math make sense
    [points insertObject:points[0] atIndex:0];
    [points addObject:[points lastObject]];
    
    UIBezierPath *lineGraph = [UIBezierPath bezierPath];
    
    [lineGraph moveToPoint:[points[0] CGPointValue]];
    
    for (NSUInteger index = 1; index < points.count - 2; index++)
    {
        
        CGPoint p0 = [(NSValue *)points[index - 1] CGPointValue];
        CGPoint p1 = [(NSValue *)points[index] CGPointValue];
        CGPoint p2 = [(NSValue *)points[index + 1] CGPointValue];
        CGPoint p3 = [(NSValue *)points[index + 2] CGPointValue];
        
        // now add n points starting at p1 + dx/dy up until p2 using Catmull-Rom splines
        for (int i = 1; i < granularity; i++)
        {
            float t = (float) i * (1.0f / (float) granularity);
            float tt = t * t;
            float ttt = tt * t;
            
            CGPoint pi; // intermediate point
            pi.x = 0.5 * (2*p1.x+(p2.x-p0.x)*t + (2*p0.x-5*p1.x+4*p2.x-p3.x)*tt + (3*p1.x-p0.x-3*p2.x+p3.x)*ttt);
            pi.y = 0.5 * (2*p1.y+(p2.y-p0.y)*t + (2*p0.y-5*p1.y+4*p2.y-p3.y)*tt + (3*p1.y-p0.y-3*p2.y+p3.y)*ttt);
            [lineGraph addLineToPoint:pi];
        }
        
        // Now add p2
        [lineGraph addLineToPoint:p2];
    }
    
    // finish by adding the last point
    [lineGraph addLineToPoint:[(NSValue *)points[(points.count - 1)] CGPointValue]];
    
    [fillColor setFill];
    [strokeColor setStroke];
    
    if (fillGraph) {
        [lineGraph addLineToPoint:CGPointMake(leftBottom.x, leftBottom.y)];
        [lineGraph addLineToPoint:CGPointMake(rightBottom.x, rightBottom.y)];
        [lineGraph closePath];
        [lineGraph fill]; // fill color (if closed)
    }
    
    lineGraph.lineCapStyle = kCGLineCapRound;
    lineGraph.lineJoinStyle = kCGLineJoinRound;
    lineGraph.flatness = 0.5;
    lineGraph.lineWidth = lineWidth; // line width
    [lineGraph stroke];
    
    
}

- (NSArray*)arrayOfPoints {
    
    NSMutableArray *points = [NSMutableArray array];
    
    int viewWidth = CGRectGetWidth(self.frame);
    int viewHeight = CGRectGetHeight(self.frame);
    
    for (int i = 0; i < [pointArray count]; i++) {
        
        
        float point1x = viewWidth - (viewWidth / dx) * i; // start graph x on the right hand side
        float point1y = (viewHeight - (viewHeight / dy) * [pointArray[i] floatValue]) / setZero; //start graph y on the bottom
        
        float point2x = viewWidth - (viewWidth / dx) * i - (viewWidth / dx);
        float point2y = point1y;
        
        if (i != [pointArray count]-1) {
            point2y = (viewHeight - (viewHeight / dy) * [pointArray[i+1] floatValue]) / setZero;
        }
        
        CGPoint p;
        
        if (i == 0) {
            p = CGPointMake(point1x, point1y);
        }else{
            p = CGPointMake(point2x, point2y);
        }
        [points addObject:[NSValue valueWithCGPoint:p]];
        
        NSLog(@"point: %@", NSStringFromCGPoint(p));
    }
    
    return points;
    
}

// this is where the dynamic height of the graph is calculated
-(void)calculateHeight {
    
    int minValue = [[pointArray valueForKeyPath:@"@min.self"] integerValue];
    int maxValue = [[pointArray valueForKeyPath:@"@max.self"] integerValue];
    
    dy = maxValue + abs(minValue) + spacing;
    
    // set maxValue and round the float
    [max setText:[NSString stringWithFormat:@"%i", (int)(dy + 0.0) ]];
    
    
    // set graphView for values below 0
    if (minValue < 0) {
        setZero = 2;
        [zero setText:@"0"];
        [min setText:[NSString stringWithFormat:@"-%i", (int)(dy + 0.0) ]];
    }else{
        setZero = 1;
        [zero setText:@""];
        [min setText:[NSString stringWithFormat:@"0"]];
    }
}

// hides the axis labels
- (void)hideAxis:(BOOL)yesOrNo
{
    [max setHidden:yesOrNo];
    [min setHidden:yesOrNo];
    [zero setHidden:yesOrNo];
}

@end
