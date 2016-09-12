//
//  ProfileViewController.m
//  levelUp
//
//  Created by Vinícius Lemes on 2016-08-03.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import "ProfileViewController.h"
#import "TimeLineTableViewCell.h"
#import "PostTableViewCell.h"
#import "ProfileManager.h"
#import "PostManager.h"
#import "AppUtils.h"

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
    
    //Inicializacoes
    self.myPosts = [NSArray new];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [[ProfileManager sharedInstance]retrieveProfileWithUserId:[NSString stringWithFormat:@"%@", [AppUtils retrieveFromUserDefaultWithKey:USER_ID]] andCompletion:^(BOOL isSuccess, User *user, NSString *message, NSError *error) {
        if(isSuccess) {
            self.currentUser = user;
            self.usernameLabel.text = user.petName;
            
            [[PostManager sharedInstance]getMyPostsWithUserId:[NSString stringWithFormat:@"%@", [AppUtils retrieveFromUserDefaultWithKey:USER_ID]] andCompletion:^(BOOL isSuccess, NSArray *posts, NSString *message, NSError *error) {
                if(isSuccess) {
                    self.myPosts = posts;
                    
                    [self.postsTableView reloadData];
                } else {
                    
                }
            }];
            
        } else {
            
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.myPosts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        TimelineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"timelineCell" forIndexPath:indexPath];
        
        if(cell == nil) {
            cell = [[TimelineTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"timelineCell"];
        }
        
        [cell.userImageView.layer setCornerRadius:cell.userImageView.frame.size.width/2];
        [cell.userImageView.layer setMasksToBounds:YES];
        cell.usernameLabel.text = @"Yasmin Benatti";
        
        
        
        return cell;
    } else {
        PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"postCell" forIndexPath:indexPath];
        
        if(cell == nil) {
            cell = [[PostTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"postCell"];
        }
        
        [cell.userImageView.layer setCornerRadius:cell.userImageView.frame.size.width/2];
        [cell.userImageView.layer setMasksToBounds:YES];
        cell.usernameLabel.text = @"Yasmin Benatti";
        cell.postLabel.text = @"This is a text post";
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        return 450;
    } else {
        return 250;
    }
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
