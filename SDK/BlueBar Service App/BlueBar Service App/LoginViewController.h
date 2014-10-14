//
//  LoginViewController.h
//  BlueBar Service App
//
//  Created by Vladimir Petrov on 05/02/2014.
//  Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController < UITextViewDelegate >

@property ( strong, nonatomic ) IBOutlet UITextField *emailAddress;
@property ( strong, nonatomic ) IBOutlet UITextField *password;

- (IBAction)signIn:(id)sender;

- (IBAction)buyBeacons:(UIButton *)sender;

- (IBAction)contactUs:(UIButton *)sender;

@end
