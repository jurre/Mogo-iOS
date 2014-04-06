//
//  MOGBaseService.h
//  Mogo-iOS
//
//  Created by Jurre Stender on 06/04/14.
//  Copyright (c) 2014 jurre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOGAPIClient.h"

@interface MOGBaseService : NSObject

@property (nonatomic, strong) MOGAPIClient *apiClient;

+ (instancetype)sharedService;

@end
