//
//  MOGRoomsTableViewController.h
//  Mogo-iOS
//
//  Created by Jurre Stender on 27/03/14.
//  Copyright (c) 2014 jurre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOGRoomService.h"

@interface MOGRoomsTableViewController : UITableViewController

@property (nonatomic, strong) MOGRoomService *roomService;

@end
