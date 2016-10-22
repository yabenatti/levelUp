//
//  CommentTableViewCell.m
//  levelUp
//
//  Created by Yasmin Ringa on 22/10/16.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.userImageView.layer setCornerRadius:15.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
