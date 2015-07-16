//
// Created by Vladimir Petrov on 08/06/2014.
// Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLBeaconRegion.h>

@interface Sighting : NSObject

@property ( nonatomic, strong ) NSString * uuid;
@property ( nonatomic, strong ) NSNumber * major;
@property ( nonatomic, strong ) NSNumber * minor;
@property ( nonatomic, strong ) NSNumber * rssi;
@property ( nonatomic, strong ) NSString * proximity;

- (id)initWithBeacon:(CLBeacon *)beacon;
+ (id)sightingWithBeacon:(CLBeacon *)beacon;

@end