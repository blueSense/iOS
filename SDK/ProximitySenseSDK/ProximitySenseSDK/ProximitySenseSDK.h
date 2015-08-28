//
//  BlueBarSDK.h
//  BlueBarSDK
//
//  Created by Vladimir Petrov on 16/07/2015.
//  Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiOperations.h"
#import "ApiCredentials.h"
#import "AppUser.h"
#import "RangingManager.h"
#import "ActionBase.h"
#import "RichContentAction.h"
#import "Integrations.h"

@class ApiOperations;
@class ApiCredentials;
@class RangingManager;

#define PROXIMITYSENSESDK_VERSION @"1.1.0"

@interface ProximitySenseSDK : NSObject

+ (ApiOperations*) Api;
+ (RangingManager*) Ranging;

+ (Integrations*) Integrations;

+ (void) InitializeWithApplicationId:(NSString *)applicationId andPrivateKey: (NSString *)appPrivateKey;
+ (void) InitializeWithCredentials:(ApiCredentials*)apiCredentials;
@end
