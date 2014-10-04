//
//  BeaconConfiguration.h
//  BlueBar Service App
//
//  Created by Vladimir Petrov on 04/02/2014.
//  Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeaconConfiguration : NSObject

@property (nonatomic, copy) NSString *serial;
@property (strong, nonatomic) NSNumber *battery;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pin;
@property (nonatomic, copy) NSString *uuid;
@property (strong, nonatomic) NSNumber *major;
@property (strong, nonatomic) NSNumber *minor;
@property (strong, nonatomic) NSNumber *advertisementInterval;
@property (strong, nonatomic) NSNumber *signalStrength;
@property (strong, nonatomic) NSNumber *calibrationValue;

@property BOOL isEnabled;
@property BOOL initialSetupDone;
@property BOOL startedInitialSetup;

@property BOOL isInSync;

@end
