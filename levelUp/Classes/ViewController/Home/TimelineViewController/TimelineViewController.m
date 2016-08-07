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
#import "PostTableViewCell.h"

@interface TimelineViewController ()

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *postItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_pets"] style:UIBarButtonItemStyleDone target:self action:@selector(postTouched:)];
    
    self.navigationItem.rightBarButtonItem = postItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)postTouched:(id)sender {
    [self performSegueWithIdentifier:@"postSegue" sender:self];
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        TimelineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"timelineCell" forIndexPath:indexPath];
        
        if(cell == nil) {
            cell = [[TimelineTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"timelineCell"];
        }
        
        [cell.userImageView.layer setCornerRadius:cell.userImageView.frame.size.width/2];
        [cell.userImageView.layer setMasksToBounds:YES];
        cell.usernameLabel.text = @"Yasmin Benatti";
        

        
        return cell;
    } else {
        PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"postCell" forIndexPath:indexPath];
        
        if(cell == nil) {
            cell = [[PostTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"postCell"];
        }
        
        [cell.userImageView.layer setCornerRadius:cell.userImageView.frame.size.width/2];
        [cell.userImageView.layer setMasksToBounds:YES];
        cell.usernameLabel.text = @"Yasmin Benatti";
        cell.postLabel.text = @"This is a text post";
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        return 450;
    } else {
        return 250;
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"postSegue"]) {
        NewPostViewController *vc = [segue destinationViewController];
    }
}


@end
