//
//  AudienceMonitor.m
//  ProximitySenseSDK
//
//  Created by Vladimir Petrov on 28/08/2015.
//  Copyright (c) 2015 Blue Sense Networks. All rights reserved.
//

#import "AudienceMonitor.h"
#import "ProximitySenseSDK.h"
#import "ApiOperations.h"

@implementation AudienceMonitor

+ (AudienceMonitor *) instance
{
    static AudienceMonitor *_instance = nil;
    
    @synchronized (self)
    {
        if (_instance == nil)
        {
            _instance = [[self alloc] init];
        }
    }
    
    return _instance;
}

- (void) sendMessage:(SendMessageRequest*) messageRequest
{
    [self sendMessage:messageRequest withCompletion:nil];
}

- (void) sendMessage:(SendMessageRequest*) messageRequest withCompletion:(void (^)(NSError *))onCompletion
{
    [[ProximitySenseSDK Api] requestForEndpoint:@"extensions/audienceMonitor/messages" withObject:messageRequest withResultObject:[[NSObject alloc] init] onCompletion:^(id result, NSError *connectionError)
     {
         if (onCompletion)
             onCompletion(connectionError);
     }];
}

@end