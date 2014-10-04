//
//  ApiOperations.h
//  BlueBar Service App
//
//  Created by Vladimir Petrov on 22/02/2014.
//  Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DetectedBeacon;
@class BeaconConfiguration;
@class ApiCredentials;
@class ApiSession;

@protocol ApiOperationsDelegate <NSObject>
@optional
    - (void) authenticated;
    - (void) authenticationFailed:(NSString*)reason;

    - (void) retrievedBeaconConfiguration:(BeaconConfiguration*)beaconConfiguration forBeacon:(DetectedBeacon*)beacon;
    - (void) failedToRetrieveBeaconConfigurationForBeacon:(DetectedBeacon *)beacon withError:(NSError*)error;
@end

extern NSString *ApiNotification_ActionReceived;

@interface ApiOperations : NSObject

    + (id) instance;

    @property (nonatomic, assign) id<ApiOperationsDelegate> apiDelegate;

    @property (nonatomic, strong) ApiCredentials *credentials;
    @property (nonatomic, strong) ApiSession *session;
    @property (nonatomic, copy) NSString *baseUrl;

    - (void) requestAuthKeyPairForUser:(NSString*)username withPassword:(NSString*)password;
    - (void) requestBeaconDetails:(DetectedBeacon*)beacon;
    - (void) updateBeaconDetails:(DetectedBeacon*)beacon;

    - (void) reportBeaconSightings:(NSArray *)beacons;
@end
