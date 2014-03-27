#import "MOGAPIClient.h"

@implementation MOGAPIClient

+ (instancetype)sharedClient {
	static MOGAPIClient *_sharedClient = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
	    _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:MOGOAPIBaseURL]];
	});

	return _sharedClient;
}


- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)request
                                                    success:(void (^)(AFHTTPRequestOperation *, id))success
                                                    failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {

    NSMutableURLRequest *mutableRequest = [request mutableCopy];

    if (self.authToken) {
        [mutableRequest addValue:self.authToken forHTTPHeaderField:@"Authorization"];
    }

    return [super HTTPRequestOperationWithRequest:mutableRequest
                                          success:success
                                          failure:failure];
}

@end
