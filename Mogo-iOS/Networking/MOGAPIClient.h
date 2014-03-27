#import "AFHTTPRequestOperationManager.h"

static NSString *const MOGOAPIBaseURL = @"http://floating-oasis-2485.herokuapp.com/api/";

@interface MOGAPIClient : AFHTTPRequestOperationManager

@property (nonatomic, strong) NSString *authToken;

+ (MOGAPIClient *)sharedClient;

@end
