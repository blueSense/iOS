//
//  ContentManagement.m
//  ProximitySenseSDK
//
//  Created by Vladimir Petrov on 28/08/2015.
//  Copyright (c) 2015 Blue Sense Networks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContentManagement.h"
#import "ProximitySenseSDK.h"
#import "ApiOperations.h"

@implementation ContentManagement

+ (ContentManagement *) instance
{
    static ContentManagement *_instance = nil;
    
    @synchronized (self)
    {
        if (_instance == nil)
        {
            _instance = [[self alloc] init];
        }
    }
    
    return _instance;
}

- (void) getPublications:(void (^)(NSArray *, NSError *))onCompletion
{
    [self getPublications:onCompletion withQuery:[[GetPublicationsRequest alloc] init]];
}

- (void) getPublications:(void (^)(NSArray *, NSError *))onCompletion withQuery:(GetPublicationsRequest *)getPublicationsRequest
{
    [[ProximitySenseSDK Api] requestForEndpoint:@"integrations/ContentManagement/publications" withObject:getPublicationsRequest withResultObject:[Publication alloc] onCompletion:^(id result, NSError *connectionError) {
        if (onCompletion != nil)
            onCompletion((NSArray*)result, connectionError);
    }];
}

@end
