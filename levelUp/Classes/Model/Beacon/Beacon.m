//
//  Beacon.m
//  levelUp
//
//  Created by Vinícius Lemes on 2016-09-11.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import "Beacon.h"

@implementation Beacon

- (Beacon *)parseToBeacon:(NSDictionary *)beaconToParse {
    self.beaconId = [[beaconToParse objectForKey:@"id"] intValue];
    self.minor = [[beaconToParse objectForKey:@"minor"] intValue];
    self.major = [[beaconToParse objectForKey:@"major"] intValue];
    self.beaconUniqueId = [beaconToParse objectForKey:@"unique_id"];
    
    return self;
}

@end
