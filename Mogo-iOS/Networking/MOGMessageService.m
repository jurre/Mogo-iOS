//
//  MOGMessageService.m
//  Mogo-iOS
//
//  Created by Jurre Stender on 30/03/14.
//  Copyright (c) 2014 jurre. All rights reserved.
//

#import "MOGMessageService.h"
#import "MOGMessage.h"
#import "TTTDateTransformers.h"

@implementation MOGMessageService

+ (instancetype)sharedService {
	static MOGMessageService *_sharedService = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
	    _sharedService = [[self alloc] init];
	    _sharedService.apiClient = [MOGAPIClient sharedClient];
	});
	return _sharedService;
}

- (NSString *)endpointForRoom:(MOGRoom *)room {
    return [NSString stringWithFormat:@"%@%@%ld", MOGOAPIBaseURL, MOGApiEndpointMessages, (long)room.roomId];
}

- (void)messagesForRoom:(MOGRoom *)room
             completion:(void (^)(NSArray *result))completion
                failure:(void (^)(NSError *error))failure {
    [self.apiClient GET:[self endpointForRoom:room]
             parameters:nil
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    completion([self messagesFromResponse:responseObject]);
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    failure(error);
                }];
}


- (NSArray *)messagesFromResponse:(id)responseObject {
    NSArray *rawMessages = responseObject[@"messages"];
    NSMutableArray *messages = [NSMutableArray arrayWithCapacity:[rawMessages count]];
    for (NSDictionary *rawMessage in rawMessages) {
        NSDate *date = (NSDate *)[[NSValueTransformer valueTransformerForName:TTTISO8601DateTransformerName] transformedValue:rawMessage[@"created_at"]];
        MOGMessage *message = [[MOGMessage alloc] initWithText:rawMessage[@"body"]
                                                        sender:rawMessage[@"user"][@"name"]
                                                          date:date];
        [messages addObject:message];
    }
    return [NSArray arrayWithArray:messages];
}

@end
