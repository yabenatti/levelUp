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
//    self.birthDate = [userToParse objectForKey:@"birth_date"];
//    self.userName = [userToParse objectForKey:@"name"];

//    int apiID = [[userToParse objectForKey:@"beacon_id"]intValue];
    int apiID = [[userToParse objectForKey:@"id"]intValue];
    self.userId = apiID;
    
    return self;
}

@end
