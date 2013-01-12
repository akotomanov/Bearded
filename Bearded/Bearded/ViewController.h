//
//  ViewController.h
//  Bearded
//
//  Created by alex.kotomanov on 13.01.13.
//  Copyright (c) 2013 Alexander Kotomanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate>;


@property (strong, nonatomic) IBOutlet UIImageView *photoView;

@property (strong, nonatomic) IBOutlet UIImageView *beardView;

- (IBAction)cameraBtnAction:(id)sender;


@end
