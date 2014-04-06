//
//  MOGLoginViewController.m
//  Mogo-iOS
//
//  Created by Jurre Stender on 26/03/14.
//  Copyright (c) 2014 jurre. All rights reserved.
//

#import "MOGLoginViewController.h"
#import "MOGSessionService.h"

static NSString *const MOGSegueIdentifierSignIn = @"MOGSignInSegue";

@implementation MOGLoginViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super initWithCoder:aDecoder])) {
		_apiClient = [MOGAPIClient sharedClient];
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.signInButton.enabled = false;
}

- (IBAction)signInButtonTapped:(id)sender {
    self.signInButton.enabled = false;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString *email = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    [[MOGSessionService sharedService] signInWithEmail:email password:password completion:^(MOGUser *user) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        self.emailTextField.text = @"";
        self.passwordTextField.text = @"";
        self.apiClient.authToken = user.authToken;
        [self performSegueWithIdentifier:MOGSegueIdentifierSignIn sender:self];
    } failure:^(NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"Failed signing in: %@", error);
        self.signInButton.enabled = true;
    }];
}


- (IBAction)textfieldDidChange:(UITextField *)textField {
    BOOL emailEntered = self.emailTextField.text && self.emailTextField.text.length > 0;
    BOOL passwordEntered = self.passwordTextField.text && self.passwordTextField.text.length > 0;
    self.signInButton.enabled = emailEntered && passwordEntered;
}

@end
