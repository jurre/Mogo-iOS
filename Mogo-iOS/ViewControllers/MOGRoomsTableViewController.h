//
//  MOGRoomsTableViewController.h
//  Mogo-iOS
//
//  Created by Jurre Stender on 27/03/14.
//  Copyright (c) 2014 jurre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOGRoomService.h"
#import "MOGRoom.h"
#import "MOGSessionService.h"

@interface MOGRoomsTableViewController : UITableViewController

@property (nonatomic, weak) IBOutlet UIBarButtonItem *addRoomButton;

@property (nonatomic, strong) MOGRoomService *roomService;
@property (nonatomic, strong) MOGSessionService *sessionService;

@end
