//
//  MOGLoginViewController.h
//  Mogo-iOS
//
//  Created by Jurre Stender on 26/03/14.
//  Copyright (c) 2014 jurre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOGAPIClient.h"

@interface MOGLoginViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITextField *authTokenTextField;;

@property (nonatomic, strong) MOGAPIClient *apiClient;

- (IBAction)signInButtonTapped:(id)sender;

@end
