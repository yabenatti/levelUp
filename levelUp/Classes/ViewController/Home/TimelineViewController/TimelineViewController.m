//
//  TimelineViewController.m
//  levelUp
//
//  Created by Vinícius Lemes on 2016-08-03.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import "TimelineViewController.h"
#import "NewPostViewController.h"
#import "TimeLineTableViewCell.h"
#import "LoginViewController.h"
#import "PostTableViewCell.h"
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
    self.beaconRegion = [[CLBeaconRegion alloc]
                         initWithProximityUUID:[[NSUUID alloc]
                                                initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"]
                         identifier:@"ranged region"];
    [self.beaconManager requestAlwaysAuthorization];
    
    UIBarButtonItem *postItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_pets"] style:UIBarButtonItemStyleDone target:self action:@selector(postTouched:)];
    
    self.navigationItem.rightBarButtonItem = postItem;
    
    [self.emptyView setHidden:YES];

    
    //Inicializacoes
    self.posts = [NSArray new];
}

-(void)viewWillAppear:(BOOL)animated {
    self.enteredRegion = NO;

    NSString *token = [NSString stringWithFormat:@"%@", [AppUtils retrieveFromUserDefaultWithKey:USER_TOKEN]];
    if([token isEqualToString:@"(null)"]) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        LoginViewController *vc = [sb instantiateInitialViewController];
        [self.navigationController presentViewController:vc animated:YES completion:nil];
        
    } else {
        [self getAllPosts];
        NSTimer *t = [NSTimer scheduledTimerWithTimeInterval: 30.0
                                                      target: self
                                                    selector:@selector(onTick:)
                                                    userInfo: nil repeats:YES];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
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

- (void)getAllPosts {
    [[PostManager sharedInstance]getAllPostsWithUserId:[NSString stringWithFormat:@"%@", [AppUtils retrieveFromUserDefaultWithKey:USER_ID]] andCompletion:^(BOOL isSuccess, NSArray *posts, NSString *message, NSError *error) {
        if(isSuccess) {
            self.posts = posts;
            [self.beaconManager startRangingBeaconsInRegion:self.beaconRegion];

            [self.postsTableView reloadData];
            
            if([posts count] == 0) {
                [self.emptyView setHidden:NO];
            } else {
                [self.emptyView setHidden:YES];
                [self.postsTableView reloadData];
            }
            
        } else {
            
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
    NSDictionary *postInfo = [NSDictionary new];
    if (nearestBeacon) {
        if(!self.enteredRegion) {
            if([nearestBeacon.major  isEqual: @47798] && [nearestBeacon.minor  isEqual: @37813]) {
                [self.beaconManager stopRangingBeaconsInRegion:self.beaconRegion];
                
                self.enteredRegion = YES;
                
                postInfo = @{@"post" : @{@"description" : @"I'm the food beacon YUM",
                                                       @"image" : @"http://data3.whicdn.com/images/148217235/large.jpg"}};
                
                [[PostManager sharedInstance]createPostWithInfo:postInfo andCompletion:^(BOOL isSuccess, NSString *message, NSError *error) {
                    if (isSuccess) {
                        [self.navigationController presentViewController:[AppUtils setupAlertWithMessage:@"FOOD! YUM!"] animated:YES completion:nil];
                        [self getAllPosts];
                    } else {
                        [self.navigationController presentViewController:[AppUtils setupAlertWithMessage:message] animated:YES completion:nil];
                    }
                }];
                
            } else if([nearestBeacon.major  isEqual: @58375] && [nearestBeacon.minor  isEqual: @30394]) {
                [self.beaconManager stopRangingBeaconsInRegion:self.beaconRegion];
                
                self.enteredRegion = YES;
                
                postInfo = @{@"post" : @{@"description" : @"Sleepests Warriors, to the pillow zone!",
                                         @"image" : @"http://25dip.com/wp-content/uploads/2012/11/cat-sleeping-with-animal.jpg"}};
                
                
                [[PostManager sharedInstance]createPostWithInfo:postInfo andCompletion:^(BOOL isSuccess, NSString *message, NSError *error) {
                    if (isSuccess) {
                        [self.navigationController presentViewController:[AppUtils setupAlertWithMessage:@"NIGHT TIME!"] animated:YES completion:nil];
                        [self getAllPosts];
                    } else {
                        [self.navigationController presentViewController:[AppUtils setupAlertWithMessage:message] animated:YES completion:nil];
                    }
                }];

            } else if([nearestBeacon.major  isEqual: @59492] && [nearestBeacon.minor  isEqual: @13064]) {
                [self.beaconManager stopRangingBeaconsInRegion:self.beaconRegion];
                
                self.enteredRegion = YES;
                
                postInfo = @{@"post" : @{@"description" : @"LET ME OUT!",
                                         @"image" : @"http://petslady.com/sites/default/files/inline-images/kitty-pass_.jpg"}};
                
                
                [[PostManager sharedInstance]createPostWithInfo:postInfo andCompletion:^(BOOL isSuccess, NSString *message, NSError *error) {
                    if (isSuccess) {
                        [self.navigationController presentViewController:[AppUtils setupAlertWithMessage:@"AT THE DOOR!"] animated:YES completion:nil];
                        [self getAllPosts];
                    } else {
                        [self.navigationController presentViewController:[AppUtils setupAlertWithMessage:message] animated:YES completion:nil];
                    }
                }];

            }
            
        }
        
    }
}

- (void)postTouched:(id)sender {
    [self performSegueWithIdentifier:@"postSegue" sender:self];
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
    
    
    [cell.userImageView.layer setCornerRadius:cell.userImageView.frame.size.width/2];
    [cell.userImageView.layer setMasksToBounds:YES];
    
    __weak UIImageView *weakImageView2 = cell.userImageView;
    
    NSURL *url = [NSURL URLWithString: @"https://www.facebook.com/photo.php?fbid=869040959839803&set=a.564828320261070.1073741828.100002017222504&type=3&theater"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [weakImageView2 setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"ic_person"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [weakImageView2 setContentMode:UIViewContentModeScaleAspectFill];
        weakImageView2.image = image;
        weakImageView2.layer.masksToBounds = YES;
        
    }failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];

    
    cell.usernameLabel.text = [NSString stringWithFormat:@"%@", [AppUtils retrieveFromUserDefaultWithKey:USER_NAME]];
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
            
        }failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
        

        cell.imageHeightConstraint.constant = 256.0f;
    }

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 450;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
