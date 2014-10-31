//
//  AppDelegate.m
//  Campaign Demo
//
//  Created by Vladimir Petrov on 09/09/2014.
//  Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import "AppDelegate.h"
#import "BlueBarSDK.h"


@implementation NSURLRequest(DataController)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
    return YES;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    application.applicationIconBadgeNumber = 0;

    // In order to be able to access the ProximitySense platform via the API (and the SDK)
    // you need to create an application first. To do that, sign in to ProximitySense and go to
    // API Access/Applications submenu. Use the screen to create an application.
    // Copy the ApplicationId and the PrivateKey fields into the appropriate variables below:
    
    NSString *applicationId = @"PUT APPLICATION ID HERE";
    NSString *privateKey = @"PUT PRIVATE KEY HERE";
    
    [BlueBarSDK InitializeWithApplicationId:applicationId andPrivateKey:privateKey];

    //appSpecificId is a string value that represents the app's user identity.
    //Can be email, LinkedIn profile id, twitter handle, UUID etc, in short anything that you use to identify your users.
    //This value is used in the analytics panel to detect different users and to remember who has proximity activations
    [BlueBarSDK Api].session.appSpecificId = [[NSUUID alloc]init].UUIDString;
    
    //userMetadata is an additional NSDictionary of values, to assign to the specific appUserId. For example, it can contain fields such as
    // name, last name, email, profile photo url, in short anything you wish to display in the user analytics panel
    // Those fields can be used subsequently to create sophisticated usage reports and custom proximity actions
    NSArray *keys = [NSArray arrayWithObjects:@"first_name", @"last_name", @"email", nil];
    NSArray *objs = [NSArray arrayWithObjects:@"John", @"Doe", @"john_doe@somewhere.com", nil];
    [BlueBarSDK Api].session.userMetadata = [NSDictionary dictionaryWithObjects:objs forKeys:keys];

    // Factory Default Blue Sense Networks BlueBar Beacon UUID
    [[BlueBarSDK Ranging] startForUuid:@"A0B13730-3A9A-11E3-AA6E-0800200C9A66"];

    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    // Set icon badge number to zero
    application.applicationIconBadgeNumber = 0;
}

@end

