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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor yellowColor];
        
        fillGraph = YES;
        
        spaceing = 10;
        
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
        
        zero = [[UILabel alloc] initWithFrame:CGRectMake(2, (self.frame.size.height/2)-7.5, 25, 16)];
        [zero setAdjustsFontSizeToFitWidth:YES];
        [zero setBackgroundColor:[UIColor clearColor]];
        [zero setTextColor:[UIColor blackColor]];
        [self addSubview:zero];
        
        min = [[UILabel alloc] initWithFrame:CGRectMake(2, self.frame.size.height-15, 25, 16)];
        [min setAdjustsFontSizeToFitWidth:YES];
        [min setBackgroundColor:[UIColor clearColor]];
        [min setTextColor:[UIColor blackColor]];
        [min setText:@"0"];
        [self addSubview:min];
        
        dx = 50; // number of points shown in graph
        dy = 100; // default value for dy
        
        pointArray = [[NSMutableArray alloc]init]; //stores the energy values
        for (int i = 0; i < dx; i++) {
            [pointArray addObject:[NSNumber numberWithFloat:0.0f]];
        }
        
    }
    
    return self;
}

-(void)setPoint:(float)point {
    
    NSArray *temp = [[NSArray alloc]initWithArray:pointArray];
    
    //store point in first place and move rest of entries down 1 row
    for (int i = 0; i < [temp count]; i++) {
        
        if (i != 0) { // first row
            
            [pointArray replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:[[temp objectAtIndex:i-1]floatValue]]];
            
        }
        
    }
    
    [pointArray replaceObjectAtIndex:0 withObject:[NSNumber numberWithFloat:point]];
    
    
    
    [self setNeedsDisplay];
}

-(void)resetGraph {
        
    pointArray = [[NSMutableArray alloc]init]; //stores the energy values
    for (int i = 0; i < dx; i++) {
        [pointArray addObject:[NSNumber numberWithFloat:0.0f]];
    }
    
    [self setNeedsDisplay];
    
}

-(void)setArray:(NSArray*)array {
    
    pointArray = [[NSMutableArray alloc]initWithArray:array];
    
    dx = [pointArray count];
    
    [self setNeedsDisplay];
}

-(void)setSpacing:(int)space {
    
    spaceing = space;
    
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
            [pointArray addObject:[NSNumber numberWithFloat:0.0f]];
        }
        
    }
    
    if ([pointArray count] > dx) {
        
        int dCount = [pointArray count] - dx;
        
        NSArray *temp = [[NSArray alloc]initWithArray:pointArray];
        
        pointArray = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < dCount; i++) {
            [pointArray addObject:[temp objectAtIndex:i]];
        }
        
    }
    
    [self setNeedsDisplay];
    
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
    
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    
    CGPoint leftBottom = CGPointMake(0, self.frame.size.height);
    CGPoint rightBottom = CGPointMake(self.frame.size.width, self.frame.size.height);
    
    
    for (int i = 0; i < [pointArray count]; i++) {
        
        int viewWidth = self.frame.size.width;
        int viewHeight = self.frame.size.height;
        
        float point1x = viewWidth - (viewWidth / dx) * i; // start graph x on the right hand side
        float point1y = (viewHeight - (viewHeight / dy) * [[pointArray objectAtIndex:i]floatValue]) / setZero; //start graph y on the bottom
        
        float point2x = viewWidth - (viewWidth / dx) * i - (viewWidth / dx);
        float point2y = point1y;
        
        if (i != [pointArray count]-1) {
            point2y = (viewHeight - (viewHeight / dy) * [[pointArray objectAtIndex:i+1]floatValue]) / setZero;
        }
        
        if (i == 0) {
            // Set the starting point of the shape.
            [aPath moveToPoint:CGPointMake(point1x, point1y)];
        }else{
            [aPath addLineToPoint:CGPointMake(point2x, point2y)];
        }
        
        
    }
    
    [aPath addLineToPoint:CGPointMake(leftBottom.x, leftBottom.y)];
    [aPath addLineToPoint:CGPointMake(rightBottom.x, rightBottom.y)];
    
    
    [fillColor setFill];
    [strokeColor setStroke];
    
    if (fillGraph) {
        [aPath closePath];
        [aPath fill]; // fill color (if closed)
    }
    
    aPath.lineCapStyle = kCGLineCapRound;
    aPath.lineJoinStyle = kCGLineJoinRound;
    aPath.flatness = 0.5;
    aPath.lineWidth = lineWidth; // line width
    [aPath stroke]; // linke color
    
    
}

// this is where the dynamic height of the graph is calculated
-(void)calculateHeight {
    
    // get maxValue for dy
    int maxValue = 0;
    for (int i = 0; i < [pointArray count]; i++) {
        if (maxValue < [[pointArray objectAtIndex:i]integerValue]) {
            maxValue = [[pointArray objectAtIndex:i]integerValue];
        }
    }
    
    // get minValue for dy
    int minValue = 0;
    for (int i = 0; i < [pointArray count]; i++) {
        if (minValue > [[pointArray objectAtIndex:i]integerValue]) {
            minValue = [[pointArray objectAtIndex:i]integerValue];
        }
    }
    
    dy = maxValue + abs(minValue) + spaceing;
    
    // set maxValue and round the float
    [max setText:[NSString stringWithFormat:@"%i", (int)(dy + 0.0) ]];
    
    
    // set graphView for values below 0
    if (minValue < 0) {
        setZero = 2;
        [zero setText:@"0"];
        [min setText:[NSString stringWithFormat:@"%i", (int)(dy + 0.0) ]];
    }else{
        setZero = 1;
        [zero setText:@""];
        [min setText:[NSString stringWithFormat:@"0"]];
    }

    
}

@end
