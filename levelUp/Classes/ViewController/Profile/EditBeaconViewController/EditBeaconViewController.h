//
//  EditBeaconViewController.h
//  levelUp
//
//  Created by Yasmin Ringa on 26/11/16.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditBeaconViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *uniqueIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *majorTextField;
@property (weak, nonatomic) IBOutlet UITextField *minorTextField;
@property (weak, nonatomic) IBOutlet UIButton *petImageButton;

- (IBAction)petImageButtonTouched:(id)sender;
- (IBAction)hideKeyboard:(id)sender;

@end
