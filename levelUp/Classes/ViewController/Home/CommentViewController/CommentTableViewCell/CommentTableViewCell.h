//
//  CommentTableViewCell.h
//  levelUp
//
//  Created by Yasmin Ringa on 22/10/16.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userCommentLabel;
@property (strong, nonatomic) NSIndexPath *indexPath;

@end
