//
//  ApiConnector.m
//  Trails
//
//  Created by Vladimir Petrov on 13/12/2014.
//  Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import "ApiConnector.h"
#import "AppDelegate.h"

#import "ProximitySenseSDK.h"
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
    
    [[ProximitySenseSDK Ranging] stop];
}

- (void)userSignedIn: (NSNotification*)notification
{
    serviceCredentials = ((NSNotification *)notification).object;

    [self configureSdkWithApplicationId:serviceCredentials.applicationId andPrivateKey:serviceCredentials.privateKey];
}

- (void) configureSdkWithApplicationId:(NSString *)applicationId andPrivateKey: (NSString *)privateKey
{
//    [ProximitySenseSDK Api].baseUrl = @"http://dev-api.proximitysense.com/v1/";
//    [ProximitySenseSDK Api].baseUrl = @"http://localapi.proximitysense.com/v1/";
    [ProximitySenseSDK Api].baseUrl = @"http://localapi.proximitysense.com/v1/";
    
    [ProximitySenseSDK InitializeWithApplicationId:applicationId andPrivateKey:privateKey];

    [[ProximitySenseSDK Api] requestProfile:^(UserProfile* profile, NSError* error)
     {
         [ProximitySenseSDK Api].appUser.appSpecificId = profile.entityId;
         [ProximitySenseSDK Api].appUser.userMetadata = [NSDictionary dictionaryWithObjectsAndKeys:
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
    [[ProximitySenseSDK Ranging] stop];
    
    [[ProximitySenseSDK Api] requestApplications:^(NSArray* apps, NSError* error)
     {
         self.applications = apps;
         [[NSNotificationCenter defaultCenter] postNotificationName:AppNotification_ApplicationsLoaded object:nil];
     } withCredentials:serviceCredentials];
}

- (void) startForApp:(Application*)app
{
    [ProximitySenseSDK InitializeWithApplicationId:app.clientId andPrivateKey:app.privateKey];
    
    [[ProximitySenseSDK Ranging] startForUuid:@"A0B13730-3A9A-11E3-AA6E-0800200C9A66"];
/*
    GetPublicationsRequest* request = [[GetPublicationsRequest alloc] init];
    request.tags = @[@"IT"];
    
    [[[ProximitySenseSDK Extensions] ContentManagement] getPublications: ^(NSArray * publications, NSError* error)
    {
        NSLog(@"Publications: (%d) %@", (int) publications.count, publications);
    } withQuery:request];
    
    SendMessageRequest* messageRequest = [[SendMessageRequest alloc] init];
    messageRequest.message = @"Assistance needed!";
    [[[ProximitySenseSDK Extensions] AudienceMonitor] sendMessage:messageRequest];
*/
}

@end

