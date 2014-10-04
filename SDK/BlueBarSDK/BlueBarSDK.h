//
//  BlueBarSDK.h
//  BlueBarSDK
//
//  Created by Vladimir Petrov on 16/05/2014.
//  Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model/BeaconConfiguration.h"
#import "Model/DetectedBeacon.h"
#import "Model/ApiOperations.h"
#import "Model/ApiCredentials.h"
#import "Model/ApiSession.h"
#import "Model/RangingManager.h"
#import "LE/BeaconConfigurationService.h"
#import "LE/BeaconDiscovery.h"

@class BeaconDiscovery;
@class ApiOperations;
@class ApiCredentials;
@class RangingManager;


@protocol BlueBarSDKStatusDelegate <NSObject>

@optional
- (void) userMessage:(NSString*)message;
@end

@interface BlueBarSDK : NSObject

+ (BeaconDiscovery *) Discovery;
+ (ApiOperations*) Api;
+ (RangingManager*) Ranging;

+ (id<BlueBarSDKStatusDelegate>) SetStatusDelegate:(id<BlueBarSDKStatusDelegate>)statusDelegate;
+ (id<BlueBarSDKStatusDelegate>) StatusDelegate;

+ (void) InitializeWithUsername:(NSString *)username andPassword: (NSString *)password;
+ (void) InitializeWithApplicationId:(NSString *)applicationId andPrivateKey: (NSString *)appPrivateKey;
+ (void) InitializeWithCredentials:(ApiCredentials*)apiCredentials;
@end
