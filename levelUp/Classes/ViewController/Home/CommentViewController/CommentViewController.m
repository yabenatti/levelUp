//
//  CommentViewController.m
//  levelUp
//
//  Created by Yasmin Ringa on 22/10/16.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentTableViewCell.h"
#import "Comment.h"
#import "PostManager.h"
#import "AppUtils.h"
#import "Constants.h"

@interface CommentViewController ()

@property (strong, nonatomic) NSArray *commentsArray;

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    label.text = NSLocalizedString(@"Comments", @"");
    [label sizeToFit];
    self.navigationItem.titleView = label;
    
    self.commentsArray = [NSArray new];
    
    [self.commentButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.commentButton setUserInteractionEnabled:NO];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 70;
}

-(void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self getComments];
}

-(void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
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

#pragma mark - Helpers 

-(void)getComments {
    [AppUtils startLoadingInView:self.view];
    [[PostManager sharedInstance]getCommentsWithPostId:self.postId andCompletion:^(BOOL isSuccess, NSMutableArray *comments, NSString *message, NSError *error) {
        [AppUtils stopLoadingInView:self.view];
        if (isSuccess) {
            self.commentsArray = comments;
            [self.tableView reloadData];
        } else {
            [self.navigationController presentViewController:[AppUtils setupAlertWithMessage:message] animated:YES completion:nil];
        }
    }];
}

#pragma mark - TextField

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if([textField.text isEqualToString:@""]) {
        [self.commentButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.commentButton setUserInteractionEnabled:NO];
    } else {
        [self.commentButton setTitleColor:COLOR_LIGHT_BLUE forState:UIControlStateNormal];
        [self.commentButton setUserInteractionEnabled:YES];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.commentsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Comment *comment = [self.commentsArray objectAtIndex:indexPath.row];
    
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell" forIndexPath:indexPath];
    
    if(cell == nil) {
        cell = [[CommentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"commentCell"];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.indexPath = indexPath;
//    cell.userNameLabel.text = comment.userName;
    cell.userNameLabel.text = @"another pet";
    cell.userCommentLabel.text = comment.commentDescription;
    [AppUtils setupImageWithUrl:@"https://s-media-cache-ak0.pinimg.com/originals/c9/77/c1/c977c1ccfc34259fa3811c8839e0f6e3.jpg" andPlaceholder:@"ic_person" andImageView:cell.userImageView];

    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

#pragma mark - IBActions

- (IBAction)commentButtonTouched:(id)sender {
    NSDictionary *parameters = @{ @"comment" : @{ @"description" : self.commentTextField.text }};
    
    [AppUtils startLoadingInView:self.view];
    [[PostManager sharedInstance]createCommentWithPostId:self.postId andParameters:parameters andCompletion:^(BOOL isSuccess, NSString *message, NSError *error) {
        [AppUtils stopLoadingInView:self.view];
        if (isSuccess) {
            [self getComments];
        } else {
            [self.navigationController presentViewController:[AppUtils setupAlertWithMessage:message] animated:YES completion:nil];
        }
    }];
    
}

#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *)n {
    NSDictionary* info = [n userInfo];
    
    NSNumber *duration = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [info objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    NSLog(@"%f",self.view.frame.origin.x);
    NSLog(@"%f",self.view.frame.origin.y);
    
    self.view.frame = CGRectMake(0, (-kbSize.height) + 50, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
    
}

- (void)keyboardWillHide:(NSNotification *)n {
    NSDictionary* info = [n userInfo];
    
    NSNumber *duration = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [info objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    self.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

@end
