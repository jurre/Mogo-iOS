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

@interface MOGChatViewController ()

@property (nonatomic, strong) NSArray *messages;

@end

@implementation MOGChatViewController

- (void)viewDidLoad {
    [self setupChat];
    [super viewDidLoad];
    [self loadMessages];
}

- (void)setupChat {
    self.delegate = self;
    self.dataSource = self;
    self.messageInputView.textView.placeHolder = @"Message...";

    self.sender = [[MOGSessionService sharedService] currentUser].name;
    self.title = self.room.name;
}

- (void)loadMessages {
    [[MOGMessageService sharedService] messagesForRoom:self.room
                                            completion:^(NSArray *result) {
                                                self.messages = result;
                                                [self.tableView reloadData];
                                                [self scrollToBottomAnimated:NO];
                                            } failure:^(NSError *error) {
                                                NSLog(@"Error fetching messages: %@", error);
                                            }];
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

@end
