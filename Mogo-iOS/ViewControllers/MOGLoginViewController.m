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

- (IBAction)signInButtonTapped:(id)sender {
	NSString *authToken = self.authTokenTextField.text;
	self.apiClient.authToken = authToken;
	[self performSegueWithIdentifier:MOGSegueIdentifierSignIn sender:self];
}

@end
