//
//  Comment.h
//  levelUp
//
//  Created by Vinícius Lemes on 2016-09-11.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject

@property (nonatomic) int commentId;
@property (nonatomic) int userId;
@property (nonatomic) int postId;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userImage;
@property (strong, nonatomic) NSString *commentDescription;

-(Comment *)parseToComment:(NSDictionary *)commentToParse;

@end
