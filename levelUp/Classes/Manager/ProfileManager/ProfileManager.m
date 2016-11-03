//
//  ProfileManager.m
//  levelUp
//
//  Created by Vinícius Lemes on 2016-09-10.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import "ProfileManager.h"
#import "Urls.h"
#import "AppUtils.h"

@implementation ProfileManager

static ProfileManager *sharedInstance = nil;

/*!
 * @discussion Configura um singleton do ProfileManager
 * @return instância do ProfileManager responsável por todas as chamadas a métodos desse manager.
 */
+(ProfileManager*)sharedInstance {
    if(sharedInstance == nil) {
        sharedInstance = [[self alloc] init];
        [super sharedInstance];
    }
    return sharedInstance;
}

/*!
 * @discussion Recupera informacoes do perfil
 * @param parameters nil.
 * @param completion bloco que executa ações com a resposta do server
 * @return void
 */
- (void)retrieveProfileWithUserId:(NSString *)uid andCompletion:(void(^)(BOOL isSuccess, User * user, NSString *message, NSError *error)) completion {
    
    NSString *currentUserId = [NSString stringWithFormat:@"%@", [AppUtils retrieveFromUserDefaultWithKey:USER_ID]];

    [self connectWithParameters:nil atPath:URL_PROFILE(uid, currentUserId) requestType:@"GET" withCompletion:^(id response, BOOL isSuccess, NSString *message, NSError *error) {
        if(isSuccess) {
            NSDictionary *responseDictionary = (NSDictionary *)[response objectForKey:@"data"];
            
            User *user = [User new];
            user = [user parseToUser:responseDictionary];
            
            completion(YES, user, nil, nil);
            
        } else {
            completion(NO, nil, message, error);
        }
    }];
}

/*!
 * @discussion Edita informacoes do perfil
 * @param parameters nil.
 * @param completion bloco que executa ações com a resposta do server
 * @return void
 */
- (void)editProfileWithUserId:(NSString *)uid andParameters:(NSDictionary *)parameters andCompletion:(void(^)(BOOL isSuccess, User * user, NSString *message, NSError *error)) completion {
    
    NSString *currentUserId = [NSString stringWithFormat:@"%@", [AppUtils retrieveFromUserDefaultWithKey:USER_ID]];

    
    [self connectWithParameters:parameters atPath:URL_PROFILE(uid,currentUserId) requestType:@"PATCH" withCompletion:^(id response, BOOL isSuccess, NSString *message, NSError *error) {
        if(isSuccess) {
            NSDictionary *responseDictionary = (NSDictionary *)[response objectForKey:@"data"];
            
            User *user = [User new];
            user = [user parseToUser:responseDictionary];
            
            completion(YES, user, nil, nil);
            
        } else {
            completion(NO, nil, message, error);
        }
    }];
}

@end
