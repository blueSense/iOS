//
//  LoginViewController.m
//  Campaign Demo
//
//  Created by Vladimir Petrov on 23/01/2015.
//  Copyright (c) 2015 Blue Sense Networks. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "BlueBarSDK.h"

#import <MBProgressHUD.h>

@interface LoginViewController () < UITextFieldDelegate, ApiOperationsDelegate >
{
}
@end

@implementation LoginViewController
{
    @private
    MBProgressHUD *hud;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *loginEmail = [defaults objectForKey:@"login-email"];
    NSString *loginPassword = [defaults objectForKey:@"login-password"];
    
    self.emailAddress.delegate = self;
    self.emailAddress.text = loginEmail;
    
    self.password.delegate = self;
    self.password.text = loginPassword;
    
    [[BlueBarSDK Api] setApiDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder *nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder)
    {
        [nextResponder becomeFirstResponder];
        if ([nextResponder isKindOfClass:[UIButton class]])
        {
            [self signIn:self];
            
            return NO;
        }
    }
    else
    {
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (IBAction)signIn:(id)sender
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Authenticating...";

    NSString *username = self.emailAddress.text;
    NSString *password = self.password.text;
    
    [[BlueBarSDK Api] requestAuthKeyPairForUser:username withPassword:password];
}

- (void) authenticationDone
{
    [hud hide:YES];

    NSString *email = self.emailAddress.text;
    NSString *password = self.password.text;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:email forKey:@"login-email"];
    [defaults setObject:password forKey:@"login-password"];
    [defaults synchronize];
    
    [self performSegueWithIdentifier:@"authenticated" sender:self];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AppNotification_UserSignedIn object:[BlueBarSDK Api].credentials];
}

- (void)authenticationFailed:(NSString *)reason
{
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"Login failed, please try again.";
    [hud hide:YES afterDelay:3];

    self.password.text = @"";
    [self.emailAddress becomeFirstResponder];
}

@end
