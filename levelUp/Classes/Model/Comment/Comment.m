//
//  Comment.m
//  levelUp
//
//  Created by Vinícius Lemes on 2016-09-11.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import "Comment.h"
#import "Urls.h"

@implementation Comment

-(Comment *)parseToComment:(NSDictionary *)commentToParse {
    self.commentId = [[commentToParse objectForKey:@"id"]intValue];
    self.userId = [[commentToParse objectForKey:@"user_id"]intValue];
    self.postId = [[commentToParse objectForKey:@"post_id"]intValue];
    self.commentDescription = [commentToParse objectForKey:@"description"];
    self.petName = [commentToParse objectForKey:@"pet_name"];
    
    if(![[commentToParse objectForKey:@"pet_image"] isKindOfClass:[NSNull class]]) {
        self.petImage = [NSString stringWithFormat:@"%@%@", BASE_URL, [[commentToParse objectForKey:@"pet_image"]objectForKey:@"url"]];
    }

    return self;
}

@end
