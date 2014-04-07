//
//  MOGChatViewController.m
//  Mogo-iOS
//
//  Created by Jurre Stender on 27/03/14.
//  Copyright (c) 2014 jurre. All rights reserved.
//

#import "MOGChatViewController.h"
#import "MOGMessage.h"
#import "MOGMessagePoller.h"

@interface MOGChatViewController () <MOGMessagePollerDelegate>

@property (nonatomic, strong) NSArray *messages;
@property (nonatomic) MOGMessagePoller *poller;

@end

@implementation MOGChatViewController

- (void)viewDidLoad {
    [self setupChat];
    [super viewDidLoad];
    [self setupServices];
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

    self.sender = [self.sessionService currentUser].name;
    self.title = self.room.name;
}

- (void)setupPolling {
    self.poller = [[MOGMessagePoller alloc] initWithRoom:self.room];
    self.poller.delegate = self;
    [self.poller startPolling];
}

- (void)setupServices {
    self.sessionService = [MOGSessionService sharedService];
    self.messageService = [MOGMessageService sharedService];
}

- (void)loadMessages {
    [self.messageService messagesForRoom:self.room
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

#pragma mark -

- (MOGUser *)currentUser {
    return self.sessionService.currentUser;
}

#pragma mark - JSMessage deletage/datasource

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
    MOGMessage *message = [[MOGMessage alloc] initWithText:text sender:sender date:date];
    message.senderId = self.currentUser.userId;

    [self.messageService postMessage:message
                              toRoom:self.room
                          completion:^(NSArray *messages) {
                              self.messages = messages;
                          } failure:^(NSError *error) {
                              NSLog(@"Error posting message: %@", error);
                          }];
    
    [self.messageInputView.textView.undoManager removeAllActions];
    [self finishSend];
}

- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath {
    MOGMessage *message = self.messages[indexPath.row];
    return message.senderId == self.currentUser.userId ? JSBubbleMessageTypeOutgoing : JSBubbleMessageTypeIncoming;
}

- (UIImageView *)bubbleImageViewWithType:(JSBubbleMessageType)type forRowAtIndexPath:(NSIndexPath *)indexPath {
    MOGMessage *message = self.messages[indexPath.row];
    if (message.senderId == self.currentUser.userId) {
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
    self.messages = newMessages;
}

@end
