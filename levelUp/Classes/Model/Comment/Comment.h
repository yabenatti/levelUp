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
@property (strong, nonatomic) NSString *commentDescription; 

@end
