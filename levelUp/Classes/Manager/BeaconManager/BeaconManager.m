//
//  BeaconManager.m
//  levelUp
//
//  Created by Yasmin Ringa on 26/11/16.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import "BeaconManager.h"
#import "AppUtils.h"
#import "Urls.h"

@implementation BeaconManager

static BeaconManager *sharedInstance = nil;

/*!
 * @discussion Configura um singleton do BeaconManager
 * @return instância do BeaconManager responsável por todas as chamadas a métodos desse manager.
 */
+(BeaconManager*)sharedInstance {
    if(sharedInstance == nil) {
        sharedInstance = [[self alloc] init];
        [super sharedInstance];
    }
    return sharedInstance;
}

/*!
 * @discussion Recovers user's beacons
 * @param null.
 * @param completion bloco que executa ações com a resposta do server
 * @return void
 */
- (void)getUserBeaconsWithCompletion:(void(^)(BOOL isSuccess, Beacon *beacon, NSString *message, NSError *error)) completion {
    
    NSString *uid = [NSString stringWithFormat:@"%@", [AppUtils retrieveFromUserDefaultWithKey:USER_ID]];

    [self connectWithParameters:nil atPath:URL_BEACON(uid) requestType:@"GET" withCompletion:^(id response, BOOL isSuccess, NSString *message, NSError *error) {
        if(isSuccess) {
            NSDictionary *beaconDictionary = (NSDictionary *)[response objectForKey:@"data"];

            Beacon *beacon = [Beacon new];
            beacon = [beacon parseToBeacon:beaconDictionary];
            
            completion(YES, beacon, nil,nil);
            
        } else {
            completion(NO, nil, message, error);
        }
    }];
}

-(void)updateBeaconWithParameters:(NSMutableDictionary*)parameters imageData:(NSData*)image withCompletion:(void (^)(BOOL isSuccess, NSString *message, NSError *error))completion {
    
    NSString *uid = [NSString stringWithFormat:@"%@", [AppUtils retrieveFromUserDefaultWithKey:USER_ID]];
    
    if([parameters objectForKey:@"beacon[pet_image]"]) {
        NSData *image = [parameters objectForKey:@"beacon[pet_image]"];
        [parameters removeObjectForKey:@"beacon[pet_image]"];
        [self uploadFileToAPI:parameters atPath:URL_REGISTER_BEACON(uid) requestType:@"MULTIPART-UPDATE_BEACON" imageData:image withCompletion:^(id response, BOOL isSuccess, NSError *error) {
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
