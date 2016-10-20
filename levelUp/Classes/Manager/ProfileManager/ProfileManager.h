//
//  ProfileManager.h
//  levelUp
//
//  Created by Vinícius Lemes on 2016-09-10.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import "NetworkManager.h"
#import "User.h"

@interface ProfileManager : NetworkManager

+(ProfileManager*)sharedInstance;

- (void)retrieveProfileWithUserId:(NSString *)uid andCompletion:(void(^)(BOOL isSuccess, User * user, NSString *message, NSError *error)) completion;
- (void)editProfileWithUserId:(NSString *)uid andParameters:(NSDictionary *)parameters andCompletion:(void(^)(BOOL isSuccess, User * user, NSString *message, NSError *error)) completion;

@end
