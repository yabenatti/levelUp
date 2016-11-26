//
//  TimelineViewController.h
//  levelUp
//
//  Created by Vinícius Lemes on 2016-08-03.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeLineTableViewCell.h"

@interface TimelineViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, TimelineCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *postsTableView;
@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property (weak, nonatomic) IBOutlet UIView *postBeaconView;

@end
