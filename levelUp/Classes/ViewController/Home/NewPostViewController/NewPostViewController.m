//
//  NewPostViewController.m
//  levelUp
//
//  Created by Vinícius Lemes on 2016-08-07.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import "NewPostViewController.h"
#import "ShareViewController.h"
#import "AppUtils.h"
#import "PostManager.h"

@interface NewPostViewController ()

@property (strong, nonatomic) NSData *petImageData;
@property (strong, nonatomic) NSString *captionText;
@property (strong, nonatomic) UIImage *chosenImage;

@end

@implementation NewPostViewController

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
    label.text = NSLocalizedString(@"New Post", @"");
    [label sizeToFit];
    self.navigationItem.titleView = label;
    
    UIBarButtonItem *postItem = [[UIBarButtonItem alloc]initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(postTouched:)];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelTouched:)];

    self.navigationItem.rightBarButtonItem = postItem;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.navigationItem.leftBarButtonItem = cancelItem;
    
    [self.imageButton.layer setCornerRadius:25.0f];
    [self.imageButton setBackgroundColor:COLOR_LIGHT_BLUE];
    [self.petImage.layer setCornerRadius:40.0f];
    [self.petImage.layer setBorderColor:[COLOR_LIGHT_BLUE CGColor]];
    [self.petImage.layer setBorderWidth:2.0f];
    
    UIToolbar *manufacturerPickerToolbar=[[UIToolbar alloc] init];
    manufacturerPickerToolbar.barStyle = UIBarStyleDefault;
    manufacturerPickerToolbar.translucent = YES;
    manufacturerPickerToolbar.tintColor = COLOR_LIGHT_BLUE;
    manufacturerPickerToolbar.backgroundColor = [UIColor whiteColor];
    [manufacturerPickerToolbar sizeToFit];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(captionDoneButtonTouched:)];
    [doneButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: COLOR_LIGHT_BLUE,  NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    
    
    [manufacturerPickerToolbar setItems:@[flexSpace, doneButton]];
    self.captionTextView.inputAccessoryView = manufacturerPickerToolbar;
    
    self.petImageData = nil;
}

-(void)viewWillAppear:(BOOL)animated {
    
    [AppUtils setupImageWithUrl:[NSString stringWithFormat:@"%@", [AppUtils retrieveFromUserDefaultWithKey:PET_IMAGE]] andPlaceholder:@"ic_person" andImageView:self.petImage];
    
    [self.petNameLabel setText:[NSString stringWithFormat:@"What are you doing %@ ?", [AppUtils retrieveFromUserDefaultWithKey:PET_NAME]]];
    if ([self.captionTextView.text isEqualToString:@""]) {
        self.captionTextView.text = @"Write your caption :)";
        [self.captionTextView setTextColor:[UIColor lightGrayColor]];
    }

}

#pragma mark - Extra Buttons

-(void)captionDoneButtonTouched:(id)sender {
    [self.captionTextView resignFirstResponder];
}

- (void)postTouched:(id)sender {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    NSMutableDictionary *parameters = [NSMutableDictionary new];

    if(self.petImageData != nil) {
        [parameters removeAllObjects];
        [parameters setValue:self.captionTextView.text forKey:@"post[description]"];
        [parameters setValue:self.petImageData forKey:@"post[image]"];
        
        [AppUtils startLoadingInView:self.view];
        [[PostManager sharedInstance]createPostWithParameters:parameters imageData:self.petImageData withCompletion:^(BOOL isSuccess, Post *post, NSString *message, NSError *error) {
            [AppUtils stopLoadingInView:self.view];
            self.navigationItem.rightBarButtonItem.enabled = YES;
            if(isSuccess) {
                self.captionTextView.text = @"Write your caption :)";
                [self.captionTextView setTextColor:[UIColor lightGrayColor]];
                [self.imageButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                self.imageButton = nil;
                self.petImageData = nil;
                
                [self performSegueWithIdentifier:@"shareSegue" sender:[NSString stringWithFormat:@"%d", post.postId]];
                
            } else {
                [self.navigationController presentViewController:[AppUtils setupAlertWithMessage:message] animated:YES completion:nil];
            }
        }];
    }
    
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"shareSegue"]) {
        ShareViewController *vc = [segue destinationViewController];
        vc.postId = sender;
    }
}


- (IBAction)imageButtonTouched:(id)sender {
    [self chooseImageAlert];
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
    [self.imageButton. layer setMasksToBounds:YES];
    
    self.chosenImage = image;
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
