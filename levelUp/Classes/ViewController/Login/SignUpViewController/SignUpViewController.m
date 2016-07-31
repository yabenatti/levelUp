//
//  SignUpViewController.m
//  levelUp
//
//  Created by Vinícius Lemes on 2016-07-31.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES];
    // Do any additional setup after loading the view.
    [self.signUpButton.layer setCornerRadius:4.0f];
    [self.userPictureButton.layer setCornerRadius:self.userPictureButton.frame.size.width/2];

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

- (IBAction)signUpButtonTouched:(id)sender {
}
@end
