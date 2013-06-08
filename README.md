DynamicGraphView
================

A simple but effective dynamic GraphView implementation for iPhone SDK for float values >= 0.

Implementing this control into your project is very easy.

1. Copy both GraphView.h and GraphView.m into your projet resources. 

2. Into your ViewController.h include:
      
#import <UIKit/UIKit.h>
#import "GraphView.h"

@interface ViewController : UIViewController <UITextFieldDelegate> {
    
    GraphView *graphView;
    
}

@property (strong, nonatomic) GraphView *graphView;

@end

3. In your ViewController.m:

- (void)viewDidLoad 
{
    graphView = [[GraphView alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, 180)];
    [graphView setBackgroundColor:[UIColor yellowColor]];
    [graphView setSpacing:10];
    [graphView setFill:YES];
    [graphView setStrokeColor:[UIColor redColor]];
    [graphView setFillColor:[UIColor orangeColor]];
    [graphView setLineWidth:2];
    [self.view addSubview:graphView];
}

Done!


To control the graph, use following functions:

1. [graphView setArray:(NSArray)] - This will display a graph of float values

2. [graphView setPoint:(float)]; - This will add a point to the graph. You can add as many as you like and even do this dynamically. The graph will update every time a new value has been added.

3. [graphView resetGraph] - This will reset the graph to all 0 values.

4. [graphView setNumberOfPointsInGraph:(int)] - This sets the number of values displayed in the graph

5. [graphView setFill:(BOOL)] - This will make the space beneth the graph line fill or not.

Thats all! If you have any more question, please read the comments in GraphView.h and GraphView.m or send me a message.
Please concider the license agreement.
