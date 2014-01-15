//
//  BSNViewController.m
//  BlueBar iBeacon Demo
//
//  Created by Vladimir Petrov on 15/01/2014.
//  Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import "BSNViewController.h"

@interface BSNViewController ()

@end

@implementation BSNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Initialize location manager and set ourselves as the delegate
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    // Create a NSUUID with the same UUID as the broadcasting beacon
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"A0B13730-3A9A-11E3-AA6E-0800200C9A66"];
    
    // Setup a new region with that UUID and same identifier as the broadcasting beacon
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                             identifier:@"BlueBar Beacon Region"];
    
    // Tell location manager to start monitoring for the beacon region
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    
    // Check if beacon monitoring is available for this device
    if (![CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Monitoring not available" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil]; [alert show]; return;
    }

    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)displayImage:(NSString*) imageName
{
    NSString* fullPath = [imageName stringByAppendingString:@"@2x.png"];

    self.offerDisplay.image = [UIImage imageNamed: fullPath];
}

- (void)locationManager:(CLLocationManager*)manager didEnterRegion:(CLRegion *)region
{
    // Entered a region
}

-(void)locationManager:(CLLocationManager*)manager didExitRegion:(CLRegion *)region
{
    // Exited the region
}

-(void)locationManager:(CLLocationManager*)manager
       didRangeBeacons:(NSArray*)beacons
              inRegion:(CLBeaconRegion*)region
{
    // Beacon found!
    CLBeacon *foundBeacon = [beacons firstObject];
    
    if (foundBeacon.proximity == CLProximityImmediate)
        [self displayImage:@"Offer"];
    else
        [self displayImage:@"Welcome"];
    
    // You can retrieve the beacon data from its properties
    //NSString *uuid = foundBeacon.proximityUUID.UUIDString;
    //NSString *major = [NSString stringWithFormat:@"%@", foundBeacon.major];
    //NSString *minor = [NSString stringWithFormat:@"%@", foundBeacon.minor];
}

@end
