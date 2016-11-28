//
//  EditBeaconViewController.m
//  levelUp
//
//  Created by Yasmin Ringa on 26/11/16.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import "EditBeaconViewController.h"
#import "BeaconManager.h"
#import "Constants.h"
#import "AppUtils.h"
#import "UIImageView+AFNetworking.h"

@interface EditBeaconViewController ()

@property (strong, nonatomic) Beacon *currentBeacon;
@property (strong, nonatomic) NSData *petImage;

@end

@implementation EditBeaconViewController

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
    label.text = NSLocalizedString(@"Edit Beacon", @"");
    [label sizeToFit];
    self.navigationItem.titleView = label;
    
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveTouched:)];
    self.navigationItem.rightBarButtonItem = saveItem;
    
    [self.petImageButton.layer setCornerRadius:56.0f];
    [self.petImageButton.layer setMasksToBounds:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [AppUtils startLoadingInView:self.view];
    [[BeaconManager sharedInstance]getUserBeaconsWithCompletion:^(BOOL isSuccess, Beacon *beacon, NSString *message, NSError *error) {
        [AppUtils stopLoadingInView:self.view];
        if(isSuccess) {
            self.currentBeacon = beacon;
            [self fillUpScreen];
        } else {
            [self.navigationController presentViewController:[AppUtils setupAlertWithMessage:message] animated:YES completion:nil];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helpers

- (void)fillUpScreen {
    [self.uniqueIDTextField setText:self.currentBeacon.beaconUniqueId];
    [self.majorTextField setText:[NSString stringWithFormat:@"%d", self.currentBeacon.major]];
    [self.minorTextField setText:[NSString stringWithFormat:@"%d", self.currentBeacon.minor]];
    
    if(self.petImage == nil) {
        NSURL *url = [NSURL URLWithString:self.currentBeacon.petImage];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [[UIImage alloc] initWithData:data];
        [self.petImageButton setImage:img forState:UIControlStateNormal];
        self.petImage = UIImageJPEGRepresentation(img, 0.5);

    }
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

#pragma mark - IBActions

- (void)saveTouched:(id)sender {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]initWithDictionary:@{@"beacon[unique_id]" : self.uniqueIDTextField.text,
                                                                                      @"beacon[major]" : self.majorTextField.text,
                                                                                      @"beacon[minor]" : self.minorTextField.text,
                                                                                       @"beacon[pet_image]" : self.petImage}];
    
    [AppUtils startLoadingInView:self.view];
    [[BeaconManager sharedInstance]updateBeaconWithParameters:parameters imageData:self.petImage withCompletion:^(BOOL isSuccess, NSString *message, NSError *error) {
        [AppUtils stopLoadingInView:self.view];
        if(isSuccess) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self.navigationController presentViewController:[AppUtils setupAlertWithMessage:message] animated:YES completion:nil];
        }
    }];

    

    
}

- (IBAction)petImageButtonTouched:(id)sender {
    [self chooseImageAlert];
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
    [self.uniqueIDTextField resignFirstResponder];
    [self.majorTextField resignFirstResponder];
    [self.minorTextField resignFirstResponder];
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
    
    [self.petImageButton setImage:image forState:UIControlStateNormal];
    [self.petImageButton.layer setCornerRadius:self.petImageButton.frame.size.width/2];
    [self.petImageButton.layer setMasksToBounds:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
