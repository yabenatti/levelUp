//
//  Beacon.h
//  levelUp
//
//  Created by Vinícius Lemes on 2016-09-11.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Beacon : NSObject

@property (nonatomic) int beaconId;
@property (nonatomic) int minor;
@property (nonatomic) int major;

- (void)parseToBeacon:(NSDictionary *)beaconToParse;

@end
