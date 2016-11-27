//
//  PostManager.m
//  levelUp
//
//  Created by Vinícius Lemes on 2016-09-10.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import "PostManager.h"
#import "Constants.h"
#import "AppUtils.h"
#import "Comment.h"
#import "Urls.h"

@implementation PostManager

static PostManager *sharedInstance = nil;

/*!
 * @discussion Configura um singleton do PostManager
 * @return instância do PostManager responsável por todas as chamadas a métodos desse manager.
 */
+(PostManager*)sharedInstance {
    if(sharedInstance == nil) {
        sharedInstance = [[self alloc] init];
        [super sharedInstance];
    }
    return sharedInstance;
}

- (void)getAllPostsWithUserId:(NSString *)uid andCompletion:(void(^)(BOOL isSuccess, NSArray *posts, NSString *message, NSError *error)) completion {
    
    [self connectWithParameters:nil atPath:URL_ALL_POSTS(uid) requestType:@"GET" withCompletion:^(id response, BOOL isSuccess, NSString *message, NSError *error) {
        if(isSuccess) {
            NSArray *posts = (NSArray *)[response objectForKey:@"data"];
            NSMutableArray *postsArray = [NSMutableArray new];
            
            for (NSDictionary *postDictionary in posts) {
                Post *post = [Post new];
                post = [post parseToPost:postDictionary];
                
                [postsArray addObject:post];
            }
            
            completion(YES, postsArray, nil,nil);
        } else {
            completion(NO, nil, message, error);
        }
    }];
}

- (void)getMyPostsWithUserId:(NSString *)uid andCompletion:(void(^)(BOOL isSuccess, NSArray *posts, NSString *message, NSError *error)) completion {
    
    [self connectWithParameters:nil atPath:URL_MY_POSTS(uid) requestType:@"GET" withCompletion:^(id response, BOOL isSuccess, NSString *message, NSError *error) {
        if(isSuccess) {
            NSArray *posts = (NSArray *)[response objectForKey:@"data"];
            NSMutableArray *postsArray = [NSMutableArray new];
            
            for (NSDictionary *postDictionary in posts) {
                Post *post = [Post new];
                post = [post parseToPost:postDictionary];
                
                [postsArray addObject:post];
            }
            
            completion(YES, postsArray, nil,nil);

        } else {
            completion(NO, nil, message, error);
        }
    }];
}

- (void)getOtherPeoplesPostsWithUserId:(NSString *)uid andCompletion:(void(^)(BOOL isSuccess, NSArray *posts, NSString *message, NSError *error)) completion {
    
    NSString *currentUid = [NSString stringWithFormat:@"%@", [AppUtils retrieveFromUserDefaultWithKey:USER_ID]];

    
    [self connectWithParameters:nil atPath:URL_OTHER_POSTS(uid, currentUid) requestType:@"GET" withCompletion:^(id response, BOOL isSuccess, NSString *message, NSError *error) {
        if(isSuccess) {
            NSArray *posts = (NSArray *)[response objectForKey:@"data"];
            NSMutableArray *postsArray = [NSMutableArray new];
            
            for (NSDictionary *postDictionary in posts) {
                Post *post = [Post new];
                post = [post parseToPost:postDictionary];
                
                [postsArray addObject:post];
            }
            
            completion(YES, postsArray, nil,nil);
        } else {
            completion(NO, nil, message, error);
        }
    }];
}

-(void)createPostWithParameters:(NSMutableDictionary*)parameters imageData:(NSData*)image withCompletion:(void (^)(BOOL isSuccess, Post *post, NSString *message, NSError *error))completion {
    
    NSString *uid = [NSString stringWithFormat:@"%@", [AppUtils retrieveFromUserDefaultWithKey:USER_ID]];
    
    if([parameters objectForKey:@"post[image]"]) {
        NSData *image = [parameters objectForKey:@"post[image]"];
        [parameters removeObjectForKey:@"post[image]"];
        [self uploadFileToAPI:parameters atPath:URL_CREATE_POST(uid) requestType:@"MULTIPART-IMAGE" imageData:image withCompletion:^(id response, BOOL isSuccess, NSError *error) {
            if (isSuccess) {
                Post *post = [Post new];
                post = [post parseToPost:[response objectForKey:@"data"]];
                
                completion(YES, post, nil, nil);
            } else {
                completion(NO, nil, nil, error);
            }
        }];
    }
}

- (void)createCommentWithPostId:(NSString *)postId andParameters:(NSDictionary *)parameters andCompletion:(void(^)(BOOL isSuccess, NSString *message, NSError *error)) completion {
    
    NSString *uid = [NSString stringWithFormat:@"%@", [AppUtils retrieveFromUserDefaultWithKey:USER_ID]];

    [self connectWithParameters:parameters atPath:URL_COMMENT(postId, uid) requestType:@"POST" withCompletion:^(id response, BOOL isSuccess, NSString *message, NSError *error) {
        if(isSuccess) {
            completion(YES, nil,nil);
            
        } else {
            completion(NO, message, error);
        }
    }];
}

- (void)getCommentsWithPostId:(NSString *)postId andCompletion:(void(^)(BOOL isSuccess, NSMutableArray *comments, NSString *message, NSError *error)) completion {
    
    NSString *uid = [NSString stringWithFormat:@"%@", [AppUtils retrieveFromUserDefaultWithKey:USER_ID]];
    
    [self connectWithParameters:nil atPath:URL_COMMENT(postId, uid) requestType:@"GET" withCompletion:^(id response, BOOL isSuccess, NSString *message, NSError *error) {
        if(isSuccess) {
            NSArray *responseArray = (NSArray *)[response objectForKey:@"data"];
            NSMutableArray *commentsArray = [NSMutableArray new];
            
            for (NSDictionary *commentDictionary in responseArray) {
                Comment *comment = [Comment new];
                comment = [comment parseToComment:commentDictionary];
                [commentsArray addObject:comment];
            }
            
            completion(YES, commentsArray, nil,nil);
            
        } else {
            completion(NO, nil, message, error);
        }
    }];
}

- (void)createLikeWithPostId:(NSString *)postId andCompletion:(void(^)(BOOL isSuccess, NSString *message, NSError *error)) completion {
    
    NSString *uid = [NSString stringWithFormat:@"%@", [AppUtils retrieveFromUserDefaultWithKey:USER_ID]];
    
    [self connectWithParameters:nil atPath:URL_LIKES(postId, uid) requestType:@"POST" withCompletion:^(id response, BOOL isSuccess, NSString *message, NSError *error) {
        if(isSuccess) {
            completion(YES, nil,nil);
        } else {
            completion(NO, message, error);
        }
    }];
}

- (void)deleteLikeWithPostId:(NSString *)postId andCompletion:(void(^)(BOOL isSuccess, NSString *message, NSError *error)) completion {
    
    NSString *uid = [NSString stringWithFormat:@"%@", [AppUtils retrieveFromUserDefaultWithKey:USER_ID]];
    
    [self connectWithParameters:nil atPath:URL_LIKES(postId, uid) requestType:@"DELETE" withCompletion:^(id response, BOOL isSuccess, NSString *message, NSError *error) {
        if(isSuccess) {
            completion(YES, nil,nil);
        } else {
            completion(NO, message, error);
        }
    }];
}

- (void)createRelationshipWithUserId:(NSDictionary *)parameters andCompletion:(void(^)(BOOL isSuccess, NSString *message, NSError *error)) completion {
    
    NSString *currentUid = [NSString stringWithFormat:@"%@", [AppUtils retrieveFromUserDefaultWithKey:USER_ID]];
    
    [self connectWithParameters:parameters atPath:URL_RELATIONSHIP(currentUid) requestType:@"POST" withCompletion:^(id response, BOOL isSuccess, NSString *message, NSError *error) {
        if(isSuccess) {
            completion(YES, nil,nil);
        } else {
            completion(NO, message, error);
        }
    }];
}


@end
