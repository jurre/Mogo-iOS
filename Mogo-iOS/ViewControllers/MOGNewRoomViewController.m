//
//  MOGNewRoomViewController.m
//  Mogo-iOS
//
//  Created by Jurre Stender on 06/04/14.
//  Copyright (c) 2014 jurre. All rights reserved.
//

#import "MOGNewRoomViewController.h"
#import "MOGRoomService.h"
#import "MOGRoomsTableViewController.h"

@interface MOGNewRoomViewController ()

@property (nonatomic, weak) IBOutlet UIButton *saveButton;
@property (nonatomic, weak) IBOutlet UIButton *cancelButton;
@property (nonatomic, weak) IBOutlet UITextField *roomNameTextField;

@end

@implementation MOGNewRoomViewController

- (void)viewDidLoad {
    self.saveButton.enabled = false;
}

- (IBAction)cancelButtonTapped:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)textfieldDidChange:(UITextField *)textField {
    BOOL roomNameEntered = self.roomNameTextField.text && self.roomNameTextField.text.length > 0;
    self.saveButton.enabled = roomNameEntered;
}

- (IBAction)saveButtonTapped:(UIButton *)sender {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString *roomName = self.roomNameTextField.text;
    [self setInputsEnabled:NO];
    [[MOGRoomService sharedService] createRoomWithName:roomName completion:^(MOGRoom *room) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        [self setInputsEnabled:YES];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } failure:^(NSError *error) {
        NSLog(@"Failed saving room: %@", error);
        [self setInputsEnabled:YES];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

- (void)setInputsEnabled:(BOOL)enabled {
    self.roomNameTextField.enabled = enabled;
    self.saveButton.enabled = enabled;
    self.cancelButton.enabled = enabled;
}

@end
