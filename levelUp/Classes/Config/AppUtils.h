//
//  AppUtils.h
//  levelUp
//
//  Created by Vinícius Lemes on 2016-08-08.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface AppUtils : NSObject

+ (void) saveToUserDefault:(NSObject*) objectToSave withKey:(NSString*) key;
+ (NSObject*) retrieveFromUserDefaultWithKey:(NSString*) key;
+(void) clearUserDefault;

@end
