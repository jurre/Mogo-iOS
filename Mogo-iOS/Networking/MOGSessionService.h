//
//  MOGSessionService.h
//  Mogo-iOS
//
//  Created by Jurre Stender on 06/04/14.
//  Copyright (c) 2014 jurre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOGBaseService.h"
#import "MOGUser.h"

static NSString *const MOGAPIEndPointSession = @"sessions";

@interface MOGSessionService : MOGBaseService

@property (nonatomic, strong) MOGUser *currentUser;

- (void)signInWithEmail:(NSString *)email
               password:(NSString *)password
             completion:(void (^)(MOGUser *user))completion
                failure:(void (^)(NSError *error))failure;

@end
