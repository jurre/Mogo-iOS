//
//  MOGRoomService.m
//  Mogo-iOS
//
//  Created by Jurre Stender on 26/03/14.
//  Copyright (c) 2014 jurre. All rights reserved.
//

#import "MOGRoomService.h"
#import "MOGRoom.h"

@implementation MOGRoomService

+ (instancetype)sharedService {
	static MOGRoomService *_sharedService = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
	    _sharedService = [[self alloc] init];
	    _sharedService.apiClient = [MOGAPIClient sharedClient];
	});
	return _sharedService;
}

- (NSString *)endpoint {
    return [NSString stringWithFormat:@"%@%@", MOGOAPIBaseURL, MOGApiEndpointRooms];
}

- (void)roomsWithCompletion:(void (^)(NSArray *result))completion failure:(void (^)(NSError *error))failure {
    [self.apiClient GET:[self endpoint]
             parameters:nil
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSArray *result = [self roomsFromResponse:responseObject];
                    completion(result);
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    failure(error);
                }];
}

- (NSArray *)roomsFromResponse:(id)responseObject {
    NSArray *jsonArray = responseObject[@"rooms"];
    NSMutableArray *rooms = [NSMutableArray arrayWithCapacity:[jsonArray count]];
    for (NSDictionary *jsonRoom in jsonArray) {
        MOGRoom *room = [[MOGRoom alloc] init];
        room.name = jsonRoom[@"name"];
        room.roomId = [jsonRoom[@"id"] integerValue];
        [rooms addObject:room];
    }
    return [NSArray arrayWithArray:rooms];
}

@end
