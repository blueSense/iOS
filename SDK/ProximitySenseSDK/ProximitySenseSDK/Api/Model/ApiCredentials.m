//
//  ApiCredentials.m
//  BlueBar Service App
//
//  Created by Vladimir Petrov on 23/02/2014.
//  Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import "ApiCredentials.h"

@implementation ApiCredentials

- (id) initWithApplicationId:(NSString *)applicationId andPrivateKey:(NSString *)privateKey
{
    self = [super init];
    if (self)
    {
        self.applicationId = applicationId;
        self.clientId = applicationId;
        self.privateKey = privateKey;
    }

    return self;
}

@end
