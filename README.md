DynamicGraphView
================

A simple but effective dynamic GraphView implementation for iPhone SDK for float values.

The left image shows a graph with only positive values and without curved lines. The right graph draws from positve and negative values and has the option for curved lines activated.

![Screenshot](http://i.imgur.com/Kur98cx.png)-----![Screenshot](http://i.imgur.com/uN8ddq8.jpg)

Implementing this control into your project is very easy.

#####1) Copy both GraphView.h and GraphView.m into your projet resources.

#####2) In your ViewController.h:


    import <UIKit/UIKit.h>
    import "GraphView.h"


    @interface ViewController : UIViewController <UITextFieldDelegate> {
    
    GraphView *graphView;
    
    }

    @property (strong, nonatomic) GraphView *graphView;

    @end

#####3) In your ViewController.m:

    - (void)viewDidLoad 
    {
    graphView = [[GraphView alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, 180)];
    [graphView setBackgroundColor:[UIColor yellowColor]];
    [graphView setSpacing:10];
    [graphView setFill:YES];
    [graphView setStrokeColor:[UIColor redColor]];
    [graphView setZeroLineStrokeColor:[UIColor greenColor]];
    [graphView setFillColor:[UIColor orangeColor]];
    [graphView setLineWidth:2];
    [graphView setCurvedLines:YES];
    [self.view addSubview:graphView];
    }

Done!

#####To control the graph, use following functions:

1) This will display a graph of float values:

    [graphView setArray:(NSArray)]

2) This will add a point to the graph. You can add as many as you like and even do this dynamically. The graph will update every time a new value has been added:

    [graphView setPoint:(float)]

3) This will reset the graph to all 0 values:

    [graphView resetGraph]

4) This sets the number of values displayed in the graph:

    [graphView setNumberOfPointsInGraph:(int)]

5) This will make the space beneth the graph line fill or not:

    [graphView setFill:(BOOL)]

Thats all! 

If you have any more question, please read the comments in GraphView.h and GraphView.m or send me a message.

Please concider the MIT License agreement.

