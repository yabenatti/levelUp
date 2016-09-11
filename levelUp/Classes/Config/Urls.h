//
//  Urls.h
//  MissTess
//
//  Created by Vinícius Lemes on 2016-08-08.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//


#define BASE_URL @"http://localhost:3000"
#define API @"/api"

#define URL_LOGIN                           BASE_URL API @"/sessions"
#define URL_SIGNUP                          BASE_URL API @"/signup"

#define URL_PROFILE(uid)                    [NSString stringWithFormat:@"%@%@/users?uid=%@", BASE_URL, API, uid]



