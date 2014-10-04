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
    // In order to be able to access the ProximitySense platform via the API (and the SDK)
    // you need to create an application first. To do that, sign in to ProximitySense and go to
    // API Access/Applications submenu. Use the screen to create an application.
    // Copy the ApplicationId and the PrivateKey fields into the appropriate variables below:
    
    NSString *applicationId = @"PUT APPLICATION ID HERE";
    NSString *privateKey = @"PUT PRIVATE KEY HERE";
    
    [BlueBarSDK InitializeWithApplicationId:applicationId andPrivateKey:privateKey];

    // Setup current app user's session
    // the appSpecificId property can contain a random string, or a Twitter handle, Facebook user id etc
    // It is used to differentiate physical users of your app. Currently set to a random user Id
    [BlueBarSDK Api].session = [[ApiSession alloc] init];
    [BlueBarSDK Api].session.appSpecificId = [[NSUUID alloc] init].UUIDString;

    // Start the SDK. Here we use the Factory Default Blue Sense Networks BlueBar Beacon UUID
    // The SDK will handle all iBeacon monitoring and ranging for you, as well as make the necessary ProximitySense API calls
    // Don't forget to add a notification hanlder for API calback notifications.
    // There is a sample implementation inside the ActionsTableViewController
    [[BlueBarSDK Ranging] startForUuid:@"A0B13730-3A9A-11E3-AA6E-0800200C9A66"];

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

@end

