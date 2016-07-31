//
//  LoginViewController.h
//  levelUp
//
//  Created by Vinícius Lemes on 2016-07-31.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)loginButtonTouched:(id)sender;
- (IBAction)signUpButtonTouched:(id)sender;

@end
