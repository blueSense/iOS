//
//  ApiOperations.h
//  BlueBar Service App
//
//  Created by Vladimir Petrov on 22/02/2014.
//  Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetectedBeacon.h"
#import "ApiCredentials.h"
#import "RestKit.h"
#import "RKHTTPRequestOperation.h"

@protocol ApiOperationsDelegate <NSObject>
@optional
    - (void) authenticated;
    - (void) authenticationFailed:(NSString*)reason;

    - (void) retrievedBeaconConfiguration:(BeaconConfiguration*)beaconConfiguration forBeacon:(DetectedBeacon*)beacon;
    - (void) failedToRetrieveBeaconConfigurationForBeacon:(DetectedBeacon *)beacon withError:(NSError*)error;

@end


@interface ApiOperations : NSObject

    + (id) instance;
    + (NSString*)computeSHA256DigestForString:(NSString*)input;

    @property (nonatomic, assign) id<ApiOperationsDelegate> apiDelegate;
    @property (nonatomic, strong) ApiCredentials *credentials;

    - (void) requestAuthKeyPairForUser:(NSString*)username withPassword:(NSString*)password;
    - (void) requestBeaconDetails:(DetectedBeacon*)beacon;
    - (void) updateBeaconDetails:(DetectedBeacon*)beacon;

@end
