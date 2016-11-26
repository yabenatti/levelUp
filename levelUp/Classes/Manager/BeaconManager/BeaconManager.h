//
//  BeaconManager.h
//  levelUp
//
//  Created by Yasmin Ringa on 26/11/16.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import "NetworkManager.h"
#import "Beacon.h"

@interface BeaconManager : NetworkManager

+(BeaconManager*)sharedInstance;

- (void)getUserBeaconsWithCompletion:(void(^)(BOOL isSuccess, Beacon *beacon, NSString *message, NSError *error)) completion;
-(void)updateBeaconWithParameters:(NSMutableDictionary*)parameters imageData:(NSData*)image withCompletion:(void (^)(BOOL isSuccess, NSString *message, NSError *error))completion;

@end
