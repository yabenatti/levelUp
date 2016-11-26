//
//  LoginManager.m
//  levelUp
//
//  Created by Vinícius Lemes on 2016-09-10.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import "LoginManager.h"
#import "Beacon.h"
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
    
    [self connectWithParameters:parameters atPath:URL_LOGIN requestType:@"POST" withCompletion:^(id response, BOOL isSuccess, NSString *message, NSError *error) {
        if (isSuccess) {
            NSDictionary *responseDictionary = (NSDictionary*)[response objectForKey:@"data"];

            User *user = [[User new] parseToUser:responseDictionary];
            
            [AppUtils saveToUserDefault: [NSString stringWithFormat:@"%@", [responseDictionary valueForKey:@"authentication_token"]] withKey:USER_TOKEN];
            [AppUtils saveToUserDefault: [NSString stringWithFormat:@"%@", [responseDictionary valueForKey:@"id"]] withKey:USER_ID];
            [AppUtils saveToUserDefault: [NSString stringWithFormat:@"%@", [responseDictionary valueForKey:@"name"]] withKey:USER_NAME];
            [AppUtils saveToUserDefault: [NSString stringWithFormat:@"%@", [responseDictionary valueForKey:@"pet_name"]] withKey:PET_NAME];
            
            [self getUserBeaconWithCompletion:^(BOOL isSuccess, NSString *message, NSError *theError) {
                if (isSuccess) {
                    completion(YES, user, nil, nil);
                } else {
                    completion(NO, nil, message, error);
                }
            }];
            
            
        } else {
            completion(NO, nil, message, error);
        }
    }];
}

/*!
 * @discussion Recupera o beacon do usuario
 * @param parameters nil
 * @param completion bloco que executa ações com a resposta do server
 * @return void
 */
- (void)getUserBeaconWithCompletion:(void (^)(BOOL isSuccess, NSString* message,NSError* theError)) completion {
    
    NSString *uid = [NSString stringWithFormat:@"%@", [AppUtils retrieveFromUserDefaultWithKey:USER_ID]];

    
    [self connectWithParameters:nil atPath:URL_MY_BEACON(uid) requestType:@"GET" withCompletion:^(id response, BOOL isSuccess, NSString *message, NSError *error) {
        if (isSuccess) {
            NSDictionary *responseDictionary = (NSDictionary*)response;

            Beacon *beacon = [[Beacon new] parseToBeacon:[responseDictionary objectForKey:@"data"]];
            [AppUtils saveToUserDefault:[NSString stringWithFormat:@"%d", beacon.beaconId] withKey:BEACON_ID];
            [AppUtils saveToUserDefault:beacon.beaconUniqueId withKey:BEACON_UNIQUE_ID];
            [AppUtils saveToUserDefault:[NSString stringWithFormat:@"%d", beacon.major] withKey:BEACON_MAJOR];
            [AppUtils saveToUserDefault:[NSString stringWithFormat:@"%d", beacon.minor] withKey:BEACON_MINOR];
            [AppUtils saveToUserDefault:beacon.petImage withKey:PET_IMAGE];
            [AppUtils saveToUserDefault:@"YES" withKey:DID_REGISTER];
            completion(YES, nil, nil);
            
        } else {
            completion(NO, message, error);
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
    
    NSString *uid = [NSString stringWithFormat:@"%@", [AppUtils retrieveFromUserDefaultWithKey:USER_ID]];

    [self connectWithParameters:parameters atPath:URL_LOGOUT(uid) requestType:@"DELETE" withCompletion:^(id response, BOOL isSuccess, NSString *message, NSError *error) {
        if(isSuccess) {
            completion(YES, nil, nil);
        } else {
            completion(NO, message, error);
        }
    }];
}

@end
