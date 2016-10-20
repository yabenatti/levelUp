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
    
    [self.profileImageView.layer setCornerRadius:self.profileImageView.frame.size.width/2];
    [self.profileImageView.layer setMasksToBounds:YES];
    
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
    label.text = NSLocalizedString(@"Profile", @"");
    [label sizeToFit];
    self.navigationItem.titleView = label;
    
    //Logout Button
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc]initWithTitle:@"Log out" style:UIBarButtonItemStylePlain target:self action:@selector(logoutButtonTouched:)];
    self.navigationItem.leftBarButtonItem = logoutButton;
    
    //Inicializacoes
    self.myPosts = [NSArray new];
    [self.emptyView setHidden:YES];
    [self.profileImageView.layer setCornerRadius:28.0f];
    [self.profileImageView.layer setBorderColor:[COLOR_LIGHT_BLUE CGColor]];
    [self.profileImageView.layer setBorderWidth:2.0f];
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    
    [[ProfileManager sharedInstance]retrieveProfileWithUserId:[NSString stringWithFormat:@"%@", [AppUtils retrieveFromUserDefaultWithKey:USER_ID]] andCompletion:^(BOOL isSuccess, User *user, NSString *message, NSError *error) {
        if(isSuccess) {
            self.currentUser = user;
            self.usernameLabel.text = user.petName;
            self.profileImageView.image = [UIImage imageNamed:@"ic_person"];
            
//            [AppUtils setupImageWithUrl:[NSString stringWithFormat:@"%@", [AppUtils retrieveFromUserDefaultWithKey:PET_IMAGE]] andPlaceholder:@"ic_person" andImageView:self.profileImageView];
            
            [[PostManager sharedInstance]getMyPostsWithUserId:[NSString stringWithFormat:@"%@", [AppUtils retrieveFromUserDefaultWithKey:USER_ID]] andCompletion:^(BOOL isSuccess, NSArray *posts, NSString *message, NSError *error) {
                if(isSuccess) {
                    
                    if([posts count] > 0) {
                        self.myPosts = posts;
                        
                        [self.postsTableView reloadData];
                    } else {
                        [self.emptyView setHidden:NO];
                    }
                    
                } else {
                    [self.navigationController presentViewController:[AppUtils setupAlertWithMessage:message] animated:YES completion:nil];
                }
            }];
            
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
    
    [[LoginManager sharedInstance]logoutWithApi:parameters andCompletion:^(BOOL isSuccess, NSString *message, NSError *error) {
        if (isSuccess) {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            TabBarViewController *vc = [sb instantiateInitialViewController];
            [self.navigationController presentViewController:vc animated:NO completion:nil];
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
    
    [cell.userImageView.layer setCornerRadius:cell.userImageView.frame.size.width/2];
    [cell.userImageView.layer setMasksToBounds:YES];
    
    __weak UIImageView *weakImageView2 = cell.userImageView;
    
    NSURL *url = [NSURL URLWithString: @"http://www.lovethispic.com/uploaded_images/59474-Cute-Kitty-Hat.jpg"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [weakImageView2 setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"ic_person"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [weakImageView2 setContentMode:UIViewContentModeScaleAspectFill];
        weakImageView2.image = image;
        weakImageView2.layer.masksToBounds = YES;
        
    }failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
    
    cell.usernameLabel.text = [NSString stringWithFormat:@"%@", [AppUtils retrieveFromUserDefaultWithKey:PET_NAME]];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 450;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}


- (IBAction)editTouched:(id)sender {
    [self performSegueWithIdentifier:@"editSegue" sender:self];
}

- (IBAction)followersTouched:(id)sender {
    [self performSegueWithIdentifier:@"followSegue" sender:self];
}

- (IBAction)followingTouched:(id)sender {
    [self performSegueWithIdentifier:@"followSegue" sender:self];
}
@end
