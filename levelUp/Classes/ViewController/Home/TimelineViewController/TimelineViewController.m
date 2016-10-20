//
//  TimelineViewController.m
//  levelUp
//
//  Created by Vinícius Lemes on 2016-08-03.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import "TimelineViewController.h"
#import "NewPostViewController.h"
#import "RegistrationViewController.h"
#import "LoginViewController.h"
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
    
    UIBarButtonItem *postItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_pets"] style:UIBarButtonItemStyleDone target:self action:@selector(postTouched:)];
    
    self.navigationItem.rightBarButtonItem = postItem;
    
    [self.emptyView setHidden:YES];

    
    //Inicializacoes
    self.posts = [NSArray new];

}

-(void)viewWillAppear:(BOOL)animated {    
    self.enteredRegion = NO;

    NSString *token = [NSString stringWithFormat:@"%@", [AppUtils retrieveFromUserDefaultWithKey:USER_TOKEN]];
    NSString *registration = [NSString stringWithFormat:@"%@", [AppUtils retrieveFromUserDefaultWithKey:DID_REGISTER]];

    if([token isEqualToString:@"(null)"]) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        LoginViewController *vc = [sb instantiateInitialViewController];
        [self.navigationController presentViewController:vc animated:YES completion:nil];
    } else if (![registration isEqualToString:@"YES"]) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        RegistrationViewController *vc = [sb instantiateViewControllerWithIdentifier:@"registration"];
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

- (void)getAllPosts {
    [[PostManager sharedInstance]getAllPostsWithUserId:[NSString stringWithFormat:@"%@", [AppUtils retrieveFromUserDefaultWithKey:USER_ID]] andCompletion:^(BOOL isSuccess, NSArray *posts, NSString *message, NSError *error) {
        if(isSuccess) {
            [self.beaconManager startRangingBeaconsInRegion:self.beaconRegion];
            [self.beaconManager requestAlwaysAuthorization];

            if([posts count] > 0) {
                self.posts = posts;
                [self.emptyView setHidden:YES];
                [self.postsTableView reloadData];
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
    NSDictionary *postInfo = [NSDictionary new];
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
            }
        }
        
    }
}

- (void)postTouched:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Post" bundle:nil];
    NewPostViewController *vc = [sb instantiateViewControllerWithIdentifier:@"newPost"];
    [self.navigationController pushViewController:vc animated:YES];
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

    [cell.userImageView.layer setCornerRadius:cell.userImageView.frame.size.width/2];
    [cell.userImageView.layer setMasksToBounds:YES];
    
    __weak UIImageView *weakImageView2 = cell.userImageView;
    NSLog(@"%@", [NSString stringWithFormat:@"%@", [AppUtils retrieveFromUserDefaultWithKey:PET_IMAGE ]]);
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@", [AppUtils retrieveFromUserDefaultWithKey:PET_IMAGE ]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [weakImageView2 setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"ic_person"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [weakImageView2 setContentMode:UIViewContentModeScaleAspectFill];
        weakImageView2.image = image;
        weakImageView2.layer.masksToBounds = YES;
        
    }failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];

    
    cell.usernameLabel.text = [NSString stringWithFormat:@"%@", [AppUtils retrieveFromUserDefaultWithKey:PET_NAME]];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 450;
}


#pragma mark - Navigation

//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}


@end
