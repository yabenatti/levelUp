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
    
    NSLog(@"Save %@ for key %@", objectToSave, key);
}

+ (NSObject*) retrieveFromUserDefaultWithKey:(NSString*) key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+(void) clearUserDefault {
    [AppUtils saveToUserDefault:nil withKey:USER_ID];
    [AppUtils saveToUserDefault:nil withKey:USER_NAME];
    [AppUtils saveToUserDefault:nil withKey:USER_TOKEN];
}

#pragma mark - Image

+(void)setupImageWithUrl:(NSString *)imageUrl andPlaceholder:(NSString *)placeholder andImageView:(UIImageView *)imageView {
    //Recovers imagem from an URL
    if(imageUrl != nil) {
        __weak UIImageView *weakImageView = imageView;
        
        NSURL *url = [NSURL URLWithString: imageUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        [weakImageView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:placeholder] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            [weakImageView setContentMode:UIViewContentModeScaleAspectFill];
            weakImageView.image = image;
            weakImageView.layer.masksToBounds = YES;
            
        }failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
    }
}

+(UIAlertController*)setupAlertWithMessage:(NSString*)message {
    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"Attention" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [myAlertController dismissViewControllerAnimated:YES completion:nil];
    }];
    [myAlertController addAction: ok];
    
    return myAlertController;
}

+ (NSString *)formatDate:(NSString *)date {
    
    NSString *year = [date substringWithRange:NSMakeRange(0, 4)];
    NSString *month = [date substringWithRange:NSMakeRange(5, 2)];
    NSString *day = [date substringWithRange:NSMakeRange(8, 2)];
    
    return [NSString stringWithFormat:@"%@/%@/%@", month, day, year];
    
}


@end
