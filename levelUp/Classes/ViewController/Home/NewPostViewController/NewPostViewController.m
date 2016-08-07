//
//  NewPostViewController.m
//  levelUp
//
//  Created by Vinícius Lemes on 2016-08-07.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import "NewPostViewController.h"

@interface NewPostViewController ()

@end

@implementation NewPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *postItem = [[UIBarButtonItem alloc]initWithTitle:@"Post" style:UIBarButtonItemStylePlain target:self action:@selector(postTouched:)];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelTouched:)];

    self.navigationItem.rightBarButtonItem = postItem;
    self.navigationItem.leftBarButtonItem = cancelItem;
    
}

- (void)postTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
