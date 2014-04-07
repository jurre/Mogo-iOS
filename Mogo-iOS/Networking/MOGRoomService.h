//
//  MOGRoomService.h
//  Mogo-iOS
//
//  Created by Jurre Stender on 26/03/14.
//  Copyright (c) 2014 jurre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOGBaseService.h"
#import "MOGRoom.h"

static NSString *const MOGApiEndpointRooms = @"rooms";

@interface MOGRoomService : MOGBaseService

@property (nonatomic, strong) NSArray *rooms;

- (void)roomsWithCompletion:(void (^)(NSArray *result))completion failure:(void (^)(NSError *error))failure;

- (void)createRoomWithName:(NSString *)name
                completion:(void (^)(MOGRoom *room))completion
                   failure:(void (^)(NSError *error))failure;

- (void)deleteRoom:(MOGRoom *)room
        completion:(void (^)(void))completion
           failure:(void (^)(NSError *error))failure;

@end
