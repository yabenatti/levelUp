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
    [AppUtils saveToUserDefault:nil withKey:PET_NAME];
    [AppUtils saveToUserDefault:nil withKey:PET_IMAGE];
    [AppUtils saveToUserDefault:nil withKey:DID_REGISTER];
    [AppUtils saveToUserDefault:nil withKey:BEACON_ID];
    [AppUtils saveToUserDefault:nil withKey:BEACON_UNIQUE_ID];
    [AppUtils saveToUserDefault:nil withKey:BEACON_MAJOR];
    [AppUtils saveToUserDefault:nil withKey:BEACON_MINOR];
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

#pragma mark - LoadingView

+(void)startLoadingInView:(UIView*)view {
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    [whiteView setBackgroundColor:COLOR_WHITE];
    whiteView.tag = 11;
    
    UIView *loading = [[UIView alloc]initWithFrame:CGRectMake((view.center.x -65), (view.center.y -65 - 49), 130, 130)]; //49 is tab bar's height
    [loading setBackgroundColor:[UIColor clearColor]];
    loading.layer.cornerRadius = 10.0f;
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [indicator setColor:COLOR_LIGHT_BLUE];
    [indicator setFrame:CGRectMake((loading.frame.size.width/2 - 7.5), (loading.frame.size.height/2 - 7.5), 15, 15)];
    
    [loading addSubview:indicator];
    
    [indicator startAnimating];
    [whiteView addSubview:loading];
    [view addSubview:whiteView];
    [view setUserInteractionEnabled:NO];
}

+(void)stopLoadingInView:(UIView*)view {
    [[view.subviews lastObject] removeFromSuperview];
    [view setUserInteractionEnabled:YES];
}


@end
