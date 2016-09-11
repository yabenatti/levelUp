//
//  SignupManager.m
//  levelUp
//
//  Created by Vinícius Lemes on 2016-09-10.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import "SignupManager.h"
#import "Constants.h"
#import "AppUtils.h"
#import "Urls.h"

@implementation SignupManager

static SignupManager *sharedInstance = nil;

/*!
 * @discussion Configura um singleton do SignupManager
 * @return instância do SignupManager responsável por todas as chamadas a métodos desse manager.
 */
+(SignupManager*)sharedInstance {
    if(sharedInstance == nil) {
        sharedInstance = [[self alloc] init];
        [super sharedInstance];
    }
    return sharedInstance;
}

/*!
 * @discussion Faz o signup do usuario
 * @param parameters dicionario com informações do signup.
 * @param completion bloco que executa ações com a resposta do server
 * @return void
 */
- (void)signUpWithParameters:(NSDictionary*)parameters andCompletion:(void (^)(BOOL isSuccess, User *user, NSString* message,NSError* theError)) completion {
    
    
    [self conectWithParameters:parameters atPath:URL_SIGNUP requestType:@"POST" withCompletion:^(id response, BOOL isSuccess, NSString *message, NSError *error) {
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
 * @discussion Registra beacon e pet
 * @param parameters dicionario com informações de registration.
 * @param completion bloco que executa ações com a resposta do server
 * @return void
 */
- (void)registrationWithParameters:(NSDictionary*)parameters andCompletion:(void (^)(BOOL isSuccess, User *user, NSString* message,NSError* theError)) completion {
    
    
    [self conectWithParameters:parameters atPath:URL_SIGNUP requestType:@"POST" withCompletion:^(id response, BOOL isSuccess, NSString *message, NSError *error) {
        if (isSuccess) {
            NSDictionary *responseDictionary = (NSDictionary*)response;
            
#warning EDITAR PARSE
            User *user = [[User new] parseToUser:[responseDictionary objectForKey:@"data"]];
            
            completion(YES, user, nil, nil);
            
        } else {
            completion(NO, nil, message, error);
        }
    }];
}

@end
