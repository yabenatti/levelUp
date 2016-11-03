//
//  ProfileViewController.h
//  levelUp
//
//  Created by Vinícius Lemes on 2016-08-03.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeLineTableViewCell.h"

@interface ProfileViewController : UIViewController <TimelineCellDelegate>

@property (strong, nonatomic) NSString *userId;

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIButton *followersButton;
@property (weak, nonatomic) IBOutlet UIButton *followingButton;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UITableView *postsTableView;
@property (weak, nonatomic) IBOutlet UIView *emptyView;


- (IBAction)editTouched:(id)sender;
- (IBAction)followersTouched:(id)sender;
- (IBAction)followingTouched:(id)sender;

@end
