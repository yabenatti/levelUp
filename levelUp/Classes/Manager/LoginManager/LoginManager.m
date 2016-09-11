//
//  LoginManager.m
//  levelUp
//
//  Created by Vinícius Lemes on 2016-09-10.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import "LoginManager.h"
#import "AppUtils.h"
#import "Constants.h"
#import "Urls.h"

@implementation LoginManager

static LoginManager *sharedInstance = nil;

/*!
 * @discussion Configura um singleton do LoginManager
 * @return instância do LoginManager responsável por todas as chamadas a métodos desse manager.
 */
+(LoginManager*)sharedInstance {
    if(sharedInstance == nil) {
        sharedInstance = [[self alloc] init];
        [super sharedInstance];
    }
    return sharedInstance;
}

/*!
 * @discussion Autentica usuário na API
 * @param parameters dicionario com informações do login.
 * @param completion bloco que executa ações com a resposta do server
 * @return void
 */
- (void)authenticateWithLogin:(NSDictionary*)parameters andCompletion:(void (^)(BOOL isSuccess, User *user, NSString* message,NSError* theError)) completion {

    
    [self conectWithParameters:parameters atPath:URL_LOGIN requestType:@"POST" withCompletion:^(id response, BOOL isSuccess, NSString *message, NSError *error) {
        if (isSuccess) {
            NSDictionary *responseDictionary = (NSDictionary*)response;
            
            User *user = [[User new] parseToUser:[responseDictionary objectForKey:@"data"]];
            
            [AppUtils saveToUserDefault: [NSString stringWithFormat:@"%@", [responseDictionary valueForKey:@"authentication_token"]] withKey:USER_TOKEN];
            
            completion(YES, user, nil, nil);
            
        } else {
            completion(NO, nil, message, error);
        }
    }];
}

/*!
 * @discussion Logout de usuario
 * @param parameters dicionario com informações do usuario.
 * @param completion bloco que executa ações com a resposta do server
 * @return void
 */
- (void)logoutWithApi:(NSDictionary *)parameters andCompletion:(void(^)(BOOL isSuccess, NSString *message, NSError *error)) completion {
    
    [self conectWithParameters:parameters atPath:URL_LOGIN requestType:@"DELETE" withCompletion:^(id response, BOOL isSuccess, NSString *message, NSError *error) {
        if(isSuccess) {
            completion(YES, nil, nil);
        } else {
            completion(NO, message, error);
        }
    }];
}

@end
