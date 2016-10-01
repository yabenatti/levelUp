//
//  RegistrationViewController.h
//  levelUp
//
//  Created by Vinícius Lemes on 2016-08-08.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistrationViewController : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) NSMutableDictionary *parameters;

@property (weak, nonatomic) IBOutlet UIButton *userPictureButton;

@property (weak, nonatomic) IBOutlet UITextField *petNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *beaconIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *beaconMinorTextField;
@property (weak, nonatomic) IBOutlet UITextField *beaconMajorTextField;

- (IBAction)registerButtonTouched:(id)sender;
- (IBAction)pictureButtonTouched:(id)sender;

@end
