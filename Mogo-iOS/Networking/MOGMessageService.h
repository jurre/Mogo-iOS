//
//  MOGMessageService.h
//  Mogo-iOS
//
//  Created by Jurre Stender on 30/03/14.
//  Copyright (c) 2014 jurre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOGBaseService.h"
#import "MOGRoom.h"

static NSString *const MOGApiEndpointMessages = @"messages/";

@interface MOGMessageService : MOGBaseService

- (void)messagesForRoom:(MOGRoom *)room
             completion:(void (^)(NSArray *result))completion
                failure:(void (^)(NSError *error))failure;

@end
