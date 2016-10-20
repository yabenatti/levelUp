//
//  TimelineTableViewCell.h
//  levelUp
//
//  Created by Vinícius Lemes on 2016-08-03.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TimelineCellDelegate <NSObject>

-(void)likeButton:(NSIndexPath *)indexPath;
-(void)commentButton:(NSIndexPath *)indexPath;

@end

@interface TimelineTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UILabel *postCaptionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstraint;

@property (strong, nonatomic) NSIndexPath *indexPath;
@property (assign, nonatomic) id<TimelineCellDelegate> delegate;

- (IBAction)likeButtonTouched:(id)sender;
- (IBAction)commentButtonTouched:(id)sender;

@end
