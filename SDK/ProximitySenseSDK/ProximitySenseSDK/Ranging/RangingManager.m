//
// Created by Vladimir Petrov on 08/06/2014.
// Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "RangingManager.h"
#import "ProximitySenseSDK.h"

NSString *RangingResponse = @"RangingManager_RangingResponse";

typedef void(^BackgroundCompletionHandler)(UIBackgroundFetchResult);

@implementation RangingManager
{
@private
    CLLocationManager* locationManager;
    CLBeaconRegion *beaconRegion;
    NSTimer             *timer;
    BackgroundCompletionHandler backgroundCompletionHandler;
    NSString* startedForUuid;
}

+ (RangingManager *) instance
{
    static RangingManager *_instance = nil;

    @synchronized (self)
    {
        if (_instance == nil)
        {
            _instance = [[self alloc] init];
            _instance.canPromptUserForLocationServicesAuthorization = YES;
        }
    }

    return _instance;
}

- (void)startForUuid:(NSString *)uuid
{
    startedForUuid = uuid;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    // Check if beacon monitoring is available for this device
    if (![CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
        return;
    }

    if (self.canPromptUserForLocationServicesAuthorization && NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1)
    {
        CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
        if (authStatus < kCLAuthorizationStatusAuthorizedAlways)
            [locationManager requestAlwaysAuthorization];
    }

    NSUUID *nsUuid = [[NSUUID alloc] initWithUUIDString:uuid];

    beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:nsUuid identifier:@"ProximitySense Beacon Region"];
    beaconRegion.notifyEntryStateOnDisplay = YES;
    beaconRegion.notifyOnEntry = YES;
    beaconRegion.notifyOnExit = YES;

    // Tell location manager to start monitoring for the beacon region
    [locationManager startMonitoringForRegion:beaconRegion];
    [locationManager startRangingBeaconsInRegion:beaconRegion];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                             target:self
                                           selector:@selector(onTick:)
                                           userInfo:nil
                                            repeats:YES];
}

- (void)locationManager:(CLLocationManager*)manager didEnterRegion:(CLRegion *)region
{
    [locationManager startRangingBeaconsInRegion:beaconRegion];
}

-(void)locationManager:(CLLocationManager*)manager didExitRegion:(CLRegion *)region
{
}

-(void)locationManager:(CLLocationManager*)manager
       didRangeBeacons:(NSArray*)beacons
              inRegion:(CLBeaconRegion*)region
{
    [[ProximitySenseSDK Api] reportBeaconSightings:beacons];
}

-(void) onTick:(NSTimer*)t
{
    [[ProximitySenseSDK Api] pollForAvailableActionResults];
}

- (void)stop
{
    [locationManager stopRangingBeaconsInRegion:beaconRegion];
    [locationManager stopMonitoringForRegion:beaconRegion];
    
    [timer invalidate];
    timer = nil;
    startedForUuid = nil;
}

- (void) lookAroundFor:(NSInteger)seconds completion:(void (^)(UIBackgroundFetchResult))completionHandler
{
    if (startedForUuid)
    {
        NSString* uuid = startedForUuid;
        [self stop];
        [self startForUuid:uuid];
    }

    backgroundCompletionHandler = completionHandler;
    timer = [NSTimer scheduledTimerWithTimeInterval:seconds
                                             target:self
                                           selector:@selector(stopLooking:)
                                           userInfo:nil
                                            repeats:YES];
}

-(void) stopLooking:(NSTimer*)t
{
    if (backgroundCompletionHandler)
        backgroundCompletionHandler(UIBackgroundFetchResultNewData);
}

@end