//
//  NewPostViewController.m
//  levelUp
//
//  Created by Vinícius Lemes on 2016-08-07.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import "NewPostViewController.h"
#import "AppUtils.h"
#import "PostManager.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareDialog.h>
#import <FBSDKShareKit/FBSDKShareLinkContent.h>
#import <FBSDKShareKit/FBSDKShareAPI.h>

@interface NewPostViewController ()

@property (strong, nonatomic) NSData *petImageData;

@end

@implementation NewPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *postItem = [[UIBarButtonItem alloc]initWithTitle:@"Post" style:UIBarButtonItemStylePlain target:self action:@selector(postTouched:)];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelTouched:)];

    self.navigationItem.rightBarButtonItem = postItem;
    self.navigationItem.leftBarButtonItem = cancelItem;

    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:@"https://developers.facebook.com"];
   
//    [FBSDKShareAPI shareWithContent:content delegate:nil];
    
    [self.imageButton.layer setCornerRadius:25.0f];
    [self.imageButton setBackgroundColor:COLOR_LIGHT_BLUE];
    [self.twitterButton.layer setCornerRadius:25.0f];
    [self.twitterButton setBackgroundColor:COLOR_LIGHT_BLUE];
    [self.facebookButton.layer setCornerRadius:25.0f];
    [self.facebookButton setBackgroundColor:COLOR_LIGHT_BLUE];
    [self.petImage.layer setCornerRadius:25.0f];
    [self.petImage.layer setBorderColor:[COLOR_LIGHT_BLUE CGColor]];
    [self.petImage.layer setBorderWidth:2.0f];

    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [AppUtils setupImageWithUrl:[NSString stringWithFormat:@"%@", [AppUtils retrieveFromUserDefaultWithKey:PET_IMAGE]] andPlaceholder:@"ic_person" andImageView:self.petImage];
    [self.petNameLabel setText:[NSString stringWithFormat:@"%@", [AppUtils retrieveFromUserDefaultWithKey:PET_NAME]]];
    self.captionTextView.text = @"Write your caption :)";
    [self.captionTextView setTextColor:[UIColor lightGrayColor]];
}

- (void)postTouched:(id)sender {

    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]initWithDictionary:@{@"post[description]" : self.captionTextView.text,
                                                                                       @"post[image]" : self.petImageData
                                                                                       }];

    [[PostManager sharedInstance]createPostWithParameters:parameters imageData:self.petImageData withCompletion:^(BOOL isSuccess, NSString *message, NSError *error) {
        if(isSuccess) {
            [self.tabBarController setSelectedIndex:0];
        } else {
            [self.navigationController presentViewController:[AppUtils setupAlertWithMessage:message] animated:YES completion:nil];
        }
    }];

}

- (void)cancelTouched:(id)sender {
    [self.tabBarController setSelectedIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextView

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"Write your caption :)"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Write your caption :)";
        textView.textColor = [UIColor lightGrayColor];
    }
    [textView resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)imageButtonTouched:(id)sender {
    [self chooseImageAlert];
}

- (IBAction)twitterButtonTouched:(id)sender {
}

- (IBAction)facebookButtonTouched:(id)sender {
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
    
    self.petImageData = UIImageJPEGRepresentation(image, 0.5);
    
    [self.imageButton setImage:image forState:UIControlStateNormal];
    [self.imageButton.layer setCornerRadius:25.0f];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
