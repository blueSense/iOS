//
//  DetectedBeacon.h
//  BlueBar Service App
//
//  Created by Vladimir Petrov on 01/02/2014.
//  Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BeaconConfiguration.h"
#import "BeaconConfigurationService.h"

@interface DetectedBeacon : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *serial;
@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, strong) BeaconConfiguration *configuration;
@property (nonatomic, strong) BeaconConfigurationService *service;

@property (nonatomic, copy) NSNumber* RSSI;

@end
