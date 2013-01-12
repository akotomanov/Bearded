//
//  ViewController.m
//  Bearded
//
//  Created by alex.kotomanov on 13.01.13.
//  Copyright (c) 2013 Alexander Kotomanov. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //The pinch gesture is achieved using two fingers. When the fingers are brought closer to each other it is percieved as zooming-out and the reverse is zooming-in. In our case, we will make the beard image larger or smaller based on the distance between the two fingers.
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchZoomBeard:)];
    pinchGestureRecognizer.delegate = self;
    [self.beardView addGestureRecognizer:pinchGestureRecognizer];
    
    //The panning or dragging gesture is achieved using one or more fingers. We will use this gesture to move the beard around for placement.
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panBeard:)];
    panGestureRecognizer.maximumNumberOfTouches = 1;
    panGestureRecognizer.delegate = self;
    [self.beardView addGestureRecognizer:panGestureRecognizer];
    
    self.beardView.userInteractionEnabled = YES;
    
}

- (void) pinchZoomBeardView:(UIPinchGestureRecognizer *)sender {
    
    UIView *beard = [sender view];
    
    // The scale factor between the two fingers
    CGFloat factor = [sender scale];
    
    // Apply transformation only for the beginning or changing states
    if (sender.state == UIGestureRecognizerStateBegan || sender.state == UIGestureRecognizerStateChanged ) {
        
        // Apply an affine transformation based on the factor
        beard.transform = CGAffineTransformMakeScale(factor, factor);
    
    }
}

- (void) panBeardView:(UIPanGestureRecognizer *)sender {
    
    UIView *beard = [sender view];
    
    if ([sender state] == UIGestureRecognizerStateBegan || [sender state] == UIGestureRecognizerStateChanged) {
        
        // Get the panning move point relative to the parent view
        CGPoint translation = [sender translationInView:[beard superview]];
        // NSLog(@"x: %1.2f, y: %1.2f",translation.x,translation.y);
        
        // Add it to the center point of the beard view so that it stays
        // under the finger of the user
        [beard setCenter:CGPointMake([beard center].x + translation.x, [beard center].y + translation.y)];
        
        // Reset the translation to reduce panning velocity
        // Removing this line will result in the beard view disappearing very quickly
        [sender setTranslation:CGPointZero inView:[beard superview]];
    
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
