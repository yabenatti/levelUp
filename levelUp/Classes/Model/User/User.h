//
//  User.h
//  levelUp
//
//  Created by Vinícius Lemes on 2016-09-10.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *petName;
@property (strong, nonatomic) NSString *birthDate;
@property (nonatomic) int userId;


-(User *)parseToUser:(NSDictionary *)userToParse;

@end
