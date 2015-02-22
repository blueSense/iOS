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
@class AppUser;
@class UserProfile;

@protocol ApiOperationsDelegate <NSObject>
@optional
    - (void) authenticationDone;
    - (void) authenticationFailed:(NSString*)reason;

    - (void) beaconUpdateDone:(DetectedBeacon*)beacon;
    - (void) beaconUpdateFailed:(NSString*)reason forBeacon:(DetectedBeacon*)beacon;

    - (void) beaconRegistrationDone:(DetectedBeacon*)beacon;
    - (void) beaconRegistrationFailed:(NSString*)reason forBeacon:(DetectedBeacon*)beacon;

    - (void) retrievedBeaconConfiguration:(BeaconConfiguration*)beaconConfiguration forBeacon:(DetectedBeacon*)beacon;
    - (void) failedToRetrieveBeaconConfigurationForBeacon:(DetectedBeacon *)beacon withError:(NSError*)error;
@end

extern NSString *ApiNotification_ActionReceived;

@interface ApiOperations : NSObject

    + (id) instance;

    @property (nonatomic, assign) id<ApiOperationsDelegate> apiDelegate;

    @property (nonatomic, strong) ApiCredentials *credentials;
    @property (nonatomic, strong) AppUser *appUser;
    @property (nonatomic, copy) NSString *baseUrl;

    - (void) requestAuthKeyPairForUser:(NSString*)username withPassword:(NSString*)password;
    - (void) requestBeaconDetails:(DetectedBeacon*)beacon;
    - (void) updateBeaconDetails:(DetectedBeacon*)beacon;
    - (void) registerBeacon:(DetectedBeacon*)beacon;

    - (void) reportBeaconSightings:(NSArray *)beacons;
    - (void) pollForAvailableActionResults;

    - (void) requestForEndpoint: (NSString*)endpoint withResultObject:(id)resultObject onCompletion:(void (^)(id result, NSError* connectionError)) handler ;
    - (void) requestForEndpoint: (NSString*)endpoint withResultObject:(id)resultObject onCompletion:(void (^)(id result, NSError* connectionError)) handler withCredentials: (ApiCredentials*)credentials;

    - (void) requestForEndpoint: (NSString*)endpoint withObject:(NSObject*)object withResultObject:(id)resultObject onCompletion:(void (^)(id result, NSError* connectionError)) handler;
    - (void) requestForEndpoint: (NSString*)endpoint withObject:(NSObject*)object withResultObject:(id)resultObject onCompletion:(void (^)(id result, NSError* connectionError)) handler withCredentials: (ApiCredentials*)credentials;

    - (void) requestApplications: (void (^)(NSArray* applications, NSError* connectionError)) onCompletion;
    - (void) requestApplications: (void (^)(NSArray* applications, NSError* connectionError)) onCompletion withCredentials: (ApiCredentials*)credentials;

    - (void) requestProfile: (void (^)(UserProfile* userProfile, NSError* connectionError)) onCompletion;
    - (void) requestProfile: (void (^)(UserProfile* userProfile, NSError* connectionError)) onCompletion withCredentials: (ApiCredentials*)credentials;

    - (void) updateAppUser: (AppUser*)appUser;
    - (void) updateAppUser: (AppUser*)appUser withCredentials: (ApiCredentials*)credentials;
@end
