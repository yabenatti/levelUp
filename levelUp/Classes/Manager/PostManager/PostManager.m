//
//  PostManager.m
//  levelUp
//
//  Created by Vinícius Lemes on 2016-09-10.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import "PostManager.h"
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
    
    [self conectWithParameters:nil atPath:URL_ALL_POSTS(uid) requestType:@"GET" withCompletion:^(id response, BOOL isSuccess, NSString *message, NSError *error) {
        if(isSuccess) {
            NSArray *posts = (NSArray *)[response objectForKey:@"data"];
            
            for (NSDictionary *postDictionary in posts) {
                Post *post = [Post new];
                post = [post parseToPost:postDictionary];
            }
            
            completion(YES, posts, nil,nil);
        } else {
            completion(NO, nil, message, error);
        }
    }];
}

- (void)getMyPostsWithUserId:(NSString *)uid andCompletion:(void(^)(BOOL isSuccess, NSArray *posts, NSString *message, NSError *error)) completion {
    
    [self conectWithParameters:nil atPath:URL_MY_POSTS(uid) requestType:@"GET" withCompletion:^(id response, BOOL isSuccess, NSString *message, NSError *error) {
        if(isSuccess) {
            NSArray *posts = (NSArray *)[response objectForKey:@"data"];
            
            for (NSDictionary *postDictionary in posts) {
                Post *post = [Post new];
                post = [post parseToPost:postDictionary];
            }
            
            completion(YES, posts, nil,nil);
        } else {
            completion(NO, nil, message, error);
        }
    }];
}


@end
