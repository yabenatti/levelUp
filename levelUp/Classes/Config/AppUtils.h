//
//  AppUtils.h
//  levelUp
//
//  Created by Vinícius Lemes on 2016-08-08.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constants.h"

@interface AppUtils : NSObject

+ (void) saveToUserDefault:(NSObject*) objectToSave withKey:(NSString*) key;
+ (NSObject*) retrieveFromUserDefaultWithKey:(NSString*) key;
+(void) clearUserDefault;
+(UIAlertController*)setupAlertWithMessage:(NSString*)message;

+(void)setupImageWithUrl:(NSString *)imageUrl andPlaceholder:(NSString *)placeholder andImageView:(UIImageView *)imageView;
+ (NSString *)formatDate:(NSString *)date;

+(void)startLoadingInView:(UIView*)view;
+(void)stopLoadingInView:(UIView*)view;

@end
