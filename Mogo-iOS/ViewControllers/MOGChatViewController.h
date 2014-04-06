//
//  MOGChatViewController.h
//  Mogo-iOS
//
//  Created by Jurre Stender on 27/03/14.
//  Copyright (c) 2014 jurre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSMessagesViewController.h"
#import "MOGRoom.h"
#import "MOGSessionService.h"
#import "MOGMessageService.h"

@interface MOGChatViewController : JSMessagesViewController <JSMessagesViewDataSource, JSMessagesViewDelegate>

@property (nonatomic, retain) MOGRoom *room;
@property (nonatomic) MOGSessionService *sessionService;
@property (nonatomic) MOGMessageService *messageService;

@end
