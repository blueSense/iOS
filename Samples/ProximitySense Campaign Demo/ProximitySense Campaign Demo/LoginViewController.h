//
//  LoginViewController.h
//  Campaign Demo
//
//  Created by Vladimir Petrov on 23/01/2015.
//  Copyright (c) 2015 Blue Sense Networks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProximitySenseSDK.h"

@interface LoginViewController : UIViewController < UITextViewDelegate, ApiOperationsDelegate >

@property ( strong, nonatomic ) IBOutlet UITextField *emailAddress;
@property ( strong, nonatomic ) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)signIn:(id)sender;

@end
