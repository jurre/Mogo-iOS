//
//  MOGBaseService.m
//  Mogo-iOS
//
//  Created by Jurre Stender on 06/04/14.
//  Copyright (c) 2014 jurre. All rights reserved.
//

#import "MOGBaseService.h"

@implementation MOGBaseService

+ (instancetype)sharedService {
    [NSException raise:@"Implement in subclass" format:@"This method should be implemented by subclasses only"];
    return nil;
}

@end
