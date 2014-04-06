//
//  MOGRoomService.h
//  Mogo-iOS
//
//  Created by Jurre Stender on 26/03/14.
//  Copyright (c) 2014 jurre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOGBaseService.h"

static NSString *const MOGApiEndpointRooms = @"rooms";

@interface MOGRoomService : MOGBaseService

- (void)roomsWithCompletion:(void (^)(NSArray *result))completion failure:(void (^)(NSError *error))failure;

@end
