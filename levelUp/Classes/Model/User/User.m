//
//  User.m
//  levelUp
//
//  Created by Vinícius Lemes on 2016-09-10.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import "User.h"

@implementation User

-(User *)parseToUser:(NSDictionary *)userToParse {
    
    self.email = [userToParse objectForKey:@"email"];
    self.petName = [userToParse objectForKey:@"pet_name"];
    self.birthDate = [userToParse objectForKey:@"birth_date"];
    self.userName = [userToParse objectForKey:@"name"];
    self.userId = [[userToParse objectForKey:@"id"]intValue];
    
    return self;
}

@end
