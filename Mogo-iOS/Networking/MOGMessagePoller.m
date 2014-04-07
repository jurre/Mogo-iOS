//
//  MOGMessagePoller.m
//  Mogo-iOS
//
//  Created by Jurre Stender on 06/04/14.
//  Copyright (c) 2014 jurre. All rights reserved.
//

#import "MOGMessagePoller.h"
#import "MOGMessageService.h"

static const CGFloat MOGMessagePollingInterval = 2.5f;

@interface MOGMessagePoller()

@property (nonatomic, strong) MOGRoom *room;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) MOGMessageService *messageService;
@property (nonatomic) NSInteger lastPolledMessage;

@end

@implementation MOGMessagePoller

- (instancetype)initWithRoom:(MOGRoom *)room {
    self = [super init];
    if (self) {
        _messageService = [MOGMessageService sharedService];
        _room = room;
    }
    return self;
}

- (void)startPolling {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:MOGMessagePollingInterval
                                                  target:self
                                                selector:@selector(timerFired:)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)stopPolling {
    [self.timer invalidate];
    self.timer = nil;
    self.lastPolledMessage = 0;
}

- (void)timerFired:(NSTimer *)timer {
    [self.messageService messagesForRoom:self.room after:self.lastPolledMessage completion:^(NSArray *result) {
        if (result.count > 0) {
            NSArray *messages = self.messageService.messages;
            self.lastPolledMessage = [[messages lastObject] messageId];
            [self.delegate pollerDidFetchNewMessages:messages];
        }
    } failure:^(NSError *error) {
        NSLog(@"Error polling for messages: %@", error);
    }];
}

@end
