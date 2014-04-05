//
//  MOGRoomsTableViewController.m
//  Mogo-iOS
//
//  Created by Jurre Stender on 27/03/14.
//  Copyright (c) 2014 jurre. All rights reserved.
//

#import "MOGRoomsTableViewController.h"
#import "MOGRoom.h"
#import "MOGChatViewController.h"

static NSString *MOGRoomCellIdentifier = @"MOGRoomCell";
static NSString *MOGSegueIdentifierOpenRoom = @"MOGSegueIdentifierOpenRoom";

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

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.roomService roomsWithCompletion:^(NSArray *result) {
        self.rooms = result;
        [self.tableView reloadData];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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

#pragma mark -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:MOGSegueIdentifierOpenRoom]) {
        ((MOGChatViewController *)segue.destinationViewController).room = self.rooms[[self.tableView indexPathForSelectedRow].row];
    }
}

@end
