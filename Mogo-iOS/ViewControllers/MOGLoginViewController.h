//
//  MOGLoginViewController.h
//  Mogo-iOS
//
//  Created by Jurre Stender on 26/03/14.
//  Copyright (c) 2014 jurre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOGAPIClient.h"
#import "MOGSessionService.h"

@interface MOGLoginViewController : UITableViewController

@property (nonatomic, weak) IBOutlet UITextField *baseURLTextField;
@property (nonatomic, weak) IBOutlet UITextField *emailTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic, weak) IBOutlet UIButton *signInButton;

@property (nonatomic, strong) MOGAPIClient *apiClient;
@property (nonatomic, strong) MOGSessionService *sessionService;

- (IBAction)signInButtonTapped:(id)sender;

- (IBAction)textfieldDidChange:(UITextField *)textField;

@end
