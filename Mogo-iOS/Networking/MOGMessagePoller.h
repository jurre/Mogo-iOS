//
//  MOGMessagePoller.h
//  Mogo-iOS
//
//  Created by Jurre Stender on 06/04/14.
//  Copyright (c) 2014 jurre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOGRoom.h"

@protocol MOGMessagePollerDelegate <NSObject>

@required
- (void)pollerDidFetchNewMessages:(NSArray *)newMessages;

@end

@interface MOGMessagePoller : NSObject

@property (nonatomic, weak) id<MOGMessagePollerDelegate> delegate;

- (instancetype)initWithRoom:(MOGRoom *)room;

- (void)startPolling;
- (void)stopPolling;

@end
