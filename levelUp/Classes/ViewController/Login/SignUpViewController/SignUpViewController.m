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
#import "Constants.h"
#import "AppUtils.h"

@interface SignUpViewController ()

#define COLOR_BLUE_LIGHT [UIColor colorWithRed:49.0/255.0 green:140.0/255.0 blue:231.0/255.0 alpha:1.0]
#define COLOR_GRAY_LIGHT [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0]

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Navigation Bar
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    
    //Title View
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = COLOR_LIGHT_BLUE;
    label.text = NSLocalizedString(@"SignUp", @"");
    [label sizeToFit];
    self.navigationItem.titleView = label;
    
    // Do any additional setup after loading the view.
    [self.signUpButton.layer setCornerRadius:4.0f];
    
    self.petNameTextField.text = @"Pluto";
    self.userEmailTextField.text = @"user@example.com";
    self.userPasswordTextField.text = @"123456";
    self.userConfirmPasswordTextField.text = @"123456";
 
}

-(void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Helpers

-(void)changeColorWithView:(UIView *)view andColor:(CGColorRef)color andLabel:(UILabel *)label andLabelColor:(CGColorRef)labelColor {
    [view.layer setBorderColor:color];
    label.textColor = [UIColor colorWithCGColor:labelColor];
}

#pragma mark - TextField 

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)signUpButtonTouched:(id)sender {
    NSDictionary *parameters = @{@"user" : @{@"email" : self.userEmailTextField.text,
                                             @"password" : self.userPasswordTextField.text,
                                             @"pet_name" : self.petNameTextField.text
                                            }
                                };
    [AppUtils startLoadingInView:self.view];
    [[SignupManager sharedInstance]signUpWithParameters:parameters andCompletion:^(BOOL isSuccess, User *user, NSString *message, NSError *theError) {
        [AppUtils stopLoadingInView:self.view];
        if(isSuccess) {
            [self performSegueWithIdentifier:@"registrationSegue" sender:nil];
        } else {
            [self.navigationController presentViewController:[AppUtils setupAlertWithMessage:message] animated:YES completion:nil];
        }
    }];

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
    [self.petNameTextField resignFirstResponder];
}

#pragma mark - Keyboard

-(void)keyboardWillShow:(NSNotification *)n {
    
    NSDictionary* info = [n userInfo];
    NSNumber *duration = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [info objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    self.view.frame = CGRectMake(0, -(self.view.frame.size.height*0.1), self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
    
}

-(void)keyboardWillHide:(NSNotification *)n {
    
    NSDictionary* info = [n userInfo];
    NSNumber *duration = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [info objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    self.view.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height + 20, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
    
}
@end
