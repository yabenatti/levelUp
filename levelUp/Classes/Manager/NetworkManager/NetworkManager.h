//
//  NetworkManager.h
//  levelUp
//
//  Created by Vinícius Lemes on 2016-09-10.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "Urls.h"

@interface NetworkManager : NSObject

@property (strong, nonatomic) UIProgressView *progressView;

+(NetworkManager*) sharedInstance;

- (void)connectWithParameters:(NSDictionary*)parameters atPath:(NSString*)path requestType:(NSString*)type withCompletion:(void (^) (id response, BOOL isSuccess, NSString *message, NSError *error))completion;

-(void)uploadFileToAPI:(NSDictionary*)parameters atPath:(NSString*)path requestType:(NSString*)type imageData:(NSData*)image withCompletion:(void (^) (id response, BOOL isSuccess, NSString *message, NSError *error))completion;

@end
