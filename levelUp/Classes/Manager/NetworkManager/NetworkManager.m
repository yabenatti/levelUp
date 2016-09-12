//
//  NetworkManager.m
//  levelUp
//
//  Created by Vinícius Lemes on 2016-09-10.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

#import "NetworkManager.h"
#import "AFNetworkReachabilityManager.h"
#import "AFHTTPSessionManager.h"
#import "JSONResponseSerializerWithData.h"
#import "AppUtils.h"

@implementation NetworkManager

static AFHTTPSessionManager *manager = nil;
static NetworkManager *sharedInstance = nil;

/*!
 * @discussion Configura um singleton do NetworkManager
 * @return instancia do NetworkManager responsável por todas as chamadas a métodos dessa classe.
 */
+ (NetworkManager*)sharedInstance {
    if(sharedInstance == nil) {
        sharedInstance = [[self alloc] init];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        [configuration setTimeoutIntervalForRequest:200.0];
        
        manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
        [manager setResponseSerializer:[JSONResponseSerializerWithData serializer]];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
    }
    return sharedInstance;
}

/*!
 * @discussion Verifica se o usuário está conectado a internet
 */
-(void)checkReachabilityWithCompletion:(void (^) (BOOL isReachable, NSError *error))completion {
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    //Verifica se esta conectado a internet antes de prosseguir
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:nil];
        
        //Sem conexao
        if(status == AFNetworkReachabilityStatusNotReachable) {
            NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
            NSMutableDictionary *messageDict = [[NSMutableDictionary alloc] init];
            [messageDict setValue:NSLocalizedString(@"noConnection", nil) forKey:@"message"];
            [info setValue:@"not.reachable" forKey:NSLocalizedDescriptionKey];
            [info setValue:messageDict forKey:@"JSONResponseSerializerWithDataKey"];
            NSError *error = [[NSError alloc]initWithDomain:@"not.reachable" code:0 userInfo:info];
            
            completion(NO, error);
        } else {
            completion(YES, nil);
        }
    }];
}

/*!
 * @discussion Método que configura uma requisição à API que não possuem upload de arquivos.
 * @param parameters dicionário com os parametros da requisição
 * @param path URL da requisição
 * @param type tipo de requisição
 * @param completion bloco passado para ações com a resposta
 * @return void
 */
- (void)conectWithParameters:(NSDictionary*)parameters atPath:(NSString*)path requestType:(NSString*)type withCompletion:(void (^) (id response, BOOL isSuccess, NSString *message, NSError *error))completion {
    
    [self checkReachabilityWithCompletion:^(BOOL isReachable, NSError *error) {
        if(isReachable) {
            [self callHttpWithParameters:parameters requestType:(NSString*)type atPath:path withCompletion:^(id response, BOOL isSuccess, NSString *message, NSError *error) {
                
                completion(response, isSuccess, message, error);
                
             }];
        } else {
            completion(nil, NO, @"Verifique a sua conexão com a internet", error);
        }
    }];
}

/*!
 * @discussion Método que configura uma requisição à API que possuem upload de arquivos.
 * @param parameters dicionário com os parametros da requisição
 * @param path URL da requisição
 * @param requestType tipo de requisição
 * @param videoURL URL com filepath do video
 * @param imageData imagem a ser submetida no formato NSData
 * @param completion bloco passado para ações com a resposta
 * @return void
 */
-(void)uploadFileToAPI:(NSDictionary*)parameters atPath:(NSString*)path requestType:(NSString*)type imageData:(NSData*)image withCompletion:(void (^) (id response, BOOL isSuccess, NSString *message, NSError *error))completion {
    
    [self checkReachabilityWithCompletion:^(BOOL isReachable, NSError *error) {
        if(isReachable) {
            
            [self uploadImageWithParameters:parameters requestType:type atPath:path imageData:image withCompletion:^(id response, BOOL isSuccess, NSString *message, NSError *error) {
                completion(response, isSuccess, message, error);
            }];
            
        } else {
            completion(nil, NO, @"Verifique a sua conexão com a internet", error);
        }
    }];
}

/*!
 * @discussion Metodo que configura um erro de timeout do servidor
 * @return NSError com todas as informações do erro de timeout
 */
-(NSError*)timeoutError {
    
    NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *messageDict = [[NSMutableDictionary alloc] init];
    [messageDict setValue:@"Tempo da requisição foi esgotado." forKey:@"message"];
    [info setValue:@"timeout" forKey:NSLocalizedDescriptionKey];
    [info setValue:messageDict forKey:@"JSONResponseSerializerWithDataKey"];
    NSError *error = [[NSError alloc]initWithDomain:@"timeout" code:0 userInfo:info];
    
    return error;
}

/*!
 * @discussion Executa a chamada à API sem upload de arquivos
 * @param parameters dicionário com os parametros da requisição
 * @param path URL da requisição
 * @param type tipo de requisição
 * @param completion bloco passado para ações com a resposta
 * @return void
 */
- (void)callHttpWithParameters:(NSDictionary*)parameters requestType:(NSString*)type atPath:(NSString*)path withCompletion:(void (^) (id response, BOOL isSuccess, NSString *message, NSError *error))completion {

    //so inclui o token no header se ele existir
    if([AppUtils retrieveFromUserDefaultWithKey:USER_TOKEN])
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Token %@",[AppUtils retrieveFromUserDefaultWithKey:USER_TOKEN]] forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"%@", path);
    NSLog(@"%@", manager.requestSerializer.HTTPRequestHeaders);
    
    if([type isEqualToString:@"GET"]) {
        
        [manager GET:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@", responseObject);
            completion(responseObject, YES, nil ,nil);

//            if([[[responseObject objectForKey:@"status"] stringValue] isEqualToString:@"0"]) {
//            } else {
//#warning verificar como esta retornando a api - cada endpoint estava de um jeito
//                //NSString *key = [[[responseObject objectForKey:@"messages"] allKeys] firstObject];
//                completion(responseObject, NO, [responseObject objectForKey:@"messages"], nil);
//            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"Erro do server: %@", [[error.userInfo objectForKey:JSONResponseSerializerWithDataKey]objectForKey:@"messages"]);
            
            if([[error.userInfo objectForKey:JSONResponseSerializerWithDataKey]objectForKey:@"messages"]) {
                completion(nil, NO, [[error.userInfo objectForKey:JSONResponseSerializerWithDataKey]objectForKey:@"messages"], error);
            }
            //não conseguiu se comunicar com o servidor
            else {
                if(error != nil) {
                    if (error.code == NSURLErrorTimedOut) {
                        completion(nil, NO, @"Tempo da requisição foi esgotado.", [self timeoutError]);
                    } else {
                        completion(nil, NO, @"Não foi possível se conectar ao servidor, por favor tente novamente" , error);
                    }
                } else {
                    completion(nil, NO, @"Houve uma falha ao se conectar com o servidor, por favor tente novamente", nil);
                }
            }
        }];
        
    } else if([type isEqualToString:@"POST"]) {
        
        [manager POST:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@", responseObject);
            completion(responseObject, YES, nil ,nil);
//            if([[[responseObject objectForKey:@"status"] stringValue] isEqualToString:@"0"]) {
//                completion(responseObject, YES, nil ,nil);
//            } else {
//                if([[responseObject objectForKey:@"messages"] isKindOfClass:[NSArray class]]) {
//                    NSString *key = [[[responseObject objectForKey:@"messages"] allKeys] firstObject];
//                  
//                    NSLog(@"Erro do server: %@",[[[responseObject objectForKey:@"messages"]objectForKey:key] firstObject]);
//                    
//                    completion(responseObject, NO, [[[responseObject objectForKey:@"messages"]objectForKey:key] firstObject], nil);
//                } else {
//                    NSLog(@"Erro do server: %@",[responseObject objectForKey:@"messages"]);
//                     completion(responseObject, NO, [responseObject objectForKey:@"messages"], nil);
//                }
            
            //}
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if([[error.userInfo objectForKey:JSONResponseSerializerWithDataKey]objectForKey:@"messages"]) {
                completion(nil, NO, [[error.userInfo objectForKey:JSONResponseSerializerWithDataKey]objectForKey:@"messages"], error);
            }
            //não conseguiu se comunicar com o servidor
            else {
                if(error != nil) {
                    if (error.code == NSURLErrorTimedOut) {
                        completion(nil, NO, @"Tempo da requisição foi esgotado.", [self timeoutError]);
                    } else {
                        completion(nil, NO, @"Não foi possível se conectar ao servidor, por favor tente novamente" , error);
                    }
                } else {
                    completion(nil, NO, @"Houve uma falha ao se conectar com o servidor, por favor tente novamente", nil);
                }
            }
        }];

    } else if([type isEqualToString:@"DELETE"]) {
        [manager DELETE:path parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            completion(responseObject, YES, nil, nil);
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            completion(nil, NO, nil, error);
        }];
        
    } else if ([type isEqualToString:@"PATCH"]) {
        [manager PATCH:path parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            completion(responseObject, YES, nil, nil);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            completion(nil, NO, nil, error);
        }];
    }
}


/*!
 * @discussion Executa a chamada à API com upload de arquivos de imagem
 * @param parameters dicionário com os parametros da requisição
 * @param requestType tipo de requisição
 * @param path URL da requisição
 * @param imageData imagem a ser submetida no formato NSData
 * @param completion bloco passado para ações com a resposta
 * @return void
 */
- (void)uploadImageWithParameters:(NSDictionary*)parameters requestType:(NSString*)type atPath:(NSString*)path imageData:(NSData*)image withCompletion:(void (^) (id response, BOOL isSuccess, NSString *message, NSError *error))completion {
    
//    if([AppUtils retrieveFromUserDefaultWithKey:API_TOKEN])
//        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Token %@",[AppUtils retrieveFromUserDefaultWithKey:API_TOKEN]] forHTTPHeaderField:@"Authorization"];

    if([type isEqualToString:@"PATCH"]) {
        
        NSMutableURLRequest *request = [manager.requestSerializer multipartFormRequestWithMethod:@"PATCH" URLString:path parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                [formData appendPartWithFileData:image name:@"registration[avatar]" fileName:@"profile.jpg" mimeType:@"image/jpeg"];
        } error:nil];
        
        NSURLSessionUploadTask *task = [manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
            if (error) {
                if([[error.userInfo objectForKey:JSONResponseSerializerWithDataKey]objectForKey:@"messages"]) {
                    completion(nil, NO, [[error.userInfo objectForKey:JSONResponseSerializerWithDataKey]objectForKey:@"messages"], error);
                }
                //não conseguiu se comunicar com o servidor
                else {
                    if(error != nil) {
                        if (error.code == NSURLErrorTimedOut) {
                            completion(nil, NO, @"Tempo da requisição foi esgotado.", [self timeoutError]);
                        } else {
                            completion(nil, NO, @"Não foi possível se conectar ao servidor, por favor tente novamente" , error);
                        }
                    } else {
                        completion(nil, NO, @"Houve uma falha ao se conectar com o servidor, por favor tente novamente", nil);
                    }
                }
                
            } else {
                if([[[responseObject objectForKey:@"status"] stringValue] isEqualToString:@"0"]) {
                    completion(responseObject, YES, nil ,nil);
                } else {
                    NSString *key = [[[responseObject objectForKey:@"messages"] allKeys] firstObject];
                    completion(responseObject, NO, [[[responseObject objectForKey:@"messages"]objectForKey:key] firstObject], nil);
                }
            }
        }];
        
        [task resume];
    }
}

@end
