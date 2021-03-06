//
//  TimelineTableViewCell.m
//  levelUp
//
//  Created by Vinícius Lemes on 2016-08-03.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import "TimelineTableViewCell.h"

@implementation TimelineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)likeButtonTouched:(id)sender {
    [self.delegate likeButton:self.indexPath];
}

- (IBAction)commentButtonTouched:(id)sender {
    [self.delegate commentButton:self.indexPath];
}

- (IBAction)userImageTouched:(id)sender {
    [self.delegate userImageButton:self.indexPath];
}
@end
