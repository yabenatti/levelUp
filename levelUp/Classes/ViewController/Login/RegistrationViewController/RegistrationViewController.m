//
//  RegistrationViewController.m
//  levelUp
//
//  Created by Vinícius Lemes on 2016-08-08.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import "RegistrationViewController.h"
#import "TimelineViewController.h"
#import "SignupManager.h"

@interface RegistrationViewController ()

@end

@implementation RegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)registerButtonTouched:(id)sender {
    
    NSDictionary *parameters = @{@"user" : @{@"email" : [self.parameters objectForKey:@"email"],
                                             @"password" : [self.parameters objectForKey:@"password"],
                                             @"pet_name" : self.petNameTextField.text
                                             }
                                 };
    
    [[SignupManager sharedInstance]signUpWithParameters:parameters andCompletion:^(BOOL isSuccess, User *user, NSString *message, NSError *theError) {
        if(isSuccess) {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
            TimelineViewController *vc = [sb instantiateViewControllerWithIdentifier:@"timeline"];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            NSLog(@"nope.");
        }
    }];
}
@end
