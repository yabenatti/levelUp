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

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.loginButton.layer setCornerRadius:4.0f];
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

- (IBAction)loginButtonTouched:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    TimelineViewController *vc = [sb instantiateViewControllerWithIdentifier:@"timeline"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)signUpButtonTouched:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    SignUpViewController *vc = [sb instantiateViewControllerWithIdentifier:@"signUp"];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
