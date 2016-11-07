//
//  ShareViewController.h
//  levelUp
//
//  Created by Yasmin Ringa on 03/11/16.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareViewController : UIViewController

@property (strong, nonatomic) NSDictionary *postInfo;

@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UILabel *postCaptionTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;

- (IBAction)twitterButtonTouched:(id)sender;
- (IBAction)facebookButtonTouched:(id)sender;

@end
