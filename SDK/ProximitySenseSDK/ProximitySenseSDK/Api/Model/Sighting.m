//
// Created by Vladimir Petrov on 08/06/2014.
// Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import "Sighting.h"

@implementation Sighting
{

}

@synthesize uuid;
@synthesize major;
@synthesize minor;
@synthesize rssi;
@synthesize proximity;

- (id)initWithBeacon:(CLBeacon *)beacon
{
    self = [super init];
    if (self)
    {
        self.uuid = beacon.proximityUUID.UUIDString;
        self.major = beacon.major;
        self.minor = beacon.minor;
        self.rssi = [[NSNumber alloc] initWithInteger:beacon.rssi];
        self.proximity = [Sighting stringForProximity:[beacon proximity]];
    }

    return self;
}

+ (instancetype)sightingWithBeacon:(CLBeacon *)beacon
{
    return [[self alloc] initWithBeacon:beacon];
}

+ (NSString *)stringForProximity:(CLProximity)proximity {
    switch (proximity)
    {
        case CLProximityUnknown:    return @"Unknown";
        case CLProximityFar:        return @"Far";
        case CLProximityNear:       return @"Near";
        case CLProximityImmediate:  return @"Immediate";
        default:
            return nil;
    }
}

@end