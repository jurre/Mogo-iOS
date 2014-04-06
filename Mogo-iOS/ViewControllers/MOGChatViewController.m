//
//  MOGChatViewController.m
//  Mogo-iOS
//
//  Created by Jurre Stender on 27/03/14.
//  Copyright (c) 2014 jurre. All rights reserved.
//

#import "MOGChatViewController.h"
#import "MOGMessageService.h"
#import "MOGAvatarFactory.h"
#import "MOGMessage.h"
#import "MOGSessionService.h"
#import "MOGMessagePoller.h"

@interface MOGChatViewController () <MOGMessagePollerDelegate>

@property (nonatomic, strong) NSArray *messages;
@property (nonatomic) MOGMessagePoller *poller;

@end

@implementation MOGChatViewController

- (void)viewDidLoad {
    [self setupChat];
    [super viewDidLoad];
    [self loadMessages];
    [self setupPolling];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.poller stopPolling];
    [super viewWillDisappear:animated];
}

- (void)setupChat {
    self.delegate = self;
    self.dataSource = self;
    self.messageInputView.textView.placeHolder = @"Message...";

    self.sender = [[MOGSessionService sharedService] currentUser].name;
    self.title = self.room.name;
}

- (void)setupPolling {
    self.poller = [[MOGMessagePoller alloc] initWithRoom:self.room];
    self.poller.delegate = self;
    [self.poller startPolling];
}

- (void)loadMessages {
    [[MOGMessageService sharedService] messagesForRoom:self.room
                                            completion:^(NSArray *result) {
                                                self.messages = result;
                                            } failure:^(NSError *error) {
                                                NSLog(@"Error fetching messages: %@", error);
                                            }];
}

- (void)setMessages:(NSArray *)messages {
    _messages = messages;
    [self.tableView reloadData];
    [self scrollToBottomAnimated:NO];
}

#pragma mark JSMessage deletage/datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (id<JSMessageData>)messageForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.messages[indexPath.row];
}

- (UIImageView *)avatarImageViewForRowAtIndexPath:(NSIndexPath *)indexPath sender:(NSString *)sender {
    return nil; // [MOGAvatarFactory avatarForUsername:sender];
}

- (void)didSendText:(NSString *)text fromSender:(NSString *)sender onDate:(NSDate *)date {
    NSLog(@"didSendText: %@ fromSender: %@ onDate: %@", text, sender, date);
    MOGMessage *message = [[MOGMessage alloc] initWithText:text sender:sender date:date];
    message.senderId = [MOGSessionService sharedService].currentUser.userId;
    [[MOGMessageService sharedService] postMessage:message toRoom:self.room completion:^(MOGMessage *message) {
        self.messages = [self.messages arrayByAddingObject:message];
    } failure:^(NSError *error) {
        NSLog(@"Error posting message: %@", error);
    }];
    [self finishSend];
}

- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath {
    MOGMessage *message = self.messages[indexPath.row];
    return message.senderId == [[MOGSessionService sharedService] currentUser].userId ? JSBubbleMessageTypeOutgoing : JSBubbleMessageTypeIncoming;
}

- (UIImageView *)bubbleImageViewWithType:(JSBubbleMessageType)type forRowAtIndexPath:(NSIndexPath *)indexPath {
    MOGMessage *message = self.messages[indexPath.row];
    if (message.senderId == [[MOGSessionService sharedService] currentUser].userId) {
        return [JSBubbleImageViewFactory bubbleImageViewForType:type
                                                          color:[UIColor js_bubbleBlueColor]];
    }
    return [JSBubbleImageViewFactory bubbleImageViewForType:type
                                                      color:[UIColor js_bubbleLightGrayColor]];
}

- (JSMessageInputViewStyle)inputViewStyle {
    return JSMessageInputViewStyleFlat;
}

#pragma mark - MOGMessagePollerDelegate

- (void)pollerDidFetchNewMessages:(NSArray *)newMessages {
    self.messages = [self.messages arrayByAddingObjectsFromArray:newMessages];
}

@end
