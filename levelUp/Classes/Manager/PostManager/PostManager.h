//
//  PostManager.h
//  levelUp
//
//  Created by Vinícius Lemes on 2016-09-10.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import "NetworkManager.h"
#import "Post.h"

@interface PostManager : NetworkManager

+(PostManager*)sharedInstance;
- (void)getAllPostsWithUserId:(NSString *)uid andCompletion:(void(^)(BOOL isSuccess, NSArray *posts, NSString *message, NSError *error)) completion;
- (void)getMyPostsWithUserId:(NSString *)uid andCompletion:(void(^)(BOOL isSuccess, NSArray *posts, NSString *message, NSError *error)) completion;
-(void)createPostWithParameters:(NSMutableDictionary*)parameters imageData:(NSData*)image withCompletion:(void (^)(BOOL isSuccess, NSString *message, NSError *error))completion;
- (void)createCommentWithPostId:(NSString *)postId andParameters:(NSDictionary *)parameters andCompletion:(void(^)(BOOL isSuccess, NSString *message, NSError *error)) completion;
- (void)getCommentsWithPostId:(NSString *)postId andCompletion:(void(^)(BOOL isSuccess, NSMutableArray *comments, NSString *message, NSError *error)) completion;

@end
