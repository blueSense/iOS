//
//  BlueBarSDK.h
//  BlueBarSDK
//
//  Created by Vladimir Petrov on 16/05/2014.
//  Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeaconConfiguration.h"
#import "DetectedBeacon.h"
#import "ApiOperations.h"
#import "ApiCredentials.h"
#import "AppUser.h"
#import "RangingManager.h"
#import "BeaconConfigurationService.h"
#import "BeaconDiscovery.h"
#import "BeaconCalibration.h"
#import "ActionBase.h"
#import "RichContentAction.h"

@class BeaconCalibration;
@class BeaconDiscovery;
@class ApiOperations;
@class ApiCredentials;
@class RangingManager;

#define BLUEBARSDK_VERSION @"0.5"

@protocol BlueBarSDKStatusDelegate <NSObject>

@optional
- (void) userMessage:(NSString*)message;
@end

@interface BlueBarSDK : NSObject

+ (BeaconCalibration *) Calibration;
+ (BeaconDiscovery *) Discovery;
+ (ApiOperations*) Api;
+ (RangingManager*) Ranging;

+ (id<BlueBarSDKStatusDelegate>) SetStatusDelegate:(id<BlueBarSDKStatusDelegate>)statusDelegate;
+ (id<BlueBarSDKStatusDelegate>) StatusDelegate;

+ (void) InitializeWithUsername:(NSString *)username andPassword: (NSString *)password;
+ (void) InitializeWithApplicationId:(NSString *)applicationId andPrivateKey: (NSString *)appPrivateKey;
+ (void) InitializeWithCredentials:(ApiCredentials*)apiCredentials;
@end
