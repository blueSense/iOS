//
//  PersistentConnectionApi.m
//  ProximitySenseSDK
//
//  Created by Vladimir Petrov on 31/12/2015.
//  Copyright © 2015 Blue Sense Networks. All rights reserved.
//

@import AdSupport;
#import "PersistentConnectionApi.h"
#import "ProximitySenseSDK.h"
#import "SRWebSocket.h"
#import "ApiUtility.h"
#import "NSObject+BSN_GFJson.h"

#import "ActionBase.h"
#import "ActionResponse.h"

static NSString* const HttpHeader_Authorization_ClientId = @"X-Authorization-ClientId";
static NSString* const HttpHeader_Authorization_Signature = @"X-Authorization-Signature";
static NSString* const HttpHeader_ProximitySense_SdkPlatformAndVersion = @"X-ProximitySense-SdkPlatformAndVersion";
static NSString* const HttpHeader_ProximitySense_AppUserId = @"X-ProximitySense-AppUserId";
static NSString* const HttpHeader_ProximitySense_DeviceId = @"X-ProximitySense-DeviceId";


@interface PersistentConnectionApi () <NSObject, SRWebSocketDelegate>
@end

@implementation PersistentConnectionApi
{
    @private
    NSString* connectionId;
    SRWebSocket* webSocket;
    NSString* baseUrl;
    ApiCredentials* credentials;

}

- (id) init
{
    self = [super init];
    if (self)
    {
        connectionId = nil;
        webSocket = nil;
        baseUrl = nil;
        credentials = nil;
    }
    
    return self;
}


- (BOOL) isConnected
{
    return webSocket != nil && webSocket.readyState == SR_OPEN;
}

- (NSMutableURLRequest*) prepareGetRequest:(NSString*)url
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    
    NSString* signature = [ApiUtility computeSHA256DigestForString:[NSString stringWithFormat:@"%@%@", url, credentials.privateKey]];
    
    [request setValue:credentials.applicationId forHTTPHeaderField:HttpHeader_Authorization_ClientId];
    [request setValue:signature forHTTPHeaderField:HttpHeader_Authorization_Signature];

    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [request setValue:adId forHTTPHeaderField:HttpHeader_ProximitySense_DeviceId];
    
    return request;
}

- (BOOL) openConnection
{
    [self close];
    
    connectionId = [[[NSUUID UUID] UUIDString] substringFromIndex:24];

    NSString * url =[NSString stringWithFormat:@"%@%@", baseUrl,  @"clients"];
    
    NSMutableURLRequest* request = [self prepareGetRequest:url];
    NSURL* wsUrl = [[NSURL alloc] initWithString:[url stringByReplacingOccurrencesOfString:@"http" withString:@"ws"]];
    request.URL = wsUrl;
    
    webSocket = [[SRWebSocket alloc] initWithURLRequest: request];
    webSocket.delegate = self;
    
    [webSocket open];
    
    return self.isConnected;
}

- (void) startWithUrl:(NSString*)apiBaseUrl andCredentials:(ApiCredentials*)apiCredentials;
{
    baseUrl = apiBaseUrl;
    credentials = apiCredentials;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appActivated:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnteredBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [self openConnection];
}

- (void)appActivated: (NSNotification*)notification
{
    if (baseUrl != nil && credentials != nil)
        [self openConnection];
}

- (void)appEnteredBackground: (NSNotification*)notification
{
    [self close];
}

- (void) close
{
    if (webSocket == nil)
        return;
    
    [webSocket close];
    webSocket = nil;
}

- (void) webSocketDidOpen:(SRWebSocket *)webSocket
{
    NSLog(@"(%@): webSocket DID open!", connectionId);
}

- (void) webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    NSLog(@"(%@): webSocket DID Close!", connectionId);
}

- (void) webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@"(%@): webSocket Failed! - %@", connectionId, error.localizedDescription);
    
    [self close];
    
//    [self openConnection];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSLog(@"(%@): webSocket Got Message - %@", connectionId, message);
    
    NSData* data = [(NSString*)message dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if (json == nil)
        return;
    
    id actionResponse = [[ActionResponse alloc] initWithJsonObject:json];
    id actionResult = [ActionBase parseActionResponse:actionResponse];
    [[NSNotificationCenter defaultCenter] postNotificationName:ApiNotification_ActionReceived object:actionResult];
}

- (void) sendMessage:(NSObject*)message
{
    if (!self.isConnected && ![self openConnection])
        return;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:message.jsonObject options:0 error:nil];
    NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [webSocket send:json];
}

@end