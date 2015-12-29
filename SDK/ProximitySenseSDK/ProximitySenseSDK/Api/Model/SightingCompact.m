//
//  SightingCompact.m
//  ProximitySenseSDK
//
//  Created by Vladimir Petrov on 05/10/2015.
//  Copyright © 2015 Blue Sense Networks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SightingCompact.h"

@implementation SightingCompact
{
    
}

@synthesize uuid;
@synthesize d;

- (id)initFromSighting:(Sighting *)sighting
{
    self = [super init];
    if (self)
    {
        self.uuid = sighting.uuid;
        self.d = @[[NSString stringWithFormat:@"%@;%@;%@;%@", sighting.major.stringValue, sighting.minor.stringValue, sighting.proximity, sighting.rssi]];
    }
    
    return self;
}

@end