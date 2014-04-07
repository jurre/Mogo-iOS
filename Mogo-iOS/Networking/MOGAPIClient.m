#import "MOGAPIClient.h"

@interface MOGAPIClient ()

@property (nonatomic, strong) NSURL *apiBaseURL;

@end

@implementation MOGAPIClient

+ (instancetype)sharedClient {
	static MOGAPIClient *_sharedClient = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
	    _sharedClient = [[self alloc] init];
	});

	return _sharedClient;
}

- (NSURL *)baseURL {
    return self.apiBaseURL;
}

- (void)setBaseURL:(NSString *)url {
    NSString *URLString = [url stringByAppendingPathComponent:@"api"];
    _apiBaseURL = [NSURL URLWithString:URLString];
}

- (NSString *)baseURLString {
    return [self.apiBaseURL absoluteString];
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
