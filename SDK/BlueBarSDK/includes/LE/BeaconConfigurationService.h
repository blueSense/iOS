/*
 Abstract: BlueBar Beacon configuration service.

 Version: 1.0
 Copyright (C) 2014 Blue Sense Networks ltd. All Rights Reserved.
*/

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BeaconConfiguration.h"

@protocol BeaconConfigurationServiceDelegate <NSObject>

@optional
    - (void) doneReading;
    - (void) doneWriting;

    - (void) errorWritingCharacteristic:(NSError*)error;
    - (void) errorBadPin;

@end

@class BeaconConfigurationService;
@class DetectedBeacon;

@interface BeaconConfigurationService : NSObject

    @property (nonatomic, assign) id<BeaconConfigurationServiceDelegate> serviceDelegate;

    - (id) initWithBeacon:(DetectedBeacon *)beacon;
    - (void) updateConfiguration:(BeaconConfiguration *)configuration;

    - (void) reset;
    - (void) start;

    @property (nonatomic, copy) NSString *uuid;
    @property ( nonatomic ) NSInteger major;
    @property ( nonatomic ) NSInteger minor;
    @property ( nonatomic ) NSInteger advertisementInterval;
    @property ( nonatomic ) NSInteger signalStrength;
    @property ( nonatomic ) NSInteger battery;

@end
