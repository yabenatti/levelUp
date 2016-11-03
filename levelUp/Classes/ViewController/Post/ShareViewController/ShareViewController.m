//
//  ShareViewController.m
//  levelUp
//
//  Created by Yasmin Ringa on 03/11/16.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import "ShareViewController.h"
#import "Constants.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareDialog.h>
#import <FBSDKShareKit/FBSDKShareLinkContent.h>
#import <FBSDKShareKit/FBSDKShareAPI.h>
#import "PostManager.h"

@interface ShareViewController ()

@property (strong, nonatomic) FBSDKShareLinkContent *content;
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

    self.content = [[FBSDKShareLinkContent alloc] init];

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
    [self.tabBarController setSelectedIndex:0];
    self.content = nil;
}

- (void)cancelTouched:(id)sender {
    [self.tabBarController setSelectedIndex:0];
    self.content = nil;
}

- (IBAction)twitterButtonTouched:(id)sender {
}

- (IBAction)facebookButtonTouched:(id)sender {
    self.content.imageURL = [NSURL URLWithString:self.currentPost.postImage];
    self.content.contentDescription = self.currentPost.postDescription;
    
    [FBSDKShareAPI shareWithContent:self.content delegate:nil];
}

@end
