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
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pin;
@property (nonatomic, copy) NSString *uuid;
@property NSInteger major;
@property NSInteger minor;
@property NSInteger advertisementInterval;
@property NSInteger signalStrength;
@property NSInteger calibrationValue;
@property BOOL isEnabled;
@property BOOL initialSetupDone;
@property BOOL startedInitialSetup;

@property BOOL isInSync;

@end
