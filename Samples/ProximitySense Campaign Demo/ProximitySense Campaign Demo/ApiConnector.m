//
//  ApiConnector.m
//  Trails
//
//  Created by Vladimir Petrov on 13/12/2014.
//  Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import "ApiConnector.h"
#import "AppDelegate.h"

#import "BlueBarSDK.h"
#import "ApiOperations.h"
#import "ActionBase.h"
#import "Application.h"
#import "UserProfile.h"

@implementation ApiConnector
{
@private
    NSMutableArray * _discoveredLocationsArray;
    ApiCredentials* serviceCredentials;
}

+ (ApiConnector*) instance
{
    static ApiConnector *this = nil;
    
    if (!this)
    {
        this = [[ApiConnector alloc] init];
    }
    
    return this;
}

- (void) registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userSignedIn:) name:AppNotification_UserSignedIn object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userSignedOut:) name:AppNotification_UserSignedOut object:nil];
}

- (void)userSignedOut: (NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:ApiNotification_ActionReceived];
    
    [[BlueBarSDK Ranging] stop];
}

- (void)userSignedIn: (NSNotification*)notification
{
    serviceCredentials = ((NSNotification *)notification).object;

    [self configureSdkWithApplicationId:serviceCredentials.applicationId andPrivateKey:serviceCredentials.privateKey];
}

- (void) configureSdkWithApplicationId:(NSString *)applicationId andPrivateKey: (NSString *)privateKey
{
    [BlueBarSDK InitializeWithApplicationId:applicationId andPrivateKey:privateKey];

    [[BlueBarSDK Api] requestProfile:^(UserProfile* profile, NSError* error)
     {
         [BlueBarSDK Api].appUser.appSpecificId = profile.entityId;
         [BlueBarSDK Api].appUser.userMetadata = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  profile.entityId ?: [NSNull null], @"id",
                                                  profile.screenName ?: [NSNull null], @"screenName",
                                                  profile.profileImageUrl ?: [NSNull null], @"profileImageUrl",
                                                  profile.email ?: [NSNull null], @"email",
                                                  profile.address ?: [NSNull null], @"address",
                                                  profile.country ?: [NSNull null], @"country",
                                                  profile.phone ?: [NSNull null], @"phone",
                                                  profile.company ?: [NSNull null], @"company",
                                                  profile.website ?: [NSNull null], @"website",
                                                  nil];

     } withCredentials:serviceCredentials];
}

-(void)loadApplications
{
    [[BlueBarSDK Ranging] stop];
    
    [[BlueBarSDK Api] requestApplications:^(NSArray* apps, NSError* error)
     {
         self.applications = apps;
         [[NSNotificationCenter defaultCenter] postNotificationName:AppNotification_ApplicationsLoaded object:nil];
     } withCredentials:serviceCredentials];
}

- (void) startForApp:(Application*)app
{
    [BlueBarSDK InitializeWithApplicationId:app.clientId andPrivateKey:app.privateKey];
    
    [[BlueBarSDK Ranging] startForUuid:@"A0B13730-3A9A-11E3-AA6E-0800200C9A66"];
}

@end

