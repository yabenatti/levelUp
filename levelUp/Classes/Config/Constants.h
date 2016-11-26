//
//  Constants.h
//  MissTess
//
//  Created by Vinícius Lemes on 2016-08-08.
//  Copyright © 2016 Yasmin Benatti. All rights reserved.
//

//user default

//Type verifications
#define SAFE_STRING(s) ([s isKindOfClass:[NSString class]] ? s : @"")
#define SAFE_BOOL(x) ([x respondsToSelector:@selector(boolValue)] ? [x boolValue] : false)
#define SAFE_FLOAT(x) ([x respondsToSelector:@selector(floatValue)] ? [x floatValue] : 0.0)
#define SAFE_DOUBLE(x) ([x respondsToSelector:@selector(doubleValue)] ? [x doubleValue] : 0.0)
#define SAFE_INTEGER(x) ([x respondsToSelector:@selector(intValue)] ? [x intValue] : 0)
#define SAFE_LONG_LONG(x) ([x respondsToSelector:@selector(longLongValue)] ? [x longLongValue] : 0)

#define USER_ID @"user_id"
#define USER_NAME @"user_name"
#define USER_TOKEN @"authentication_token"
#define PET_NAME @"pet_name"
#define PET_IMAGE @"pet_image"


#define DID_REGISTER @"registration"

#define BEACON_ID @"beacon_id"
#define BEACON_UNIQUE_ID @"beacon_unique_id"
#define BEACON_MAJOR @"beacon_major"
#define BEACON_MINOR @"beacon_minor"

//Cores da tag do perfil
#define COLOR_WHITE_SMOKE [UIColor colorWithRed:246.0/255.0f green:248.0/255.0f blue:249.0/255.0f alpha:1]
#define COLOR_LIGHT_BLUE  [UIColor colorWithRed:118.0/255.0f green:178.0/255.0f blue:239.0/255.0f alpha:1]
#define COLOR_WHITE [UIColor colorWithRed:255.0/255.0f green:255.0/255.0f blue:255.0/255.0f alpha:1]

