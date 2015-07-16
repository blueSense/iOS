//
//  ApiOperations.m
//  BlueBar Service App
//
//  Created by Vladimir Petrov on 22/02/2014.
//  Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import "ProximitySenseSDK.h"

#import "ApiOperations.h"
#import "ApiCredentials.h"
#import "AppUser.h"
#import "Sighting.h"
#import "NSObject+BSN_GFJson.h"
#import "ApiUtility.h"
#import "NSArray+Transform.h"
#import "RangingManager.h"
#import "ActionBase.h"
#import "ActionResponse.h"
#import "Integrations.h"
#import "Application.h"
#import "UserProfile.h"


NSString *ApiNotification_ActionReceived = @"ProximitySenseSDK_ApiNotification_ActionReceived";



NSString* HttpHeader_Authorization_ClientId = @"X-Authorization-ClientId";
NSString* HttpHeader_Authorization_Signature = @"X-Authorization-Signature";
NSString* HttpHeader_ProximitySense_SdkPlatformAndVersion = @"X-ProximitySense-SdkPlatformAndVersion";
NSString* HttpHeader_ProximitySense_AppUserId = @"X-ProximitySense-AppUserId";


@interface AppUserUpdateRequest : NSObject

@property (nonatomic, copy) NSDictionary *userMetadata;

@end

@implementation AppUserUpdateRequest
@end

@interface ApiCredentialsRequest : NSObject

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;

@end

@implementation ApiCredentialsRequest
@end

@interface UpdateBeaconRequest : NSObject

    @property BOOL initialSetupDone;
    @property BOOL isEnabled;

    @property (nonatomic, copy) NSString *uuid;
    @property (nonatomic, copy) NSNumber *major;
    @property (nonatomic, copy) NSNumber *minor;
    @property (nonatomic, copy) NSNumber *advertisementInterval;
    @property (nonatomic, copy) NSNumber *signalStrength;
    @property (nonatomic, copy) NSNumber *powerCalibration;
    @property (nonatomic, copy) NSNumber *batteryLevel;
@end;

@implementation UpdateBeaconRequest
@end

@interface ApiOperations () <NSObject>
@end


@implementation ApiOperations
{
    @private
    NSString* sdkPlatformAndVersion;
}

@synthesize apiDelegate;

+ (id) instance
{
	static ApiOperations *this = nil;
    
	if (!this)
		this = [[ApiOperations alloc] init];
    
	return this;
}


- (id) init
{
    self = [super init];
    if (self)
    {
        self.baseUrl = @"https://platform.proximitysense.com/api/v1/";
        self.appUser = [[AppUser alloc] init];
        
        sdkPlatformAndVersion = [NSString stringWithFormat:@"%@ %@ - %@", [UIDevice currentDevice].systemName, [UIDevice currentDevice].systemVersion, PROXIMITYSENSESDK_VERSION];
        
        [ActionBase registerCommonActionTypes];
        [Integrations registerCommonActionTypes];
    }
    
    return self;
}

- (void) setCommonHeaders:(NSMutableURLRequest*) request
{
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:sdkPlatformAndVersion forHTTPHeaderField:HttpHeader_ProximitySense_SdkPlatformAndVersion];
}

- (NSMutableURLRequest*) prepareGetRequest:(NSString*)url
{
    return [self prepareGetRequest: url withCredentials:self.credentials];
}

- (NSMutableURLRequest*) prepareGetRequest:(NSString*)url withCredentials:(ApiCredentials*)credentials
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];

    NSString* signature = [ApiUtility computeSHA256DigestForString:[NSString stringWithFormat:@"%@%@", url, credentials.privateKey]];

    [self setCommonHeaders:request];
    [request setValue:credentials.applicationId forHTTPHeaderField:HttpHeader_Authorization_ClientId];
    [request setValue:signature forHTTPHeaderField:HttpHeader_Authorization_Signature];

    return request;
}

- (NSMutableURLRequest*) preparePostRequest:(NSString*)url withData:(NSData*)jsonData
{
    return [self preparePostRequest:url withData:jsonData withCredentials:self.credentials];
}

- (NSMutableURLRequest*) preparePostRequest:(NSString*)url withData:(NSData*)jsonData withCredentials:(ApiCredentials*)credentials
{
    NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:jsonData];

    NSString* signature = [ApiUtility computeSHA256DigestForString:[NSString stringWithFormat:@"%@%@%@", url, jsonString, credentials.privateKey]];

    [self setCommonHeaders: request];
    [request setValue:credentials.applicationId forHTTPHeaderField:HttpHeader_Authorization_ClientId];
    [request setValue:signature forHTTPHeaderField:HttpHeader_Authorization_Signature];

    return request;
}

- (void) requestAuthKeyPairForUser:(NSString*)username withPassword:(NSString*)password
{
    ApiCredentialsRequest *apiRequest = [ApiCredentialsRequest new];
    apiRequest.username = username;
    apiRequest.password = password;

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:apiRequest.jsonObject options:NSJSONWritingPrettyPrinted error:nil];
    NSString * url =[NSString stringWithFormat:@"%@%@", self.baseUrl,  @"auth"];

    NSMutableURLRequest *request = [self preparePostRequest:url withData:jsonData];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
                           {
                               if (connectionError || [ApiUtility isResponseFailed:response])
                               {
                                   NSString* errorDescription = [self logError: connectionError withData:data];

                                   if (self.apiDelegate && [self.apiDelegate respondsToSelector:@selector(authenticationFailed:)])
                                   {
                                       [self.apiDelegate authenticationFailed:errorDescription];
                                   }
                                   return;
                               }

                               NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                               id responseBody = [[ApiCredentials alloc] initWithJsonObject:json];

                               if ([responseBody isKindOfClass:[ApiCredentials class]])
                               {
                                   self.credentials = responseBody;
                                   self.credentials.applicationId = self.credentials.clientId;

                                   if (self.apiDelegate && [self.apiDelegate respondsToSelector:@selector(authenticationDone)])
                                   {
                                       [self.apiDelegate authenticationDone];
                                   }
                               }
                           }];

 }

- (NSString*) logError:(NSError*)connectionError withData:(NSData*) data
{
    int errorCode = 0;
    NSString* errorDescription = @"";
    
    if (connectionError){
        errorCode = (int)connectionError.code;
        errorDescription = [errorDescription stringByAppendingString:connectionError.localizedDescription];
    }
    
    if (data)
    {
        errorDescription = [errorDescription stringByAppendingString:[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]];
    }
    
    NSLog(@"Response error: (%d) %@", (int) errorCode, errorDescription);
    
    return errorDescription;

}

- (void)processTriggerResults:(NSData*)data
{
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if (json == nil)
        return;
    
    id responseBody = [[ActionResponse alloc] initWithJsonObject:json];
    
    NSArray *actions = responseBody;
    
    if (actions.count > 0)
    {
        for (ActionResponse *actionResponse in actions)
        {
            id actionResult = [ActionBase parseActionResponse:actionResponse];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:ApiNotification_ActionReceived object:actionResult];
        }
    }
}

- (void)reportBeaconSightings:(NSArray *)beacons
{
    NSArray* sightings = [beacons transformWithBlock:^id(id o) {
        return [[Sighting alloc]initWithBeacon:(CLBeacon *)o];
    }];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:sightings.jsonObject options:0 error:nil];
    NSString * url =[NSString stringWithFormat:@"%@%@", self.baseUrl,  @"ranging"];
    
    NSMutableURLRequest *request = [self preparePostRequest:url withData:jsonData];
    [request setValue:self.appUser.appSpecificId forHTTPHeaderField:HttpHeader_ProximitySense_AppUserId];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         if (connectionError || [ApiUtility isResponseFailed:response])
         {
             [self logError: connectionError withData:data];
             return;
         }
     }];
}

- (void) pollForAvailableActionResults
{
    NSString * url =[NSString stringWithFormat:@"%@%@", self.baseUrl,  @"decision"];
    
    NSMutableURLRequest *request = [self prepareGetRequest:url];
    [request setValue:self.appUser.appSpecificId forHTTPHeaderField:@"X-ProximitySense-AppUserId"];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         if (connectionError || [ApiUtility isResponseFailed:response])
         {
             [self logError: connectionError withData:data];
             return;
         }
         
         [self processTriggerResults:data];
     }];
}

- (void) requestForEndpoint: (NSString*)endpoint withResultObject:(id)resultObject onCompletion:(void (^)(id result, NSError* connectionError)) handler
{
    [self requestForEndpoint:endpoint withResultObject:resultObject onCompletion:handler withCredentials:self.credentials];
}

- (void) requestForEndpoint: (NSString*)endpoint withResultObject:(id)resultObject onCompletion:(void (^)(id result, NSError* connectionError)) handler  withCredentials: (ApiCredentials*)credentials
{
    NSString * url =[NSString stringWithFormat:@"%@%@", self.baseUrl,  endpoint];
    
    NSMutableURLRequest *request = [self prepareGetRequest:url withCredentials:credentials];
    [request setValue:self.appUser.appSpecificId forHTTPHeaderField:HttpHeader_ProximitySense_AppUserId];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         if (connectionError || [ApiUtility isResponseFailed:response])
         {
             [self logError: connectionError withData:data];

             if (handler != nil)
                 handler(nil, connectionError);
             
             return;
         }
         
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
         if (json == nil)
         {
             if (handler != nil)
                 handler(nil, connectionError);
             return;
         }
         
         if (resultObject)
         {
             id responseObject = [resultObject initWithJsonObject:json];
             if (handler != nil)
                 handler(responseObject, connectionError);
         }
     }];
}

- (void) requestForEndpoint: (NSString*)endpoint withObject:(NSObject*)object withResultObject:(id)resultObject onCompletion:(void (^)(id result, NSError* connectionError)) handler
{
    [self requestForEndpoint:endpoint withObject:object withResultObject:resultObject onCompletion:handler withCredentials:self.credentials];
}

- (void) requestForEndpoint: (NSString*)endpoint withObject:(NSObject*)object withResultObject:(id)resultObject onCompletion:(void (^)(id result, NSError* connectionError)) handler withCredentials: (ApiCredentials*)credentials
{
    
    NSString * url =[NSString stringWithFormat:@"%@%@", self.baseUrl,  endpoint];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object.jsonObject options:0 error:nil];
    NSMutableURLRequest *request = [self preparePostRequest:url withData:jsonData withCredentials:credentials];
    [request setValue:self.appUser.appSpecificId forHTTPHeaderField:HttpHeader_ProximitySense_AppUserId];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         if (connectionError || [ApiUtility isResponseFailed:response])
         {
             [self logError: connectionError withData:data];

             if (handler != nil)
                 handler(nil, connectionError);
             
             return;
         }
         
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
         if (json == nil)
         {
             if (handler != nil)
                 handler(nil, connectionError);
             return;
         }
         
         if (resultObject)
         {
             id responseObject = [resultObject initWithJsonObject:json];
             if (handler != nil)
                 handler(responseObject, connectionError);
         }
     }];
}

- (void) requestApplications: (void (^)(NSArray* applications, NSError* connectionError)) onCompletion
{
    [self requestApplications:onCompletion withCredentials:self.credentials];
}

- (void) requestApplications: (void (^)(NSArray* applications, NSError* connectionError)) onCompletion withCredentials: (ApiCredentials*)credentials
{
    [self requestForEndpoint:@"applications" withResultObject:[Application alloc] onCompletion:^(id result, NSError *connectionError) {
        if (onCompletion != nil)
            onCompletion((NSArray*)result, connectionError);
        
    } withCredentials: credentials ];
}

- (void) requestProfile: (void (^)(UserProfile* userProfile, NSError* connectionError)) onCompletion
{
    [self requestProfile:onCompletion withCredentials:self.credentials];
}

- (void) requestProfile: (void (^)(UserProfile* userProfile, NSError* connectionError)) onCompletion withCredentials: (ApiCredentials*)credentials
{
    [self requestForEndpoint:@"profile" withResultObject:[UserProfile alloc] onCompletion:^(id result, NSError *connectionError) {
        if (onCompletion != nil)
            onCompletion((UserProfile*)result, connectionError);
        
    } withCredentials: credentials ];
}

- (void) updateAppUser: (AppUser*)appUser
{
    [self updateAppUser:appUser withCredentials:self.credentials];
}

- (void) updateAppUser: (AppUser*)appUser withCredentials: (ApiCredentials*)credentials
{
    AppUserUpdateRequest* updateRequest = [AppUserUpdateRequest new];
    updateRequest.userMetadata = self.appUser.userMetadata;
    
    [self requestForEndpoint:@"appUser" withObject:updateRequest withResultObject:nil onCompletion:nil withCredentials: credentials ];
}


@end