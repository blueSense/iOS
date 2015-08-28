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



- (void) sendRequest:(void (^)(NSError *))onCompletion
{
    [[ProximitySenseSDK Api] requestForEndpoint:@"integrations/audienceMonitor/requests" withResultObject:[NSObject alloc]
                                   onCompletion:^(id result, NSError *connectionError)
    {
        if (onCompletion != nil)
            onCompletion(connectionError);
    }];
}

@end