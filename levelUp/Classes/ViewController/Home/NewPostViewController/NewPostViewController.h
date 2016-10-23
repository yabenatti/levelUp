//
//  NewPostViewController.h
//  levelUp
//
//  Created by Vinícius Lemes on 2016-08-07.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewPostViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UIImageView *petImage;
@property (weak, nonatomic) IBOutlet UILabel *petNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *captionTextView;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadView;

- (IBAction)imageButtonTouched:(id)sender;
- (IBAction)twitterButtonTouched:(id)sender;
- (IBAction)facebookButtonTouched:(id)sender;

@end
