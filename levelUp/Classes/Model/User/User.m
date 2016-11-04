//
//  User.m
//  levelUp
//
//  Created by Vinícius Lemes on 2016-09-10.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import "User.h"
#import "Urls.h"

@implementation User

-(User *)parseToUser:(NSDictionary *)userToParse {
    
    self.email = [userToParse objectForKey:@"email"];
    self.petName = [userToParse objectForKey:@"pet_name"];
    self.birthDate = [userToParse objectForKey:@"birth_date"];
    self.userName = [userToParse objectForKey:@"name"];
    self.userId = [[userToParse objectForKey:@"id"]intValue];
    
    if(![[userToParse objectForKey:@"pet_image"] isKindOfClass:[NSNull class]]) {
        self.petImage = [NSString stringWithFormat:@"%@%@", BASE_URL, [[userToParse objectForKey:@"pet_image"]objectForKey:@"url"]];
    }
    
    return self;
}

@end
