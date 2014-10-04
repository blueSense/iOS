/*
 Abstract: Scan for, discover and connect to nearby BlueBar beacons.
 
 Version: 1.0
 Copyright (C) 2014 Blue Sense Networks ltd. All Rights Reserved.
*/

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BeaconConfigurationService.h"

@class DetectedBeacon;

@protocol BeaconConnectionDelegate <NSObject>

@optional
    - (void) connectedToBeacon:(DetectedBeacon*)beacon;
    - (void) disconnectedFromBeacon:(DetectedBeacon *)beacon withError:(NSError *)error;
    - (void) failedToConnect:(DetectedBeacon *)beacon withError:(NSError *)error;
@end


@protocol BeaconDiscoveryDelegate <NSObject>

@optional

    - (void) discoveryDidRefresh:(CBCentralManagerState)state;
    - (void) discoveryStatePoweredOff;
    - (void) discoveredBeacon:(DetectedBeacon*)beacon;
@end


@interface BeaconDiscovery : NSObject

    + (id) instance;

    @property (nonatomic, assign) id<BeaconDiscoveryDelegate>   discoveryDelegate;
    @property (nonatomic, assign) id<BeaconConnectionDelegate>   connectionDelegate;
    @property (nonatomic, assign, readonly) CBCentralManagerState   state;

    - (void) startScanning;
    - (void) stopScanning;

    - (void) connectBeacon:(DetectedBeacon*)beacon;
    - (void) disconnectBeacon:(DetectedBeacon*)beacon;

@end
