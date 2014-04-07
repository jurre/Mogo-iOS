//
//  MOGLoginViewController.m
//  Mogo-iOS
//
//  Created by Jurre Stender on 26/03/14.
//  Copyright (c) 2014 jurre. All rights reserved.
//

#import "MOGLoginViewController.h"
#import "CRToast.h"

static NSString *const MOGSegueIdentifierSignIn = @"MOGSignInSegue";

@implementation MOGLoginViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super initWithCoder:aDecoder])) {
		_apiClient = [MOGAPIClient sharedClient];
        _sessionService = [MOGSessionService sharedService];
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.signInButton.enabled = false;
    self.baseURLTextField.text = self.sessionService.baseURL;
}

- (IBAction)signInButtonTapped:(id)sender {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self setSignInFieldsEnabled:NO];

    void (^completion)() = ^{
        [self setSignInFieldsEnabled:YES];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    };

    NSString *baseURL = self.baseURLTextField.text;
    self.sessionService.baseURL = baseURL;
    self.apiClient.baseURL = baseURL;

    NSString *email = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    [self.sessionService signInWithEmail:email password:password completion:^(MOGUser *user) {
        self.emailTextField.text = @"";
        self.passwordTextField.text = @"";

        self.apiClient.authToken = user.authToken;
        completion();
        [self performSegueWithIdentifier:MOGSegueIdentifierSignIn sender:self];
    } failure:^(NSError *error) {
        completion();

        [CRToastManager showNotificationWithMessage:@"You done goofed. Try again." completionBlock:nil];
        NSLog(@"Failed signing in: %@", error);

    }];
}

- (void)setSignInFieldsEnabled:(BOOL)enabled {
    self.emailTextField.enabled = enabled;
    self.passwordTextField.enabled = enabled;
    self.signInButton.enabled = enabled;
}


- (IBAction)textfieldDidChange:(UITextField *)textField {
    BOOL baseURLEntered = [self textFieldIsSet:self.baseURLTextField];
    BOOL emailEntered = [self textFieldIsSet:self.emailTextField];
    BOOL passwordEntered = [self textFieldIsSet:self.passwordTextField];
    self.signInButton.enabled = baseURLEntered && emailEntered && passwordEntered;
}

- (BOOL)textFieldIsSet:(UITextField *)textField {
    return textField.text && textField.text.length > 0;
}

@end
