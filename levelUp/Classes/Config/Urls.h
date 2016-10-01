//
//  Urls.h
//  MissTess
//
//  Created by Vinícius Lemes on 2016-08-08.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//


#define BASE_URL @"http://192.168.0.140:3000"
#define API @"/api"

#define URL_LOGIN                           BASE_URL API @"/sessions"
#define URL_SIGNUP                          BASE_URL API @"/users"

#define URL_PROFILE(uid)                    [NSString stringWithFormat:@"%@%@/users/uid?uid=%@", BASE_URL, API, uid]
#define URL_ALL_POSTS(uid)                  [NSString stringWithFormat:@"%@%@/posts?uid=%@", BASE_URL, API, uid]
#define URL_MY_POSTS(uid)                   [NSString stringWithFormat:@"%@%@/my_posts?uid=%@", BASE_URL, API, uid]
#define URL_CREATE_POST(uid)                 [NSString stringWithFormat:@"%@%@/posts?uid=%@", BASE_URL, API, uid]



