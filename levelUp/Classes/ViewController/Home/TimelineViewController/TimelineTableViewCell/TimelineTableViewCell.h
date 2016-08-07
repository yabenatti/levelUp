//
//  TimelineTableViewCell.h
//  levelUp
//
//  Created by Vinícius Lemes on 2016-08-03.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimelineTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;


@end
