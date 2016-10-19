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
}

- (void)viewWillAppear:(BOOL)animated {
    self.beaconIdTextField.text = @"B9407F30-F5F8-466E-AFF9-25556B57FE6D";
    self.beaconMajorTextField.text = @"47798";
    self.beaconMinorTextField.text = @"37813";
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
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark - IBActions

- (IBAction)registerButtonTouched:(id)sender {
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]initWithDictionary:@{@"beacon[unique_id]" : self.beaconIdTextField.text,
                                                                                      @"beacon[major]" : self.beaconMajorTextField.text,
                                                                                      @"beacon[minor]" : self.beaconMinorTextField.text,
                                                                                      @"beacon[pet_image]" : self.petImage,
                                                                                       }];
    
  [[SignupManager sharedInstance]registerBeaconWithParameters:parameters imageData:self.petImage withCompletion:^(BOOL isSuccess, NSString *message, NSError *error) {
      if(isSuccess) {
          NSLog(@"UHUL");
      } else {
          NSLog(@"NOT YET");
      }
  }];
    

    
}

- (IBAction)pictureButtonTouched:(id)sender {
    [self chooseImageAlert];
}
@end
