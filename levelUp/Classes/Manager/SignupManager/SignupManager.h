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
//- (void)registerBeaconWithParameters:(NSDictionary*)parameters andCompletion:(void (^)(BOOL isSuccess, NSString* message,NSError* theError)) completion;
-(void)registerBeaconWithParameters:(NSMutableDictionary*)parameters imageData:(NSData*)image withCompletion:(void (^)(BOOL isSuccess, NSString *message, NSError *error))completion;
@end
