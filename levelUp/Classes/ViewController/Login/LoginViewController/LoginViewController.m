//
//  LoginViewController.m
//  levelUp
//
//  Created by Vinícius Lemes on 2016-07-31.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import "LoginViewController.h"
#import "SignUpViewController.h"
#import "TimelineViewController.h"
#import "LoginManager.h"
#import "AppUtils.h"

@interface LoginViewController ()

@property (strong, nonatomic) UITextField *currentTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //Navigation Bar
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.translucent = YES;
    
    self.usernameTextField.text = @"y@gmail.com";
    self.userPasswordTextField.text = @"123456";
    
    [self.loginButton.layer setCornerRadius:4.0f];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - IBActions

- (IBAction)loginButtonTouched:(id)sender {
    NSDictionary *parameters = @{@"email" : self.usernameTextField.text,
                                 @"password" : self.userPasswordTextField.text};
    
    [[LoginManager sharedInstance]authenticateWithLogin:parameters andCompletion:^(BOOL isSuccess, User *user, NSString *message, NSError *theError) {
        if(isSuccess) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.navigationController presentViewController:[AppUtils setupAlertWithMessage:message] animated:YES completion:nil];
        }
    }];
    
}

- (IBAction)signUpButtonTouched:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    SignUpViewController *vc = [sb instantiateViewControllerWithIdentifier:@"signUp"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - TextField

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentTextField = textField;
}

#pragma mark - Keyboard

- (IBAction)hideKeyboard:(id)sender {
    [self.usernameTextField resignFirstResponder];
    [self.userPasswordTextField resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)n {
    NSDictionary* info = [n userInfo];
    
    NSNumber *duration = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [info objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    NSLog(@"%f",self.view.frame.origin.x);
    NSLog(@"%f",self.view.frame.origin.y);
    
    self.view.frame = CGRectMake(0, (-kbSize.height) + 120, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
    
}

- (void)keyboardWillHide:(NSNotification *)n {
    NSDictionary* info = [n userInfo];
    
    NSNumber *duration = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [info objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

@end
