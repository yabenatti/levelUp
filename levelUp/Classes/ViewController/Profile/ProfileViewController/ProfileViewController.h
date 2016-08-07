//
//  ProfileViewController.h
//  levelUp
//
//  Created by Vinícius Lemes on 2016-08-03.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIButton *followersButton;
@property (weak, nonatomic) IBOutlet UIButton *followingButton;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UITableView *postsTableView;


- (IBAction)editTouched:(id)sender;
- (IBAction)followersTouched:(id)sender;
- (IBAction)followingTouched:(id)sender;

@end
