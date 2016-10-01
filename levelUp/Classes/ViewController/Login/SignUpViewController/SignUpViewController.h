//
//  SignUpViewController.h
//  levelUp
//
//  Created by Vinícius Lemes on 2016-07-31.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userEmailTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *userConfirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

- (IBAction)signUpButtonTouched:(id)sender;
- (IBAction)emailViewTapped:(id)sender;
- (IBAction)passwordViewTapped:(id)sender;
- (IBAction)confirmViewTapped:(id)sender;
- (IBAction)hideKeyboard:(id)sender;

@end
