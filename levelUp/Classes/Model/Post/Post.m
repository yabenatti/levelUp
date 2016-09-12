//
//  Post.m
//  levelUp
//
//  Created by Vinícius Lemes on 2016-09-11.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import "Post.h"

@implementation Post

- (Post *)parseToPost:(NSDictionary *)postToParse {
    
    self.postId = [[postToParse objectForKey:@"id"] intValue];
    self.postDescription = [postToParse objectForKey:@"description"];
    
    return self;
}

@end
