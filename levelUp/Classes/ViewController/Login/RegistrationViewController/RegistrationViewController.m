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
#import "Constants.h"
#import "AppUtils.h"

@interface RegistrationViewController ()

@property (strong, nonatomic) NSData *petImage;

@end

@implementation RegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Navigation Bar
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.hidesBackButton = YES;
    
    //Title View
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = COLOR_LIGHT_BLUE;
    label.text = NSLocalizedString(@"Registration", @"");
    [label sizeToFit];
    self.navigationItem.titleView = label;
    
    [self.registerButton setUserInteractionEnabled:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    self.beaconIdTextField.text = @"B9407F30-F5F8-466E-AFF9-25556B57FE6D";
    self.beaconMajorTextField.text = @"47798";
    self.beaconMinorTextField.text = @"37813";
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

#pragma mark - TextField

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - Image

- (void)chooseImageAlert {
    
    UIAlertController *actionSheet = [UIAlertController new];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
        
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Choose Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:nil];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self.navigationController presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark - UIImagePicker delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [UIImage new];
    
    image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    self.petImage = UIImageJPEGRepresentation(image, 0.5);

    
    [self.userPictureButton setImage:image forState:UIControlStateNormal];
    [self.userPictureButton.layer setCornerRadius:self.userPictureButton.frame.size.width/2];
    [self.userPictureButton.layer setMasksToBounds:YES];
    
    [self.registerButton setUserInteractionEnabled:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark - IBActions

- (IBAction)registerButtonTouched:(id)sender {
    [self.registerButton setUserInteractionEnabled:NO];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]initWithDictionary:@{@"beacon[unique_id]" : self.beaconIdTextField.text,
                                                                                      @"beacon[major]" : self.beaconMajorTextField.text,
                                                                                      @"beacon[minor]" : self.beaconMinorTextField.text,
                                                                                      @"beacon[pet_image]" : self.petImage,
                                                                                       }];
    
  [[SignupManager sharedInstance]registerBeaconWithParameters:parameters imageData:self.petImage withCompletion:^(BOOL isSuccess, NSString *message, NSError *error) {
      [self.registerButton setUserInteractionEnabled:YES];
      if(isSuccess) {
          [self.navigationController dismissViewControllerAnimated:YES completion:nil];
      } else {
          [self.navigationController presentViewController:[AppUtils setupAlertWithMessage:message] animated:YES completion:nil];
      }
  }];
    

    
}

- (IBAction)pictureButtonTouched:(id)sender {
    [self chooseImageAlert];
}

#pragma mark - Keyboard

- (IBAction)hideKeyboard:(id)sender {
    [self.beaconIdTextField resignFirstResponder];
    [self.beaconMajorTextField resignFirstResponder];
    [self.beaconMinorTextField resignFirstResponder];
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
