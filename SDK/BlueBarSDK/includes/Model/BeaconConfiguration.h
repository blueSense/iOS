//
//  BeaconConfiguration.h
//  BlueBar Service App
//
//  Created by Vladimir Petrov on 04/02/2014.
//  Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeaconConfiguration : NSObject

@property (copy, nonatomic) NSString *serial;
@property (strong, nonatomic) NSNumber *batteryLevel;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *pin;
@property (copy, nonatomic) NSString *uuid;
@property (strong, nonatomic) NSNumber *major;
@property (strong, nonatomic) NSNumber *minor;
@property (strong, nonatomic) NSNumber *advertisementInterval;
@property (strong, nonatomic) NSNumber *signalStrength;
@property (strong, nonatomic) NSNumber *calibrationValue;

@property (nonatomic) BOOL isEnabled;
@property (nonatomic) BOOL initialSetupDone;
@property (nonatomic) BOOL startedInitialSetup;
@property (nonatomic) BOOL calibrationChanged;

@property (nonatomic) BOOL isInSync;
@property (nonatomic) BOOL shouldRefreshBattery;
@property (nonatomic) BOOL notOwnedByUser;

@end
