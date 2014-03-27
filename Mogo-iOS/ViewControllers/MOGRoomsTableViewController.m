//
//  MOGRoomsTableViewController.m
//  Mogo-iOS
//
//  Created by Jurre Stender on 27/03/14.
//  Copyright (c) 2014 jurre. All rights reserved.
//

#import "MOGRoomsTableViewController.h"
#import "MOGRoom.h"


static NSString *MOGRoomCellIdentifier = @"MOGRoomCell";

@interface MOGRoomsTableViewController()

@property (nonatomic, strong) NSArray *rooms;

@end

@implementation MOGRoomsTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
	self = [super initWithStyle:style];
	if (self) {
        [self setup];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _roomService = [MOGRoomService sharedService];
}

- (void)viewDidLoad {
	[super viewDidLoad];

    [self.roomService roomsWithCompletion:^(NSArray *result) {
        self.rooms = result;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        //
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.rooms count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MOGRoomCellIdentifier forIndexPath:indexPath];
    MOGRoom *room = self.rooms[indexPath.row];
    cell.textLabel.text = room.name;

    return cell;
}

@end
