//
//  Post.h
//  levelUp
//
//  Created by Vinícius Lemes on 2016-09-11.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Post : NSObject

@property (nonatomic) int postId;
@property (nonatomic) int userId;
@property (nonatomic) int likesCount;

@property (nonatomic) BOOL iLiked;

@property (strong, nonatomic) NSString *postDescription;
@property (strong, nonatomic) NSString *postPetName;
@property (strong, nonatomic) NSString *postPetImage;
@property (strong, nonatomic) NSString *postDate;
@property (strong, nonatomic) NSString *postImage;

- (Post *)parseToPost:(NSDictionary *)postToParse;

@end
