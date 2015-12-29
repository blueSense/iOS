//
//  AppDelegate.m
//  Campaign Demo
//
//  Created by Vladimir Petrov on 09/09/2014.
//  Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import "AppDelegate.h"
#import "ProximitySenseSDK.h"
#import "ApiConnector.h"


NSString* AppNotification_UserSignedIn = @"AppNotification_UserSignedIn";
NSString* AppNotification_UserSignedOut = @"AppNotification_UserSignedOut";
NSString* AppNotification_ApplicationsLoaded = @"AppNotification_ApplicationsLoaded";


@implementation NSURLRequest(DataController)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
    return YES;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:30];

    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    application.applicationIconBadgeNumber = 0;
    
    [ProximitySenseSDK Api].baseUrl = @"http://dev-api.proximitysense.com/v1/";
   [[ApiConnector instance] registerNotifications];

    return YES;
}

- (void) application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"Starting background fetch");
    
    [[ProximitySenseSDK Ranging] lookAroundFor:20 completion:completionHandler];
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

