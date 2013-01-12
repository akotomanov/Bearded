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

- (void) pinchZoomBeard:(UIPinchGestureRecognizer *)sender {
    
    UIView *beard = [sender view];
    
    // The scale factor between the two fingers
    CGFloat factor = [sender scale];
    
    // Apply transformation only for the beginning or changing states
    if (sender.state == UIGestureRecognizerStateBegan || sender.state == UIGestureRecognizerStateChanged ) {
        
        // Apply an affine transformation based on the factor
        beard.transform = CGAffineTransformMakeScale(factor, factor);
    
    }
}

- (void) panBeard:(UIPanGestureRecognizer *)sender {
    
    UIView *beard = [sender view];
    
    if ([sender state] == UIGestureRecognizerStateBegan || [sender state] == UIGestureRecognizerStateChanged) {
        
        // Get the panning move point relative to the parent view
        CGPoint translation = [sender translationInView:[beard superview]];
        //NSLog(@"x: %1.2f, y: %1.2f",translation.x,translation.y);
        
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

- (IBAction)cameraBtnAction:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take a Picture", @"Choose from Library", nil];
    
    [actionSheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    //Create a new image picker instance:
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    //Set the image picker source:
    switch (buttonIndex) {
        case 0:
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        
        case 1:
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
            
        default:
            break;
    }
    
    picker.delegate = self;
    
    //Show picker if Take a picture or Choose from Library is selected
    if (buttonIndex == 0 || buttonIndex == 1) {
        [self presentViewController:picker animated:YES completion:nil];
    }
    
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    self.photoView.image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (UIImage *) blendImages {
    UIImage *photoImage = self.photoView.image;
    UIImage *beardImage = self.beardView.image;
    
    //Get the size of the photo
    CGSize photoSize = CGSizeMake(photoImage.size.width, photoImage.size.height);
    
    //Create a bitmap graphics context of the photoSize
    UIGraphicsBeginImageContext(photoSize);
    
    //Draw the photo in the specified rectangle area
    [photoImage drawInRect:CGRectMake(0, 0, photoSize.width, photoSize.height)];
    
    CGPoint origin = self.beardView.frame.origin;
    CGSize size = self.beardView.frame.size;
    
    CGFloat xScale = photoImage.size.width / self.view.bounds.size.width;
    CGFloat yScale = photoImage.size.height / (self.view.bounds.size.height - 44);
    
    //Draw the beard in the specified rectangle area
    [beardImage drawInRect:CGRectMake((origin.x * xScale), (origin.y * yScale), (size.width * xScale), (size.height * yScale)) blendMode:kCGBlendModeNormal alpha:1.0];
    
    //Save the generated image to an image object
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

@end
