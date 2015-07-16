//
//  ApiSession.m
//  BlueBarSDK
//
//  Created by Vladimir Petrov on 12/09/2014.
//  Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import "AppUser.h"
#import "ProximitySenseSDK.h"

@implementation AppUser

- (id) init
{
    self = [super init];
    if (self)
    {
        self.appSpecificId = @"Default - Id Not Set";
    }
    
    return self;
}

- (void) setUserMetadata:(NSDictionary *)userMetadata
{
    _userMetadata = userMetadata;
    [[ProximitySenseSDK Api] updateAppUser: self];
}

@end
