//
//  MOGSessionService.m
//  Mogo-iOS
//
//  Created by Jurre Stender on 06/04/14.
//  Copyright (c) 2014 jurre. All rights reserved.
//

#import "MOGSessionService.h"

static NSString *const MOGUserDefaultsBaseURL = @"MOGUserDefaultsBaseURL";
static NSString *const MOGUserDefaultsEmailAddress = @"MOGUserDefaultsEmailAddress";

@implementation MOGSessionService

+ (instancetype)sharedService {
	static MOGSessionService *_sharedService = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
	    _sharedService = [[self alloc] init];
	    _sharedService.apiClient = [MOGAPIClient sharedClient];
	});
	return _sharedService;
}

- (NSString *)endpoint {
    return [self.apiClient.baseURLString stringByAppendingPathComponent:MOGAPIEndPointSession];
}

- (void)signInWithEmail:(NSString *)email
               password:(NSString *)password
             completion:(void (^)(MOGUser *user))completion
                failure:(void (^)(NSError *error))failure {
    NSDictionary *params = @{@"email": email, @"password": password};
    [self.apiClient POST:[self endpoint]
              parameters:params
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     MOGUser *user = [self userFromResponse:responseObject];
                     self.currentUser = user;
                     completion(user);
                 }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     failure(error);
                 }];
}

- (MOGUser *)userFromResponse:(NSDictionary *)responseObject {
    MOGUser *user = [[MOGUser alloc] init];
    responseObject = responseObject[@"user"];
    user.userId = [responseObject[@"id"] integerValue];
    user.name = responseObject[@"name"];
    user.email = responseObject[@"email"];
    user.authToken = responseObject[@"auth_token"];
    user.role = responseObject[@"role"];
    return user;
}

#pragma mark - User Defaults / Keychain

- (void)setBaseURL:(NSString *)baseURL {
    [[NSUserDefaults standardUserDefaults] setValue:baseURL forKey:MOGUserDefaultsBaseURL];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)baseURL {
    return [[NSUserDefaults standardUserDefaults] valueForKey:MOGUserDefaultsBaseURL];
}

- (void)setEmailAddress:(NSString *)emailAddress {
    [[NSUserDefaults standardUserDefaults] setValue:emailAddress forKey:MOGUserDefaultsEmailAddress];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)emailAddress {
    return [[NSUserDefaults standardUserDefaults] valueForKey:MOGUserDefaultsEmailAddress];
}


@end
