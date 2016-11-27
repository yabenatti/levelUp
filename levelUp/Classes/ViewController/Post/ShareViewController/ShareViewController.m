//
//  ShareViewController.m
//  levelUp
//
//  Created by Yasmin Ringa on 03/11/16.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import "ShareViewController.h"
#import "Constants.h"
#import <FBSDKShareKit/FBSDKShareDialog.h>
#import <FBSDKShareKit/FBSDKShareLinkContent.h>
#import <FBSDKShareKit/FBSDKShareAPI.h>
#import <FBSDKShareKit/FBSDKSharePhoto.h>
#import <FBSDKShareKit/FBSDKSharePhotoContent.h>
#import "PostManager.h"
#import "UIImageView+AFNetworking.h"
#import <TwitterKit/TwitterKit.h>


@interface ShareViewController ()

@property (strong, nonatomic) Post *currentPost;

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.twitterButton.layer setCornerRadius:25.0f];
    [self.twitterButton setBackgroundColor:COLOR_LIGHT_BLUE];
    [self.facebookButton.layer setCornerRadius:25.0f];
    [self.facebookButton setBackgroundColor:COLOR_LIGHT_BLUE];
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneTouched:)];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelTouched:)];
    
    self.navigationItem.rightBarButtonItem = doneItem;
    self.navigationItem.leftBarButtonItem = cancelItem;
    
    self.postCaptionTextLabel.text = [self.postInfo objectForKey:@"caption"];
    
    __weak UIImageView *weakImageView = self.postImageView;
    
    NSURL *url = [NSURL URLWithString: [self.postInfo objectForKey:@"image"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [weakImageView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"ic_pets"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [weakImageView setContentMode:UIViewContentModeScaleAspectFill];
        weakImageView.image = image;
        weakImageView.layer.masksToBounds = YES;
        
    }failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    //get specific post
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

- (void)doneTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)cancelTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)twitterButtonTouched:(id)sender {
    // Objective-C
    TWTRComposer *composer = [[TWTRComposer alloc] init];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [self.postInfo objectForKey:@"image"]]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [[UIImage alloc] initWithData:data];

    [composer setText:[self.postInfo objectForKey:@"caption"]];
    [composer setImage:img];
    
    // Called from a UIViewController
    [composer showFromViewController:self completion:^(TWTRComposerResult result) {
        if (result == TWTRComposerResultCancelled) {
            NSLog(@"Tweet composition cancelled");
        }
        else {
            NSLog(@"Sending Tweet!");
        }
    }];
}

- (IBAction)facebookButtonTouched:(id)sender {
   
    FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
    photo.image = [self.postInfo objectForKey:@"imageData"];
    photo.userGenerated = YES;
    FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
    content.photos = @[photo];
    
    FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
    dialog.fromViewController = self;
    dialog.shareContent = content;
    dialog.mode = FBSDKShareDialogModeShareSheet;
    [dialog show];
}

@end
