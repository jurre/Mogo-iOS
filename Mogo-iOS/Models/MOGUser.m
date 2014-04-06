//
//  MOGUser.m
//  Mogo-iOS
//
//  Created by Jurre Stender on 06/04/14.
//  Copyright (c) 2014 jurre. All rights reserved.
//

#import "MOGUser.h"

@implementation MOGUser

- (BOOL)isAdmin {
    return [self.role isEqualToString:@"admin"];
}

@end
