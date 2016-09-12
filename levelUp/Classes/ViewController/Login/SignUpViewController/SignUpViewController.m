//
//  SignUpViewController.m
//  levelUp
//
//  Created by Vinícius Lemes on 2016-07-31.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import "SignUpViewController.h"
#import "RegistrationViewController.h"
#import "SignUpManager.h"

@interface SignUpViewController ()

#define COLOR_BLUE_LIGHT [UIColor colorWithRed:49.0/255.0 green:140.0/255.0 blue:231.0/255.0 alpha:1.0]
#define COLOR_GRAY_LIGHT [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0]

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES];
    // Do any additional setup after loading the view.
    [self.signUpButton.layer setCornerRadius:4.0f];
    [self.userPictureButton.layer setCornerRadius:self.userPictureButton.frame.size.width/2];
    
    [self.emailCornerView.layer setCornerRadius:4.0f];
    [self.emailCornerView.layer setBorderWidth:1.0];
    [self.emailCornerView.layer setBorderColor:[COLOR_GRAY_LIGHT CGColor]];
    self.emailLabel.textColor = [UIColor colorWithCGColor:[COLOR_GRAY_LIGHT CGColor]];
    
    [self.passwordCornerView.layer setCornerRadius:4.0f];
    [self.passwordCornerView.layer setBorderWidth:1.0];
    [self.passwordCornerView.layer setBorderColor:[COLOR_GRAY_LIGHT CGColor]];
    self.passwordLabel.textColor = [UIColor colorWithCGColor:[COLOR_GRAY_LIGHT CGColor]];

    [self.confirmCornerView.layer setCornerRadius:4.0f];
    [self.confirmCornerView.layer setBorderWidth:1.0];
    [self.confirmCornerView.layer setBorderColor:[COLOR_GRAY_LIGHT CGColor]];
    self.confirmLabel.textColor = [UIColor colorWithCGColor:[COLOR_GRAY_LIGHT CGColor]];
    
    self.userEmailTextField.text = @"user4@example.com";
    self.userPasswordTextField.text = @"123456";
    self.userConfirmPasswordTextField.text = @"123456";
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextField Delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if([textField isEqual:self.userEmailTextField]) {
        [self changeColorWithView:self.emailCornerView andColor:[COLOR_BLUE_LIGHT CGColor] andLabel:self.emailLabel andLabelColor:[COLOR_BLUE_LIGHT CGColor]];
    } else if([textField isEqual:self.userPasswordTextField]) {
        [self changeColorWithView:self.passwordCornerView andColor:[COLOR_BLUE_LIGHT CGColor] andLabel:self.passwordLabel andLabelColor:[COLOR_BLUE_LIGHT CGColor]];
    } else if([textField isEqual:self.userConfirmPasswordTextField]) {
        [self changeColorWithView:self.confirmCornerView andColor:[COLOR_BLUE_LIGHT CGColor] andLabel:self.confirmLabel andLabelColor:[COLOR_BLUE_LIGHT CGColor]];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if([textField isEqual:self.userEmailTextField]) {
        if([textField.text isEqualToString:@""]) {
            [self changeColorWithView:self.emailCornerView andColor:[COLOR_GRAY_LIGHT CGColor] andLabel:self.emailLabel andLabelColor:[COLOR_GRAY_LIGHT CGColor]];
        } else {
            [self changeColorWithView:self.emailCornerView andColor:[COLOR_GRAY_LIGHT CGColor] andLabel:self.emailLabel andLabelColor:[COLOR_BLUE_LIGHT CGColor]];
        }
    } else if([textField isEqual:self.userPasswordTextField]) {
        if([textField.text isEqualToString:@""]) {
            [self changeColorWithView:self.passwordCornerView andColor:[COLOR_GRAY_LIGHT CGColor] andLabel:self.passwordLabel andLabelColor:[COLOR_GRAY_LIGHT CGColor]];
        } else {
            [self changeColorWithView:self.emailCornerView andColor:[COLOR_GRAY_LIGHT CGColor] andLabel:self.emailLabel andLabelColor:[COLOR_BLUE_LIGHT CGColor]];
        }
    } else if([textField isEqual:self.userConfirmPasswordTextField]) {
        if([textField.text isEqualToString:@""]) {
            [self changeColorWithView:self.confirmCornerView andColor:[COLOR_GRAY_LIGHT CGColor] andLabel:self.confirmLabel andLabelColor:[COLOR_GRAY_LIGHT CGColor]];
        } else {
            [self changeColorWithView:self.emailCornerView andColor:[COLOR_GRAY_LIGHT CGColor] andLabel:self.emailLabel andLabelColor:[COLOR_BLUE_LIGHT CGColor]];
        }
    }
}

#pragma mark - Helpers

-(void)changeColorWithView:(UIView *)view andColor:(CGColorRef)color andLabel:(UILabel *)label andLabelColor:(CGColorRef)labelColor {
    [view.layer setBorderColor:color];
    label.textColor = [UIColor colorWithCGColor:labelColor];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"registrationSegue"]) {
        RegistrationViewController *vc = [segue destinationViewController];
        vc.parameters = [NSMutableDictionary new];
        vc.parameters = sender;
    }
}


- (IBAction)signUpButtonTouched:(id)sender {
    NSDictionary *parameters = @{@"email" : self.userEmailTextField.text,
                                 @"password" : self.userPasswordTextField.text};
    
    [self performSegueWithIdentifier:@"registrationSegue" sender:parameters];
}

- (IBAction)emailViewTapped:(id)sender {
    [self.userEmailTextField becomeFirstResponder];
}

- (IBAction)passwordViewTapped:(id)sender {
    [self.userPasswordTextField becomeFirstResponder];
}

- (IBAction)confirmViewTapped:(id)sender {
    [self.userConfirmPasswordTextField becomeFirstResponder];
}

- (IBAction)hideKeyboard:(id)sender {
    [self.userEmailTextField resignFirstResponder];
    [self.userPasswordTextField resignFirstResponder];
    [self.userConfirmPasswordTextField resignFirstResponder];
}
@end
