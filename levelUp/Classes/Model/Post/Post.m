//
//  Post.m
//  levelUp
//
//  Created by Vinícius Lemes on 2016-09-11.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import "Post.h"
#import "Urls.h"

@implementation Post

- (Post *)parseToPost:(NSDictionary *)postToParse {
    
    self.postId = [[postToParse objectForKey:@"id"] intValue];
    if(![[postToParse objectForKey:@"user_id"] isKindOfClass:[NSNull class]]) {
        self.userId = [[postToParse objectForKey:@"user_id"] intValue];
    }
    if(![[postToParse objectForKey:@"description"] isKindOfClass:[NSNull class]]) {
        self.postDescription = [postToParse objectForKey:@"description"];
    }
    if(![[postToParse objectForKey:@"created_at"] isKindOfClass:[NSNull class]]) {
        self.postDate = [postToParse objectForKey:@"created_at"];
    }
    if(![[postToParse objectForKey:@"likes"] isKindOfClass:[NSNull class]]) {
        self.likesCount = [[postToParse objectForKey:@"likes"] intValue];
    }
    if(![[postToParse objectForKey:@"image"] isKindOfClass:[NSNull class]]) {
        self.postImage = [NSString stringWithFormat:@"%@%@", BASE_URL, [[postToParse objectForKey:@"image"]objectForKey:@"url"]];
    }
    
    return self;
}

@end
