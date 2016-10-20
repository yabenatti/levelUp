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
#import "Beacon.h"

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
    
    
    [self connectWithParameters:parameters atPath:URL_SIGNUP requestType:@"POST" withCompletion:^(id response, BOOL isSuccess, NSString *message, NSError *error) {
        if (isSuccess) {
            NSDictionary *responseDictionary = (NSDictionary*)[response objectForKey:@"data"];
            
            User *user = [[User new] parseToUser:responseDictionary];
            
            [AppUtils saveToUserDefault: [NSString stringWithFormat:@"%@", [responseDictionary valueForKey:@"authentication_token"]] withKey:USER_TOKEN];
            [AppUtils saveToUserDefault: [NSString stringWithFormat:@"%@", [responseDictionary valueForKey:@"id"]] withKey:USER_ID];
            [AppUtils saveToUserDefault: [NSString stringWithFormat:@"%@", [responseDictionary valueForKey:@"pet_name"]] withKey:PET_NAME];
            [AppUtils saveToUserDefault: @"NO" withKey:DID_REGISTER];

            completion(YES, user, nil, nil);
            
        } else {
            completion(NO, nil, message, error);
        }
    }];
}

-(void)registerBeaconWithParameters:(NSMutableDictionary*)parameters imageData:(NSData*)image withCompletion:(void (^)(BOOL isSuccess, NSString *message, NSError *error))completion {
    
    NSString *uid = [NSString stringWithFormat:@"%@", [AppUtils retrieveFromUserDefaultWithKey:USER_ID]];

    if([parameters objectForKey:@"beacon[pet_image]"]) {
        NSData *image = [parameters objectForKey:@"beacon[pet_image]"];
        [parameters removeObjectForKey:@"beacon[pet_image]"];
        [self uploadFileToAPI:parameters atPath:URL_REGISTER_BEACON(uid) requestType:@"MULTIPART-SIGNUP" imageData:image withCompletion:^(id response, BOOL isSuccess, NSError *error) {
            if (isSuccess) {
                
                NSDictionary *responseDictionary = (NSDictionary*)[response objectForKey:@"data"];
                NSDictionary *petDic = [responseDictionary objectForKey:@"pet_image"];
                NSString *petImage = [NSString stringWithFormat:@"%@",[petDic objectForKey:@"url"]];
                
                Beacon *beacon = [[Beacon new] parseToBeacon:responseDictionary];
                [AppUtils saveToUserDefault:[NSString stringWithFormat:@"%d", beacon.beaconId] withKey:BEACON_ID];
                [AppUtils saveToUserDefault:beacon.beaconUniqueId withKey:BEACON_UNIQUE_ID];
                [AppUtils saveToUserDefault:[NSString stringWithFormat:@"%d", beacon.major] withKey:BEACON_MAJOR];
                [AppUtils saveToUserDefault:[NSString stringWithFormat:@"%d", beacon.minor] withKey:BEACON_MINOR];
                [AppUtils saveToUserDefault:[NSString stringWithFormat:@"%@%@", BASE_URL, petImage] withKey:PET_IMAGE];
                [AppUtils saveToUserDefault: @"YES" withKey:DID_REGISTER];
                
                completion(YES, nil, nil);
            } else {
                completion(NO, nil, error);
            }
        }];
    }  else {
        [self connectWithParameters:parameters atPath:URL_REGISTER_BEACON(uid) requestType:@"POST" withCompletion:^(id response, BOOL isSuccess, NSString *message, NSError *error) {
            if (isSuccess) {
                NSDictionary *responseDictionary = (NSDictionary*)response;
                
                Beacon *beacon = [[Beacon new] parseToBeacon:[responseDictionary objectForKey:@"data"]];
                [AppUtils saveToUserDefault:[NSString stringWithFormat:@"%d", beacon.beaconId] withKey:BEACON_ID];
                [AppUtils saveToUserDefault:beacon.beaconUniqueId withKey:BEACON_UNIQUE_ID];
                [AppUtils saveToUserDefault:[NSString stringWithFormat:@"%d", beacon.major] withKey:BEACON_MAJOR];
                [AppUtils saveToUserDefault:[NSString stringWithFormat:@"%d", beacon.minor] withKey:BEACON_MINOR];
                [AppUtils saveToUserDefault: @"YES" withKey:DID_REGISTER];
                
                
                completion(YES, nil, nil);
                
            } else {
                completion(NO, message, error);
            }
        }];
    }
}

@end
