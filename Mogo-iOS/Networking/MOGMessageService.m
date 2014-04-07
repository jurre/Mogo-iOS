//
//  MOGMessageService.m
//  Mogo-iOS
//
//  Created by Jurre Stender on 30/03/14.
//  Copyright (c) 2014 jurre. All rights reserved.
//

#import "MOGMessageService.h"
#import "MOGSessionService.h"

@interface MOGMessageService ()

@property (nonatomic, strong) NSArray *sentMessages;

@end

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

- (NSArray *)messages {
    return [_messages arrayByAddingObjectsFromArray:self.sentMessages];
}

- (NSString *)endpointForRoom:(MOGRoom *)room {
    NSString *roomString = [NSString stringWithFormat:@"%d", room.roomId];
    return [[self.apiClient.baseURLString stringByAppendingPathComponent:MOGApiEndpointMessages] stringByAppendingPathComponent:roomString];
}

- (NSString *)messagesEndpoint {
    return [self.apiClient.baseURLString stringByAppendingPathComponent:MOGApiEndpointMessages];
}

- (void)messagesForRoom:(MOGRoom *)room
             completion:(void (^)(NSArray *result))completion
                failure:(void (^)(NSError *error))failure {
    [self messagesForRoom:room after:0 completion:completion failure:failure];

}

- (void)messagesForRoom:(MOGRoom *)room
                  after:(NSInteger)after
             completion:(void (^)(NSArray *result))completion
                failure:(void (^)(NSError *error))failure {
    NSDictionary *params = nil;
    if (after) { params = @{@"after": [NSNumber numberWithInteger:after] }; }

    [self.apiClient GET:[self endpointForRoom:room]
             parameters:params
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    self.sentMessages = @[];
                    NSArray *messages = [self messagesFromResponse:responseObject];
                    if (after) {
                        self.messages = [self.messages arrayByAddingObjectsFromArray:messages];
                    } else {
                        self.messages = messages;
                    }
                    completion(self.messages);
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    failure(error);
                }];

}


- (NSArray *)messagesFromResponse:(id)responseObject {
    NSArray *rawMessages = responseObject[@"messages"];
    NSMutableArray *messages = [NSMutableArray arrayWithCapacity:[rawMessages count]];
    for (NSDictionary *rawMessage in rawMessages) {
        MOGMessage *message = [self messageFromResponse:rawMessage];
        [messages addObject:message];
    }
    return [NSArray arrayWithArray:messages];
}

- (MOGMessage *)messageFromResponse:(NSDictionary *)responseObject {
    NSDate *date = [self dateFromISO8601String:responseObject[@"created_at"]];
    MOGMessage *message = [[MOGMessage alloc] initWithText:responseObject[@"body"]
                                                    sender:responseObject[@"user"][@"name"]
                                                      date:date];
    message.messageId = [responseObject[@"id"] integerValue];
    message.senderId = [responseObject[@"user_id"] integerValue];
    return message;
}

- (void)postMessage:(MOGMessage *)message
             toRoom:(MOGRoom *)room
         completion:(void (^)(NSArray *messages))completion
            failure:(void (^)(NSError *error))failure {
    NSDictionary *serializedMessage = [self serializedMessage:message forRoom:room];
    [self.apiClient POST:[self messagesEndpoint]
              parameters:serializedMessage
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     MOGMessage *message = [self messageFromResponse:responseObject[@"message"]];
                     message.sender = [MOGSessionService sharedService].currentUser.name;
                     self.sentMessages = [self.sentMessages arrayByAddingObject:message];
                     completion(self.messages);
                 }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     failure(error);
                 }];

}

- (NSDictionary *)serializedMessage:(MOGMessage *)message forRoom:(MOGRoom *)room {
    return @{
                @"message": @{
                     @"room_id": [NSNumber numberWithInteger: room.roomId],
                     @"user_id": [NSNumber numberWithInteger: [MOGSessionService sharedService].currentUser.userId],
                     @"body": message.text,
                     @"type": @"text"
                }
             };
}

- (NSDate *)dateFromISO8601String:(NSString *)dateString {

    NSDate *dateFromString = [[self dateFormatter] dateFromString:dateString];
    return dateFromString;
}

- (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    }
    return dateFormatter;
}

@end
