//
//  TimelineViewController.m
//  levelUp
//
//  Created by Vinícius Lemes on 2016-08-03.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import "TimelineViewController.h"
#import "NewPostViewController.h"
#import "CommentViewController.h"
#import "LoginViewController.h"
#import "ProfileViewController.h"
#import "PostManager.h"
#import "AppUtils.h"
#import "Constants.h"
#import <EstimoteSDK/EstimoteSDK.h>
#import "UIImageView+AFNetworking.h"


@interface TimelineViewController () <ESTBeaconManagerDelegate>

@property (strong, nonatomic) NSArray *posts;
@property (nonatomic) ESTBeaconManager *beaconManager;
@property (nonatomic) CLBeaconRegion *beaconRegion;
@property (nonatomic) NSDictionary *placesByBeacons;
@property (nonatomic) BOOL enteredRegion;
@property (strong, nonatomic) NSTimer *timerBeacons;
@property (strong, nonatomic) NSTimer *timerNewlyCreatedPost;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Navigation Bar
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    
    //Title View
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = COLOR_LIGHT_BLUE;
    label.text = NSLocalizedString(@"Level Up Your Pet", @"");
    [label sizeToFit];
    self.navigationItem.titleView = label;
    
    // Do any additional setup after loading the view.
    self.enteredRegion = NO;
    
    self.beaconManager = [ESTBeaconManager new];
    self.beaconManager.delegate = self;
    
    [self.emptyView setHidden:YES];
    [self.postBeaconView.layer setCornerRadius:5.0f];
    
    //Inicializacoes
    self.posts = [NSArray new];
    
    self.postsTableView.rowHeight = UITableViewAutomaticDimension;
    self.postsTableView.estimatedRowHeight = 450;

}

-(void)viewWillAppear:(BOOL)animated {
    [self.postBeaconView setHidden:YES];
    self.enteredRegion = NO;

    NSString *token = [NSString stringWithFormat:@"%@", [AppUtils retrieveFromUserDefaultWithKey:USER_TOKEN]];
    NSString *registration = [NSString stringWithFormat:@"%@", [AppUtils retrieveFromUserDefaultWithKey:DID_REGISTER]];

    if([token isEqualToString:@"(null)"] || ![registration isEqualToString:@"YES"]) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        LoginViewController *vc = [sb instantiateInitialViewController];
        [self.navigationController presentViewController:vc animated:YES completion:nil];
    } else {
        
        NSLog(@"%@", [AppUtils retrieveFromUserDefaultWithKey:BEACON_UNIQUE_ID ]);
        self.beaconRegion = [[CLBeaconRegion alloc]
                             initWithProximityUUID:[[NSUUID alloc]
                                                    initWithUUIDString:[NSString stringWithFormat:@"%@", [AppUtils retrieveFromUserDefaultWithKey:BEACON_UNIQUE_ID ]]]
                             identifier:@"ranged region"];
        
        self.timerBeacons = [NSTimer scheduledTimerWithTimeInterval: 30.0
                                                             target: self
                                                           selector:@selector(onTick:)
                                                           userInfo: nil repeats:YES];

        [self getAllPosts];
       
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.enteredRegion = YES;
    [self.beaconManager stopRangingBeaconsInRegion:self.beaconRegion];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onTick:(id)sender {
    if(self.enteredRegion) {
        self.enteredRegion = NO;
    }
}

- (void)closeNewlyCreatedPostView:(id)sender {
    [self.postBeaconView setHidden:YES];
    
}

- (void)getAllPosts {
    [AppUtils startLoadingInView:self.view];

    [[PostManager sharedInstance]getAllPostsWithUserId:[NSString stringWithFormat:@"%@", [AppUtils retrieveFromUserDefaultWithKey:USER_ID]] andCompletion:^(BOOL isSuccess, NSArray *posts, NSString *message, NSError *error) {
        [AppUtils stopLoadingInView:self.view];
        if(isSuccess) {
            [self.beaconManager startRangingBeaconsInRegion:self.beaconRegion];
            [self.beaconManager requestAlwaysAuthorization];

            if([posts count] > 0) {
                self.posts = posts;
                [self.emptyView setHidden:YES];
                [self.postsTableView reloadData];
                [self.postsTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
            } else {
                [self.emptyView setHidden:NO];
            }
            
        } else {
            [self.navigationController presentViewController:[AppUtils setupAlertWithMessage:message] animated:YES completion:nil];
        }
    }];
}

- (NSArray *)placesNearBeacon:(CLBeacon *)beacon {
    NSString *beaconKey = [NSString stringWithFormat:@"%@:%@",
                           beacon.major, beacon.minor];
    NSDictionary *places = [self.placesByBeacons objectForKey:beaconKey];
    NSArray *sortedPlaces = [places keysSortedByValueUsingComparator:
                             ^NSComparisonResult(id obj1, id obj2) {
                                 return [obj1 compare:obj2];
                             }];
    return sortedPlaces;
}

- (void)beaconManager:(id)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    CLBeacon *nearestBeacon = beacons.firstObject;
    if (nearestBeacon) {
        if(!self.enteredRegion) {
            NSString *major = [NSString stringWithFormat:@"%@",[AppUtils retrieveFromUserDefaultWithKey:BEACON_MAJOR]];
            NSString *minor = [NSString stringWithFormat:@"%@",[AppUtils retrieveFromUserDefaultWithKey:BEACON_MINOR]];
            
            NSLog(@"Major: %@ Minor: %@", major, minor);

            NSString *nearestMajor = [NSString stringWithFormat:@"%@",nearestBeacon.major];
            NSString *nearestMinor = [NSString stringWithFormat:@"%@",nearestBeacon.minor];
            
            NSLog(@"Nearest Major: %@ Nearest Minor: %@", nearestMajor, nearestMinor);

            
            if([nearestMajor isEqualToString:major] && [nearestMinor isEqualToString:minor]) {
                [self.beaconManager stopRangingBeaconsInRegion:self.beaconRegion];
                
                self.enteredRegion = YES;
                
                 NSData *petImageData = UIImageJPEGRepresentation([UIImage imageNamed:@"catEating"], 0.5);
                
                NSMutableDictionary *parameters = [[NSMutableDictionary alloc]initWithDictionary:@{@"post[description]" : @"Food YUM!",
                                                                                                   @"post[image]" : petImageData
                                                                                                   }];
                
                [AppUtils startLoadingInView:self.view];
                [[PostManager sharedInstance]createPostWithParameters:parameters imageData:petImageData withCompletion:^(BOOL isSuccess, Post *post, NSString *message, NSError *error) {
                    [AppUtils stopLoadingInView:self.view];
                    if(isSuccess) {
                        [self.postBeaconView setHidden:NO];
                        self.timerNewlyCreatedPost = [NSTimer scheduledTimerWithTimeInterval: 10.0
                                                                             target: self
                                                                           selector:@selector(closeNewlyCreatedPostView:)
                                                                           userInfo: nil repeats:NO];

                        [self getAllPosts];
                    } else {
                        [self.navigationController presentViewController:[AppUtils setupAlertWithMessage:message] animated:YES completion:nil];
                    }
                }];
            }
        }
        
    }
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.posts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Post *post = [self.posts objectAtIndex:indexPath.row];

    TimelineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"timelineCell" forIndexPath:indexPath];
    
    if(cell == nil) {
        cell = [[TimelineTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"timelineCell"];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.indexPath = indexPath;
    cell.delegate = self;

    [cell.userImageButton.layer setCornerRadius:cell.userImageButton.frame.size.width/2];
    [cell.userImageButton.layer setMasksToBounds:YES];
    
    if(post.iLiked) {
        [cell.likeButton setImage:[UIImage imageNamed:@"ic_favorite"] forState:UIControlStateNormal];
    } else {
        [cell.likeButton setImage:[UIImage imageNamed:@"ic_favorite_border"] forState:UIControlStateNormal];
    }
    
    cell.usernameLabel.text = post.postPetName;
    cell.postCaptionLabel.text = post.postDescription;
    
    if([post.postImage isEqualToString:@""]) {
        cell.imageHeightConstraint.constant = 0;
    } else {
        

        __weak UIImageView *weakImageView = cell.postImageView;
        
        NSURL *url = [NSURL URLWithString: post.postImage];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        [weakImageView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"ic_pets"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            [weakImageView setContentMode:UIViewContentModeScaleAspectFill];
            weakImageView.image = image;
            weakImageView.layer.masksToBounds = YES;
            
            NSURL *url = [NSURL URLWithString:post.postPetImage];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *img = [[UIImage alloc] initWithData:data];
            [cell.userImageButton setImage:img forState:UIControlStateNormal];
            
        }failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
        

        cell.imageHeightConstraint.constant = 256.0f;
    }

    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Timeline Cell Delegate

-(void)commentButton:(NSIndexPath *)indexPath {
    Post *post = [self.posts objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"commentSegue" sender:[NSString stringWithFormat:@"%d", post.postId]];
}

-(void)likeButton:(NSIndexPath *)indexPath {
    Post *post = [self.posts objectAtIndex:indexPath.row];
    
    if(post.iLiked) {
        [AppUtils startLoadingInView:self.view];
        [[PostManager sharedInstance]deleteLikeWithPostId:[NSString stringWithFormat:@"%d",post.postId] andCompletion:^(BOOL isSuccess, NSString *message, NSError *error) {
            [AppUtils stopLoadingInView:self.view];
            if(isSuccess) {
                [self getAllPosts];
            } else {
                [self.navigationController presentViewController:[AppUtils setupAlertWithMessage:message] animated:YES completion:nil];
            }
        }];
    } else {
        [AppUtils startLoadingInView:self.view];
        [[PostManager sharedInstance]createLikeWithPostId:[NSString stringWithFormat:@"%d",post.postId] andCompletion:^(BOOL isSuccess, NSString *message, NSError *error) {
            [AppUtils stopLoadingInView:self.view];
            if(isSuccess) {
                [self getAllPosts];
            } else {
                [self.navigationController presentViewController:[AppUtils setupAlertWithMessage:message] animated:YES completion:nil];
            }
        }];
    }
}

-(void)userImageButton:(NSIndexPath *)indexPath {
    Post *post = [self.posts objectAtIndex:indexPath.row];

    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
    ProfileViewController *vc = [sb instantiateViewControllerWithIdentifier:@"Profile"];
    vc.userId = [NSString stringWithFormat:@"%d", post.userId];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"commentSegue"]) {
        CommentViewController *vc = [segue destinationViewController];
        vc.postId = sender;
//        vc.hidesBottomBarWhenPushed = YES;
    }
}


@end
