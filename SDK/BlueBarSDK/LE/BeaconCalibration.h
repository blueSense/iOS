//
//  BeaconCalibration.h
//  BlueBarSDK
//
//  Created by Vladimir Petrov on 09/10/2014.
//  Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DetectedBeacon;

@protocol BeaconCalibrationProgressDelegate <NSObject>

@optional
- (void) calibrationProgressChanged:(NSInteger)progress withRssi:(NSNumber*)currentRssi;
- (void) calibrationStarted;
- (void) calibrationStopped;
- (void) calibrationFinished:(NSInteger)calibratedValue;

@end


@interface BeaconCalibration : NSObject

+ (id) instance;

@property (nonatomic, assign) id<BeaconCalibrationProgressDelegate>   calibrationProgressDelegate;
@property (nonatomic) BOOL isCalibrating;

- (void) startCalibrationFor:(DetectedBeacon*)beacon;
- (void) stopCalibration;

@end
