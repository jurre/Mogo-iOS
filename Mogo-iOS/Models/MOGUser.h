//
//  MOGUser.h
//  Mogo-iOS
//
//  Created by Jurre Stender on 06/04/14.
//  Copyright (c) 2014 jurre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOGUser : NSObject

@property NSInteger userId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *authToken;
@property (nonatomic, copy) NSString *role;

@end
