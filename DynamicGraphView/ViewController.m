//
//  ViewController.m
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

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@end

@implementation ViewController

@synthesize graphView = _graphView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    // init graphView and set up options
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
    
    // setting up a border around the view. for this you need to: #import <QuartzCore/QuartzCore.h> 
    //[graphView.layer setBorderColor:[UIColor redColor].CGColor];
    //[graphView.layer setBorderWidth:2];
    
    // button images
    UIImage *buttonImage = [[UIImage imageNamed:@"orangeButton.png"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *buttonImageHighlight = [[UIImage imageNamed:@"orangeButtonHighlight.png"]
                                     resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    
    // set up button for pre defined array
    UIButton *setArray = [[UIButton alloc]initWithFrame: CGRectMake((self.view.frame.size.width/2)-80, 200, 160, 40)];
    [setArray setTitle:@"Set Array" forState:UIControlStateNormal];
    [setArray setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [setArray setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [setArray addTarget:self action:@selector(setArrayButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:setArray];
    
    // set up button for points
    UIButton *setPoint = [[UIButton alloc]initWithFrame: CGRectMake((self.view.frame.size.width/2)-80, 250, 160, 40)];
    [setPoint setTitle:@"Set Points" forState:UIControlStateNormal];
    [setPoint setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [setPoint setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [setPoint addTarget:self action:@selector(setPointButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:setPoint];
    
    // set up button for resetting array
    UIButton *resetGraph = [[UIButton alloc]initWithFrame: CGRectMake((self.view.frame.size.width/2)-80, 300, 160, 40)];
    [resetGraph setTitle:@"Reset Graph" forState:UIControlStateNormal];
    [resetGraph setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [resetGraph setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [resetGraph addTarget:self action:@selector(resetGraphButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resetGraph];
    
    // set up button for adding points
    UIButton *setVisiblePoints = [[UIButton alloc]initWithFrame: CGRectMake((self.view.frame.size.width/2)-80, 350, 160, 40)];
    [setVisiblePoints setTitle:@"Set Visible Points" forState:UIControlStateNormal];
    [setVisiblePoints setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [setVisiblePoints setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [setVisiblePoints addTarget:self action:@selector(numberOfPointsVisible) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:setVisiblePoints];
    
    // set up button for filling space below graph line
    UIButton *setFilling = [[UIButton alloc]initWithFrame: CGRectMake((self.view.frame.size.width/2)-150, 400, 140, 40)];
    [setFilling setTitle:@"Fill Graph" forState:UIControlStateNormal];
    [setFilling setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [setFilling setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [setFilling addTarget:self action:@selector(setFillingButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:setFilling];
    
    // set up button for removing filling space below graph line
    UIButton *setNoFilling = [[UIButton alloc]initWithFrame: CGRectMake(self.view.frame.size.width-150, 400, 140, 40)];
    [setNoFilling setTitle:@"Don't Fill Graph" forState:UIControlStateNormal];
    [setNoFilling setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [setNoFilling setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [setNoFilling addTarget:self action:@selector(setNotFillingButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:setNoFilling];
    
    visiblePoints = [[UITextField alloc]initWithFrame:CGRectMake((self.view.frame.size.width/2)-150, 355, 60, 30)];
    [visiblePoints setTextAlignment:NSTextAlignmentCenter];
    [visiblePoints setText:@"100"];
    [visiblePoints setBorderStyle:UITextBorderStyleRoundedRect];
    [visiblePoints setReturnKeyType:UIReturnKeyDone];
    [visiblePoints setDelegate:self];
    [self.view addSubview:visiblePoints];
}

-(void)setArrayButtonAction {
    
    // set up array for diplay in graphView
    NSArray *points = @[@0.0f,
                  @0.0f,
                  @0.0f,
                  @13.0f,
                  @7.0f,
                  @9.0f,
                  @20.0f,
                  @04,
                  @0.0f,
                  @0.0f,
                  @0.0f,
                  @0.0f,
                  @0.0f,
                  @0.0f,
                  @0.0f,
                  @0.0f,
                  @0.0f,
                  @0.0f,
                  @0.0f,
                  @0.0f,
                  @0.0f,
                  @0.0f,
                  @0.0f,
                  @1.0f,
                  @2.0f,
                  @3.0f,
                  @4.0f,
                  @5.0f,
                  @6.0f,
                  @7.0f,
                  @8.0f,
                  @9.0f,
                  @10.0f,
                  @11.0f,
                  @12.0f,
                  @13.0f,
                  @14.0f,
                  @13.0f,
                  @12.0f,
                  @11.0f,
                  @10.0f,
                  @9.0f,
                  @8.0f,
                  @7.0f,
                  @6.0f,
                  @5.0f,
                  @4.0f,
                  @3.0f,
                  @2.0f,
                  @1.0f];
    
    [graphView setArray:points];
}

-(void)setPointButtonAction {
    
    // generate random numbers between +100 and -100
    float low_bound = -100.00;
    float high_bound = 100.00;
    float rndValue = (((float)arc4random()/0x100000000)*(high_bound-low_bound)+low_bound);    
    int intRndValue = (int)(rndValue + 0.5);
        
    [graphView setPoint:intRndValue];
    
}

-(void)resetGraphButtonAction {
    
    [graphView resetGraph];
}

-(void)numberOfPointsVisible {
    
    
    [graphView setNumberOfPointsInGraph:[[NSString stringWithString: visiblePoints.text]floatValue]]; // change the int of points from textField

    
}

-(void)setFillingButtonAction {
    
    [graphView setFill:YES];
}

-(void)setNotFillingButtonAction {
    
    [graphView setFill:NO];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    NSTimeInterval animationDuration = 0.3;
    CGRect frame = self.view.frame;
    frame.origin.y -= 216-44;
    frame.size.height += 216-44;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([visiblePoints.text isEqualToString: @""]) {
        [visiblePoints setText:@"100"];
    }
    
    NSTimeInterval animationDuration = 0.3;
    CGRect frame = self.view.frame;
    frame.origin.y += 216-44;
    frame.size.height -= 216-44;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
