//
//  AppDelegate.h
//  Campaign Demo
//
//  Created by Vladimir Petrov on 09/09/2014.
//  Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString* AppNotification_UserSignedIn;
extern NSString* AppNotification_UserSignedOut;
extern NSString* AppNotification_ApplicationsLoaded;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
