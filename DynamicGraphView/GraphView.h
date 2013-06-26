//
//  GraphView.h
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

#import <UIKit/UIKit.h>

@interface GraphView : UIView {
    
    NSMutableArray *pointArray;
    
    float dx; 
    float dy;
    
    int spacing;
    
    BOOL fillGraph;
        
    UILabel *max;
    UILabel *zero;
    UILabel *min;
    
    int setZero;
    
    UIColor *strokeColor;
    UIColor *fillColor;
    
    UIColor *zeroLineStrokeColor;
    
    int lineWidth;
    
    int granularity;
    
}

// add point to the array dynamically
-(void)setPoint:(float)point;

// reset graph to all 0.0 values
-(void)resetGraph;

// set an array of alues to be displayed in a the graph
-(void)setArray:(NSArray*)array ;

// set the spacing from the max value in graph array to top of view. default = 10.
-(void)setSpacing:(int)space;

// set the view to fill below graph. default = YES
-(void)setFill:(BOOL)fill;

// set the color of the graph line. default = [UIColor redColor].
-(void)setStrokeColor:(UIColor*)color;

// set the color of the zero line. default = [UIColor greenColor].
-(void)setZeroLineStrokeColor:(UIColor*)color;

// set the filled space below graph. default = [UIColor orangeColor].
-(void)setFillColor:(UIColor*)color;

// set the color of the graph line. default = 2.
-(void)setLineWidth:(int)width;

// set up the number of values diplayes in the graph along the x-axis
-(void)setNumberOfPointsInGraph:(int)numberOfPoints;

// set curved graph lines. default = YES;
-(void)setCurvedLines:(BOOL)curved;

@end
