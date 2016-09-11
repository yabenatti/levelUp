//
//  JSONResponseSerializerWithData.m
//
//  Created by Vinícius Lemes on 2016-09-10.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import "JSONResponseSerializerWithData.h"

@implementation JSONResponseSerializerWithData

- (id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing *)error {
    
    id JSONObject = [super responseObjectForResponse:response data:data error:error];
   
    if (*error != nil) {
        NSMutableDictionary *userInfo = [(*error).userInfo mutableCopy];
        
        if (data == nil) {
            // NOTE: You might want to convert data to a string here too, up to you.
            // userInfo[JSONResponseSerializerWithDataKey] = @"";
            userInfo[JSONResponseSerializerWithDataKey] = [NSData data];
        } else {
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSData *responseData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
            if(responseDict != nil){
                //faz uma verificacao do tipo de mensagem que veio no erro e ajusta para o app
                if([responseDict objectForKey:@"message"]) {
                    userInfo[JSONResponseSerializerWithDataKey] = responseDict;
                } else {
                    userInfo[JSONResponseSerializerWithDataKey] = [responseDict mutableCopy];
                    [userInfo[JSONResponseSerializerWithDataKey] setObject:NSLocalizedString(@"genericError", nil) forKey:@"message"];
                }
                
                
            }
        }
        NSError *newError = [NSError errorWithDomain:(*error).domain code:(*error).code userInfo:userInfo];
        
        (*error) = newError;
    }
    return (JSONObject);
}

@end
