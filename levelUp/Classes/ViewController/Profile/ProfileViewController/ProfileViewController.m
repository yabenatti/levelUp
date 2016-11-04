//
//  ProfileViewController.m
//  levelUp
//
//  Created by Vinícius Lemes on 2016-08-03.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import "ProfileViewController.h"
#import "TabBarViewController.h"
#import "UIImageView+AFNetworking.h"
#import "ProfileManager.h"
#import "PostManager.h"
#import "LoginManager.h"
#import "AppUtils.h"
#import "Constants.h"

@interface ProfileViewController ()

@property (strong, nonatomic) User *currentUser;
@property (strong, nonatomic) NSArray *myPosts;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *currentUserId = [NSString stringWithFormat:@"%@", [AppUtils retrieveFromUserDefaultWithKey:USER_ID]];

    [self.profileImageView.layer setCornerRadius:self.profileImageView.frame.size.width/2];
    [self.profileImageView.layer setMasksToBounds:YES];
    
    //Navigation Bar
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    if (self.tabBarController.selectedIndex == 2){
        self.navigationItem.hidesBackButton = YES;
    } else {
        self.navigationItem.hidesBackButton = NO;
    }
    
    //Title View
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = COLOR_LIGHT_BLUE;
    label.text = NSLocalizedString(@"Profile", @"");
    [label sizeToFit];
    self.navigationItem.titleView = label;
    
    
    if(self.userId == nil) {
        //Logout Button
        UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc]initWithTitle:@"Log out" style:UIBarButtonItemStylePlain target:self action:@selector(logoutButtonTouched:)];
        self.navigationItem.leftBarButtonItem = logoutButton;
        //Edit Button
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editButtonTouched:)];
        self.navigationItem.rightBarButtonItem = editButton;
    } else if (self.userId != nil && ![self.userId isEqualToString:currentUserId]){
        //Follow Button
        UIBarButtonItem *followButton = [[UIBarButtonItem alloc]initWithTitle:@"Follow" style:UIBarButtonItemStylePlain target:self action:@selector(followButtonTouched:)];
        self.navigationItem.rightBarButtonItem = followButton;
    }
    
    //Inicializacoes
    self.myPosts = [NSArray new];
    [self.emptyView setHidden:YES];
    [self.profileImageView.layer setCornerRadius:28.0f];
    [self.profileImageView.layer setBorderColor:[COLOR_LIGHT_BLUE CGColor]];
    [self.profileImageView.layer setBorderWidth:2.0f];
    
    self.postsTableView.rowHeight = UITableViewAutomaticDimension;
    self.postsTableView.estimatedRowHeight = 450;
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self setUpProfile];
}

- (void)setUpProfile {
    [AppUtils startLoadingInView:self.view];
    
    NSString *uid;
    NSString *currentUserId = [NSString stringWithFormat:@"%@", [AppUtils retrieveFromUserDefaultWithKey:USER_ID]];
    
    if(self.userId == nil || [self.userId isEqualToString:currentUserId]) {
        uid = currentUserId;
    } else {
        uid = self.userId;
    }
    
    [[ProfileManager sharedInstance]retrieveProfileWithUserId:uid andCompletion:^(BOOL isSuccess, User *user, NSString *message, NSError *error) {
        [AppUtils stopLoadingInView:self.view];
        if(isSuccess) {
            self.currentUser = user;
            self.usernameLabel.text = user.petName;
            [self.followersButton setTitle:@"0" forState:UIControlStateNormal];
            [self.followingButton setTitle:@"0" forState:UIControlStateNormal];
            
            [AppUtils setupImageWithUrl:user.petImage andPlaceholder:@"ic_person" andImageView:self.profileImageView];
            
            if(self.userId == nil || [self.userId isEqualToString:currentUserId]) {
                [AppUtils startLoadingInView:self.view];
                [[PostManager sharedInstance]getMyPostsWithUserId:[NSString stringWithFormat:@"%@", [AppUtils retrieveFromUserDefaultWithKey:USER_ID]] andCompletion:^(BOOL isSuccess, NSArray *posts, NSString *message, NSError *error) {
                    [AppUtils stopLoadingInView:self.view];
                    if(isSuccess) {
                        
                        if([posts count] > 0) {
                            self.myPosts = posts;
                            
                            [self.postsTableView reloadData];
                            [self.emptyView setHidden:YES];
                            
                        } else {
                            [self.emptyView setHidden:NO];
                        }
                        
                    } else {
                        [self.navigationController presentViewController:[AppUtils setupAlertWithMessage:message] animated:YES completion:nil];
                    }
                }];
                
            } else {
                [AppUtils startLoadingInView:self.view];
                [[PostManager sharedInstance]getOtherPeoplesPostsWithUserId:uid andCompletion:^(BOOL isSuccess, NSArray *posts, NSString *message, NSError *error) {
                    [AppUtils stopLoadingInView:self.view];
                    if(isSuccess) {
                        
                        if([posts count] > 0) {
                            self.myPosts = posts;
                            
                            [self.postsTableView reloadData];
                            [self.emptyView setHidden:YES];
                        } else {
                            [self.emptyView setHidden:NO];
                        }
                        
                    } else {
                        [self.navigationController presentViewController:[AppUtils setupAlertWithMessage:message] animated:YES completion:nil];
                    }
                }];
            }
            
        } else {
            [self.navigationController presentViewController:[AppUtils setupAlertWithMessage:message] animated:YES completion:nil];
        }
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)logoutButtonTouched:(id)sender {
    NSDictionary *parameters = @{@"id" : [NSString stringWithFormat:@"%@", [AppUtils retrieveFromUserDefaultWithKey:USER_ID]]};
    
    [AppUtils startLoadingInView:self.view];
    [[LoginManager sharedInstance]logoutWithApi:parameters andCompletion:^(BOOL isSuccess, NSString *message, NSError *error) {
        [AppUtils stopLoadingInView:self.view];
        if (isSuccess) {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            TabBarViewController *vc = [sb instantiateInitialViewController];
            [self.navigationController presentViewController:vc animated:NO completion:nil];
        } else {
            [self.navigationController presentViewController:[AppUtils setupAlertWithMessage:message] animated:YES completion:nil];
        }
    }];
}

- (void)editButtonTouched:(id)sender {
    [self performSegueWithIdentifier:@"editSegue" sender:self];
}

- (void)followButtonTouched:(id)sender {
    NSDictionary *parameters = @{@"user_id" : self.userId};
    
    [[PostManager sharedInstance]createRelationshipWithUserId:parameters andCompletion:^(BOOL isSuccess, NSString *message, NSError *error) {
        if(isSuccess) {
            [self setUpProfile];
        } else {
            [self.navigationController presentViewController:[AppUtils setupAlertWithMessage:message] animated:YES completion:nil];
        }
    }];
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.myPosts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Post *post = [self.myPosts objectAtIndex:indexPath.row];
    
    TimelineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"timelineCell" forIndexPath:indexPath];
    
    if(cell == nil) {
        cell = [[TimelineTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"timelineCell"];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.indexPath = indexPath;
    cell.delegate = self;
    
    [cell.userImageButton.layer setCornerRadius:cell.userImageButton.frame.size.width/2];
    [cell.userImageButton.layer setMasksToBounds:YES];
    
    __weak UIImageView *weakImageView2 = cell.userImageButton.imageView;
    
    NSURL *url = [NSURL URLWithString: post.postPetImage];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [weakImageView2 setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"ic_person"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [weakImageView2 setContentMode:UIViewContentModeScaleAspectFill];
        weakImageView2.image = image;
        weakImageView2.layer.masksToBounds = YES;
        
    }failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
    if(post.iLiked) {
        [cell.likeButton setImage:[UIImage imageNamed:@"ic_favorite"] forState:UIControlStateNormal];
    } else {
        [cell.likeButton setImage:[UIImage imageNamed:@"ic_favorite_border"] forState:UIControlStateNormal];
    }
    
    cell.usernameLabel.text = post.postPetName;
    cell.postCaptionLabel.text = post.postDescription;
    
    if([post.postImage isEqualToString:@""]) {
        cell.imageHeightConstraint.constant = 0;
    } else {
        
        
        __weak UIImageView *weakImageView = cell.postImageView;
        
        NSURL *url = [NSURL URLWithString: post.postImage];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        [weakImageView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"ic_pets"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            [weakImageView setContentMode:UIViewContentModeScaleAspectFill];
            weakImageView.image = image;
            weakImageView.layer.masksToBounds = YES;
            
        }failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
        
        
        cell.imageHeightConstraint.constant = 256.0f;
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}

#pragma mark - Timeline Cell Delegate

-(void)commentButton:(NSIndexPath *)indexPath {
    Post *post = [self.myPosts objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"commentSegue" sender:[NSString stringWithFormat:@"%d", post.postId]];
}

-(void)likeButton:(NSIndexPath *)indexPath {
    Post *post = [self.myPosts objectAtIndex:indexPath.row];
    
    [[PostManager sharedInstance]createLikeWithPostId:[NSString stringWithFormat:@"%d",post.postId] andCompletion:^(BOOL isSuccess, NSString *message, NSError *error) {
        if(isSuccess) {
            [self.postsTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        } else {
            [self.navigationController presentViewController:[AppUtils setupAlertWithMessage:message] animated:YES completion:nil];
        }
    }];
}

-(void)userImageButton:(NSIndexPath *)indexPath {

}

#pragma mark - IBActions

- (IBAction)followersTouched:(id)sender {
    [self performSegueWithIdentifier:@"followSegue" sender:self];
}

- (IBAction)followingTouched:(id)sender {
    [self performSegueWithIdentifier:@"followSegue" sender:self];
}
@end
