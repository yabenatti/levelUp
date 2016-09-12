//
//  SignupManager.h
//  levelUp
//
//  Created by Vinícius Lemes on 2016-09-10.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import "NetworkManager.h"
#import "User.h"

@interface SignupManager : NetworkManager

+(SignupManager*)sharedInstance;

- (void)signUpWithParameters:(NSDictionary*)parameters andCompletion:(void (^)(BOOL isSuccess, User *user, NSString* message,NSError* theError)) completion;

@end
