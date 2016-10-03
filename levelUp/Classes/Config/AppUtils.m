//
//  AppUtils.m
//  levelUp
//
//  Created by Vinícius Lemes on 2016-08-08.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import "AppUtils.h"
#import "Constants.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation AppUtils

#pragma mark - UserDefaults

+ (void) saveToUserDefault:(NSObject*) objectToSave withKey:(NSString*) key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:objectToSave forKey:key];
    [userDefaults synchronize];
}

+ (NSObject*) retrieveFromUserDefaultWithKey:(NSString*) key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+(void) clearUserDefault {
    [AppUtils saveToUserDefault:nil withKey:USER_ID];
    [AppUtils saveToUserDefault:nil withKey:USER_NAME];
    [AppUtils saveToUserDefault:nil withKey:USER_TOKEN];
}

+ (void)setupAlertWithMessage {
    
}

+(UIAlertController*)setupAlertWithMessage:(NSString*)message {
    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"Attention" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [myAlertController dismissViewControllerAnimated:YES completion:nil];
    }];
    [myAlertController addAction: ok];
    
    return myAlertController;
}


@end
