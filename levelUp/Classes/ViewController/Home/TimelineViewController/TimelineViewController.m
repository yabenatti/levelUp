//
//  TimelineViewController.m
//  levelUp
//
//  Created by Vinícius Lemes on 2016-08-03.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import "TimelineViewController.h"
#import "NewPostViewController.h"
#import "TimeLineTableViewCell.h"
#import "LoginViewController.h"
#import "PostTableViewCell.h"
#import "PostManager.h"
#import "AppUtils.h"
#import "Constants.h"


@interface TimelineViewController ()

@property (strong, nonatomic) NSArray *posts;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *postItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_pets"] style:UIBarButtonItemStyleDone target:self action:@selector(postTouched:)];
    
    self.navigationItem.rightBarButtonItem = postItem;
    
    [self.emptyView setHidden:YES];

    
    //Inicializacoes
    self.posts = [NSArray new];
}

-(void)viewWillAppear:(BOOL)animated {
    NSString *token = [NSString stringWithFormat:@"%@", [AppUtils retrieveFromUserDefaultWithKey:USER_TOKEN]];
    if([token isEqualToString:@"(null)"]) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        LoginViewController *vc = [sb instantiateInitialViewController];
        [self.navigationController presentViewController:vc animated:YES completion:nil];
        
    } else {
        [[PostManager sharedInstance]getAllPostsWithUserId:[NSString stringWithFormat:@"%@", [AppUtils retrieveFromUserDefaultWithKey:USER_ID]] andCompletion:^(BOOL isSuccess, NSArray *posts, NSString *message, NSError *error) {
            if(isSuccess) {
                self.posts = posts;
                
                if([posts count] == 0) {
                    [self.emptyView setHidden:NO];
                } else {
                    [self.emptyView setHidden:YES];
                    [self.postsTableView reloadData];
                }
                
            } else {
                
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)postTouched:(id)sender {
    [self performSegueWithIdentifier:@"postSegue" sender:self];
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.posts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        //Com imagem
        TimelineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"timelineCell" forIndexPath:indexPath];
        
        if(cell == nil) {
            cell = [[TimelineTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"timelineCell"];
        }
        
        Post *post = [self.posts objectAtIndex:indexPath.row];
        
        [cell.userImageView.layer setCornerRadius:cell.userImageView.frame.size.width/2];
        [cell.userImageView.layer setMasksToBounds:YES];
        
        cell.usernameLabel.text = @"Yasmin Benatti";
        

        
        return cell;
    } else {
        //sem imagem
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
    
    Post *post = [self.posts objectAtIndex:indexPath.row];
    
//    [self performSegueWithIdentifier:@"postSegue" sender:[NSString stringWithFormat:@"%d", post.postId]];
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


@end
