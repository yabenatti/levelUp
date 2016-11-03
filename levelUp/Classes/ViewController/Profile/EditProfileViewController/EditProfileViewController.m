//
//  EditProfileViewController.m
//  levelUp
//
//  Created by Vinícius Lemes on 2016-08-07.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import "EditProfileViewController.h"
#import "UIImageView+AFNetworking.h"
#import "Constants.h"
#import "AppUtils.h"
#import "ProfileManager.h"

@interface EditProfileViewController ()

@property (strong, nonatomic) User *currentUser;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    label.text = NSLocalizedString(@"Edit Profile", @"");
    [label sizeToFit];
    self.navigationItem.titleView = label;
    
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveTouched:)];
    self.navigationItem.rightBarButtonItem = saveItem;
    
    [self.editImageButton.layer setCornerRadius:56.0f];
    [self.editImageButton.layer setMasksToBounds:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [AppUtils startLoadingInView:self.view];
    [[ProfileManager sharedInstance]retrieveProfileWithUserId:[NSString stringWithFormat:@"%@", [AppUtils retrieveFromUserDefaultWithKey:USER_ID]] andCompletion:^(BOOL isSuccess, User *user, NSString *message, NSError *error) {
        [AppUtils stopLoadingInView:self.view];
        if(isSuccess) {
            self.currentUser = user;
            self.petNameTextField.text = user.petName;
            if(![user.birthDate isKindOfClass:[NSNull class]]) {
                self.birthdateTextField.text = [AppUtils formatDate:user.birthDate];
            }
            if(![user.userName isKindOfClass:[NSNull class]]) {
                self.ownerNameTextField.text = user.userName;
            }
            
            
//            [AppUtils setupImageWithUrl:[NSString stringWithFormat:@"%@", [AppUtils retrieveFromUserDefaultWithKey:PET_IMAGE]] andPlaceholder:@"ic_person"
//                           andImageView:self.editImageButton.imageView];
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [AppUtils retrieveFromUserDefaultWithKey:PET_IMAGE]]];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *img = [[UIImage alloc] initWithData:data];
            [self.editImageButton setImage:img forState:UIControlStateNormal];
        
        } else {
            [self.navigationController presentViewController:[AppUtils setupAlertWithMessage:message] animated:YES completion:nil];
        }
    }];

    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (void)saveTouched:(id)sender {
    NSDictionary *parameters = @{ @"user" : @{ @"pet_name" : self.petNameTextField.text,
                                               @"name" : self.ownerNameTextField.text,
                                               @"birth_date" : self.birthdateTextField.text
                                             }
                                };
    
    [AppUtils startLoadingInView:self.view];
    [[ProfileManager sharedInstance]editProfileWithUserId:[NSString stringWithFormat:@"%@", [AppUtils retrieveFromUserDefaultWithKey:USER_ID]] andParameters:parameters andCompletion:^(BOOL isSuccess, User *user, NSString *message, NSError *error) {
        [AppUtils stopLoadingInView:self.view];
        if(isSuccess) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self.navigationController presentViewController:[AppUtils setupAlertWithMessage:message] animated:YES completion:nil];
        }
    }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - TextField

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

-(NSString*)filteredString:(NSString*)string WithFilter:(NSString*)filter {
    NSUInteger onOriginal = 0, onFilter = 0, onOutput = 0;
    char outputString[([filter length])];
    BOOL done = NO;
    
    while(onFilter < [filter length] && !done) {
        char filterChar = [filter characterAtIndex:onFilter];
        char originalChar = onOriginal >= string.length ? '\0' : [string characterAtIndex:onOriginal];
        switch (filterChar) {
            case '#':
                if(originalChar=='\0') {
                    // We have no more input numbers for the filter.  We're done.
                    done = YES;
                    break;
                }
                if(isdigit(originalChar)) {
                    outputString[onOutput] = originalChar;
                    onOriginal++;
                    onFilter++;
                    onOutput++;
                } else {
                    onOriginal++;
                }
                break;
            default:
                // Any other character will automatically be inserted for the user as they type (spaces, - etc..) or deleted as they delete if there are more numbers to come.
                outputString[onOutput] = filterChar;
                onOutput++;
                onFilter++;
                if(originalChar == filterChar)
                    onOriginal++;
                break;
        }
    }
    outputString[onOutput] = '\0'; // Cap the output string
    return [NSString stringWithUTF8String:outputString];
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if([textField isEqual:self.birthdateTextField]) {
        NSString *filter = @"##/##/####";
        
        if(!filter) return YES; // No filter provided, allow anything
        
        NSString *changedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        if(range.length == 1 && // Only do for single deletes
           string.length < range.length &&
           [[textField.text substringWithRange:range] rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]].location == NSNotFound) {
            // Something was deleted. Delete past the previous number
            NSInteger location = changedString.length-1;
            if(location > 0) {
                for(; location > 0; location--) {
                    if(isdigit([changedString characterAtIndex:location])) {
                        break;
                    }
                }
                changedString = [changedString substringToIndex:location];
            }
        }
        self.birthdateTextField.text = [self filteredString:changedString WithFilter:filter];
        return NO;
    }
    return YES;

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


- (IBAction)hideKeyboard:(id)sender {
    [self.petNameTextField resignFirstResponder];
    [self.ownerNameTextField resignFirstResponder];
    [self.birthdateTextField resignFirstResponder];
}
@end
