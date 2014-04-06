//
//  MOGLoginViewController.m
//  Mogo-iOS
//
//  Created by Jurre Stender on 26/03/14.
//  Copyright (c) 2014 jurre. All rights reserved.
//

#import "MOGLoginViewController.h"

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
	NSString *authToken = @"";
	self.apiClient.authToken = authToken;
	[self performSegueWithIdentifier:MOGSegueIdentifierSignIn sender:self];
}


- (IBAction)textfieldDidChange:(UITextField *)textField {
    BOOL emailEntered = self.emailTextField.text && self.emailTextField.text.length > 0;
    BOOL passwordEntered = self.passwordTextField.text && self.passwordTextField.text.length > 0;
    self.signInButton.enabled = emailEntered && passwordEntered;
}

@end
